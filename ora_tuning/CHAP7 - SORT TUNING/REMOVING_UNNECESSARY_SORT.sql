/*  [불필요 소트 제거]
*/

-- 1. 집합 연산자에서 소트 방지하기

-- 1.1 UNION을 사용하는 경우
EXPLAIN PLAN FOR
SELECT * FROM ITEM WHERE ITEM_ID = 10
UNION
SELECT * FROM ITEM WHERE ITEM_ID = 50;

-- 1.2 UNION ALL 사용 시
-- 중복값이 없어서 UNION ALL로 대체해도 결과에 차이가 없다면 대체하여 HASH 또는 SORT GRUOP BY 연산 생략 가능
EXPLAIN PLAN FOR
SELECT * FROM ITEM WHERE ITEM_ID = 10
UNION ALL
SELECT * FROM ITEM WHERE ITEM_ID = 50;

-- 2. IN절 내부에 서브쿼리가 있는 경우 (=> SORT UNIQUE 연산 발생)
-- >> IN 대신 EXISTS문 사용
-- EXISTS : 메인쿼리 결과 -> 서브쿼리에 대입, 비교 후 결과 출력. 조건에 해당하는 행 존재유무 확인 후 더이상 수행 안함.
-- IN : 서브쿼리 결과 -> 메인쿼리에 대입, 비교 후 결과 출력


-- 확인
SELECT * FROM TABLE ( DBMS_XPLAN.DISPLAY );