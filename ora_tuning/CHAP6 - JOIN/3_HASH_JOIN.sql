/*  [HASH JOIN] P.125
    - 해시 알고리즘을 사용해 조인되는 두 테이블 중 작은 테이블에 대한 해시맵 생성
    - 작은 테이블(BUILD INPUT), 큰 테이블(PROBE INPUT)
    - 조인조건을 해시맵의 키로 사용, PROBE INPUT을 탐색하며 조인조건에 대한 해시맵의 VALUE 병합
    - BUILD INPUT이 되는 테이블에서 조인컬럼에 대한 중복값이 많으면 성능 저하
*/