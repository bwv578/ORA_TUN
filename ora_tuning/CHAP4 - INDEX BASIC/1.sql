/*
    [인덱스의 특징] P.76
    정렬을 인덱스로 대체하려는 경우, 컬럼에 NOT NULL 제약 조건이 별도로 없거나 WHERE절에서 NULL을 걸러넬 추가조건을
    주지 않을 경우 오라클은 NULL인 데이터가 있을 것이라고 판단, 인덱스를 통해 전체 데이터를 가져오지 못하므로 인덱스를
    통한 정렬 불가.
    -> INDEX FULL SCAN 대신 TABLE FULL SCAN 하게 됨(SORT ORDER BY 연산 추가).
*/

-- ITEM_NM 을 이용해 ITEM 테이블의 인덱스 생성
DROP INDEX ITEM_X01;
CREATE INDEX ITEM_X01 ON ITEM (ITEM_NM);



-- (1) 인덱스가 존재하고 WHERE 절에서 NULL데이터가 정제되는 경우의 실행계획
EXPLAIN PLAN FOR
    SELECT * FROM ITEM WHERE ITEM_NM LIKE '%버거%' ORDER BY ITEM_NM;

SELECT * FROM TABLE ( DBMS_XPLAN.DISPLAY );


-- (2) 인덱스가 존재하지만 ITEM_NM이 NULL인 경우를 정제할 조건이 없을 때
EXPLAIN PLAN FOR
    SELECT ITEM_NM FROM ITEM ORDER BY ITEM_NM;

SELECT * FROM TABLE ( DBMS_XPLAN.DISPLAY );

-- (2)의 경우에서 WHERE절을 추가해 개선
EXPLAIN PLAN FOR
    SELECT ITEM_NM FROM ITEM WHERE ITEM_NM IS NOT NULL ORDER BY ITEM_NM;

SELECT * FROM TABLE ( DBMS_XPLAN.DISPLAY );


/*
    [ROWID 개념] P.77
    행의 고유값 (오브젝트번호 + 파일번호 + 블록번호 + 로우번호)
    특정 컬럼을 통해 테이블의 인덱스를 생성하면 인덱스는 해당컬럼값과 ROWID로 구성이 된다.

    -> 특정 컬럼값과 매칭되는 ROWID를 통해 해당 ROW에 바로 접근 가능.
    -> 행의 ROWID를 알고있다면 인덱스를 통하지 않고도 바로 행에 접근 가능.
*/

-- ROWID 보기
SELECT ROWID, ITEM_ID, ITEM_NM FROM ITEM;

-- ROWID를 통해 특정 행에 접근
SELECT * FROM ITEM WHERE ROWID = 'AAASgEAASAAAACDAAI';