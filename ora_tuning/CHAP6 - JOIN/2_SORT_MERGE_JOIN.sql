/*  [SORT MERGE JOIN] P.120
    - 먼저 조인되는 두 테이블을 각각 조건에 맞게 읽고 조인컬럼 기준으로 정렬
    - NL조인과 다르게 각 테이블을 조건에 따라 거르고 두개의 데이터를 만들어놓고 조인 시도
    - PGA(프로세스에 할당된 독립된 공간) 에서 수행됨 -> 버퍼캐시(SGA)에서 수행되는 NL조인보다 데이터 접근 빠름
*/

-- 인덱스 상태
DROP INDEX ITEM_X01;
CREATE INDEX ITEM_X01 ON ITEM (ITEM_TYPE_CD);
-- UITEM 인덱스 없음

EXPLAIN PLAN FOR
SELECT /*+ ORDERED USE_MERGE(B) */
    A.*
    , B.*
FROM
    ITEM A, UITEM B
WHERE
    A.ITEM_ID = B.ITEM_ID -- (1)
    AND A.ITEM_TYPE_CD = '100101' -- (2)
    AND A.SALE_YN = 'Y' -- (3)
    AND B.SALE_YN = 'Y'; -- (4)

/*  <실행순서>
    먼저 ITEM 테이블과 UITEM 테이블이 ITEM_ID 컬럼을 기준으로 정렬되어 읽혀진다
    (2): ITEM_X01 인덱스로 특정 범위 스캔
    (3): SALE_YN 컬럼으로 필터링
    (4): UITEM 테이블을 SALE_YN 컬럼으로 필터링하고 조인할 데이터 생성
    (1): 조인 시도
*/

-- 확인
SELECT * FROM TABLE ( DBMS_XPLAN.DISPLAY );
SELECT * FROM TABLE ( DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ADVANCED ALLSTATS LAST') );