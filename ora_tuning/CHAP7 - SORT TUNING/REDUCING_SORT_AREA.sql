/*  [소트 영역 줄이기]
    - sort area(정렬할 대상 영역)은 행과 열 갯수를 결정한다
*/

EXPLAIN PLAN FOR
SELECT *
FROM ITEM, (SELECT LEVEL FROM DUAL CONNECT BY LEVEL < 10000);

SELECT * FROM TABLE ( DBMS_XPLAN.DISPLAY );



SELECT LEVEL AS depth, 'Node ' || LEVEL AS node_name
FROM DUAL
CONNECT BY LEVEL <= 5;