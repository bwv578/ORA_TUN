/*
    [튜닝 1]
    * 인덱스 스캔 후 WHERE 절에 의해 필터링이 수행되는 경우
        -> 인덱스의 ROWID를 통해 테이블에 랜덤 액세스해서 실제 데이터의 조건 만족 여부 확인
        -> 랜덤 액세스 양 대비 실제 선별되는 결과집합의 양이 현저히 작으면 비효율적임
        -> 기존 인덱스에 해당 컬럼 데이터를 추가 >> 테이블 랜덤 엑세스 없이 인덱스에서 필터링하게 만들면 효율적임
*/

-- (1) 기존 (ORD_X01 -> ORD_DT + ORD_HMS)
EXPLAIN PLAN FOR

SELECT COUNT(UPPER_CASE)
FROM ORD
WHERE
    ORD_DT BETWEEN '20120101' AND '20120228' -- INDEX RANGE SCAN
    AND SHOP_NO = 'SH0001'; -- SHOP_NO 조건의 필터링은 테이블에 랜덤 액세스해서 수행된다.


-- (2) 예시로 ORD_X01 인덱스에 SHOP_NO 컬럼이 추가된 ORD_X02 인덱스 생성 후 테스트
CREATE INDEX ORD_X02 ON ORD (ORD_DT, ORD_HMS, SHOP_NO);
EXPLAIN PLAN FOR

SELECT COUNT(UPPER_CASE)
FROM ORD
WHERE
    ORD_DT BETWEEN '20120101' AND '20120228' -- INDEX RANGE SCAN
  AND SHOP_NO = 'SH0001';

DROP INDEX ORD_X02;

-- 확인
ALTER SYSTEM SET STATISTICS_LEVEL = TYPICAL;
ALTER SESSION SET "_ROWSOURCE_EXECUTION_STATISTICS"=TRUE;
SELECT * FROM TABLE ( DBMS_XPLAN.DISPLAY );
SELECT * FROM TABLE ( DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ADVANCED ALLSTATS LAST') );



/*
    [튜닝2]
    * 인덱스 스캔 범위 계산
     - 조건절의 형태가 범위인지 등치인지 여부에 따라서 스캔 방식이 달라짐
     - 따라서 조건절이 여러개로 이루어진 경우 사용하는 인덱스의 종류에 따라서 수행시 퍼포먼스가 크게 차이날 수 있음
*/

-- 컬럼 순서가 다른 두개의 인덱스 생성
DROP INDEX ORD_X02;
DROP INDEX ORD_X03;
CREATE INDEX ORD_X02 ON ORD (ORD_DT, SHOP_NO);
CREATE INDEX ORD_X03 ON ORD (SHOP_NO, ORD_DT);

-- ORD_X02 인덱스를 사용하는 경우
EXPLAIN PLAN FOR
SELECT * /*+ INDEX(ORD ORD_X02) */
FROM ORD
WHERE ORD_DT BETWEEN '20120101' AND '20120131'
AND SHOP_NO = 'SH0001'; -- ORD_DT 기준값으로 범위스캔을 하고 등치조건인 SHOP_NO는 필터링 조건으로 사용된다.

-- ORD_X03 인덱스를 사용하는 경우
EXPLAIN PLAN FOR
SELECT * /*+ INDEX(ORD ORD_X03) */
FROM ORD
WHERE ORD_DT BETWEEN '20120101' AND '20120131'
AND SHOP_NO = 'SH0001'; -- 해당 매장번호에 대한 주문일자 범위만 스캔한다.

-- 확인
SELECT * FROM TABLE ( DBMS_XPLAN.DISPLAY );
SELECT * FROM TABLE ( DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ADVANCED ALLSTATS LAST') );