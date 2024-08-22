-- 상품의 가격(세트상품의 경우 단품가격의 총합) 출력
SELECT
    I.ITEM_ID
     , I.ITEM_NM
     , SUM(UP.SALE_PRICE)
FROM
    ITEM I
   , UITEM_PRICE UP
WHERE
    I.ITEM_ID = UP.ITEM_ID
  AND ROWNUM <= 100
GROUP BY I.ITEM_ID, I.ITEM_NM
ORDER BY I.ITEM_ID;


-- ITEM 테이블에서 ID, NM, 자신과 같은 이름을 가진 행 수 출력
SELECT
    I.ITEM_ID
     , I.ITEM_NM
     , (
    SELECT
        COUNT(*)
    FROM ITEM
    WHERE
        ITEM_NM = I.ITEM_NM
) CNT
FROM
    ITEM I
ORDER BY
    CNT DESC;


-- ITEM 테이블에서 중복되는 상품명을 가진 항목 조회
WITH NMCNT AS (
    SELECT
        I.ITEM_ID ID
         , I.ITEM_NM NM
         , (SELECT COUNT(*) FROM ITEM WHERE ITEM_NM = I.ITEM_NM) CNT
    FROM
        ITEM I
)

SELECT
    ID
     , NM
     , CNT
FROM
    NMCNT
WHERE 1=1
  AND CNT > 1;