/*  [NL JOIN] P.116
    - NESTED LOOP (중첩된 반복문) 을 사용하는 조인 방식
    - 드라이빙(OUTER) 테이블 에서 읽은 결과를 INNER 테이블로 건건이 조인 시도
    - ORDERED USE_NL() 힌트를 통해 유도 가능
        @ ORDERED : FROM 절에 나열된 순서대로 테이블 읽도록 명령
        @ USE_NL(테이블명) : 해당 테이블과 조인할때 NL 조인 사용
*/


-- 다음과 같은 인덱스가 있다고 가정
-- UITEM_PK -> ITEM_ID + UITEM_ID
DROP INDEX ITEM_X01;
CREATE INDEX ITEM_X01 ON ITEM (ITEM_TYPE_CD);

EXPLAIN PLAN FOR
SELECT /*+ ORDERED USE_NL(B) */
    A.*
    , B.*
FROM
    ITEM A, UITEM B
WHERE
    A.ITEM_ID = B.ITEM_ID -- (1)
    AND A.ITEM_TYPE_CD = '100100' -- (2)
    AND A.SALE_YN = 'Y' -- (3)
    AND B.SALE_YN = 'Y'; -- (4)

/*  <실행순서>
    (2) : 인덱스 ITEM_X01 을 통해 특정된 인덱스 범위에 접근
    (3) : 특정된 인덱스집합에 대해 테이블 랜덤 엑세스, SALE_YN 조건에 따른 결과집합 생성
    (1) : A 의 결과집합과 B 간에 NL조인
    (4) : 조인 결과에서 SALE_YN 조건으로 필터링 후 최종 결과집합 생성 */

-- 확인
SELECT * FROM TABLE ( DBMS_XPLAN.DISPLAY );
SELECT * FROM TABLE ( DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ADVANCED ALLSTATS LAST') );