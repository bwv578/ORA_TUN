/*
    [INDEX FAST FULL SCAN]
    -인덱스 스캔 방식 중 유일하게 멀티블록 I/O 방식으로 스캔
    -논리적 인덱스 트리 구조를 무시하고 인덱스 세그먼트 전체를 스캔 => 더 빠르게 작동
    -하지만 인덱스 리프 노드가 갖는 연결 리스트 구조를 무시하고 물리적인 디스크에 저장된 순서대로 리프 블록들을
     읽어내기 때문에 결과집합이 인덱스 키 순으로 정렬되어있지 않음.
    -관련힌트: INDEX_FFS, NO_INDEX_FFS 등
*/


-- 아래 SQL문이 INDEX FAST FULL SCAN 으로 작동하려면 PK 인덱스 또는 NOT NULL 컬럼이 포함된 인덱스 필요
EXPLAIN PLAN FOR
SELECT COUNT(*) FROM ORD;

SELECT * FROM TABLE ( DBMS_XPLAN.DISPLAY );
