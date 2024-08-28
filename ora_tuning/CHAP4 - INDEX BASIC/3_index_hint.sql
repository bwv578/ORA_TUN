/*
    [인덱스 스캔 유도방법] p.86
    힌트 사용하기
    * INDEX: 인덱스 스캔 유도, 어떤 인덱스 쓸지는 오라클이 알아서
    * INDEX_DESC: 인덱스 거꾸로 스캔
    * INDEX_RS: INDEX RANGE SCAN 유도, 불가능하면 힌트 무시
    * INDEX_SS: INDEX SKIP SCAN 유도, 불가능하면 힌트 무시
*/

EXPLAIN PLAN FOR
SELECT * FROM ITEM WHERE ITEM_NM LIKE '%버거%' ORDER BY ITEM_NM DESC;

SELECT * FROM TABLE ( DBMS_XPLAN.DISPLAY );

EXPLAIN PLAN FOR
SELECT /*+ INDEX_DESC(ITEM ITEM_X01) */
    * FROM ITEM WHERE ITEM_NM LIKE '%버거%' ORDER BY ITEM_NM DESC;

SELECT * FROM TABLE ( DBMS_XPLAN.DISPLAY );

EXPLAIN PLAN FOR
SELECT /*+ INDEX_SS */
    * FROM ITEM;

SELECT * FROM TABLE ( DBMS_XPLAN.DISPLAY );
