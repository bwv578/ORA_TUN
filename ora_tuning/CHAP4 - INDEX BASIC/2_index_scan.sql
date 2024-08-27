/*
    [인덱스 스캔 방식] p.78
    1. INDEX UNIQUE SCAN
    2. INDEX RANGE SCAN
    3. INDEX FULL SCAN
    4. INDEX SKIP SCAN
*/

-- (1) INDEX UNIQUE SCAN
-- 루트블록에서 시작해 테이블 블록에서 최종 1건 데이터 찾기
-- 결과값이 1개임이 보장됨, 1번만 조회.
EXPLAIN PLAN FOR
    SELECT * FROM ITEM WHERE ITEM_ID = 11;

SELECT * FROM TABLE ( DBMS_XPLAN.DISPLAY );

-- (2) INDEX RANGE SCAN
-- 결합인덱스 (UITEM_PK) 존재하는 상황.
EXPLAIN PLAN FOR
    SELECT * FROM UITEM WHERE ITEM_ID = 89;

-- 상품명에 대한 인덱스가 존재하는 상황
-- 밀크셰이크로 시작하는 지점까지 인덱스 수직탐색
-- 밀크셰이크 다음지점까지 INDEX RANGE SCAN
EXPLAIN PLAN FOR
    SELECT * FROM ITEM WHERE ITEM_NM LIKE '밀크셰이크%';

-- 해당 인덱스에서 사용하는 컬럼이 조건절에서 범위로 명시된 경우
EXPLAIN PLAN FOR
    SELECT * FROM ITEM WHERE ITEM_ID BETWEEN 1 AND 10;

SELECT * FROM TABLE ( DBMS_XPLAN.DISPLAY );

-- (3) INDEX FULL SCAN / TABLE FULL SCAN
-- 스캔범위가 처음부터 마지막까지로 정해진 경우
-- 오라클에서는 인덱스에서 사용하는 모든 컬럼이 NULL 인 행은 저장되지 않음
-- > 조건절에 컬럼 IS NOT NULL 하면 사실상 모든 인덱스 범위.
EXPLAIN PLAN FOR
    SELECT * FROM ITEM WHERE ITEM_NM IS NOT NULL;

SELECT * FROM TABLE ( DBMS_XPLAN.DISPLAY );

EXPLAIN PLAN FOR
    SELECT * FROM ITEM;
SELECT * FROM TABLE ( DBMS_XPLAN.DISPLAY );

SELECT * FROM UITEM ORDER BY ITEM_ID, UITEM_ID;

-- (4) INDEX SKIP SCAN
-- 결합 컬럼 인덱스의 후행컬럼이 조건절에 나타날 때 선두컬럼의 스킵 조건으로 사용 가능
-- 선두컬럼의 값 종류가 적을때 효과적임
-- 값의 종류가 많으면 랜덤액세스 횟수도 많아져서 비효율적임
DROP INDEX ITEM_X02;
CREATE INDEX ITEM_X02 ON ITEM (ITEM_TYPE_CD, ITEM_NM);
EXPLAIN PLAN FOR
    SELECT ITEM_TYPE_CD FROM ITEM WHERE ITEM_NM LIKE '한우%';

SELECT * FROM TABLE ( DBMS_XPLAN.DISPLAY );