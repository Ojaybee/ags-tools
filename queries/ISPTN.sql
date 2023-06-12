SELECT
    ls.LOCA_ID AS "Exploratory Hole Location",
    CAST(it.ISPT_TOP AS FLOAT) AS "Depth to top of test",
    it.ISPT_NVAL AS "SPT 'N' value",
    substr(gs.GEOL_LEG, 1, 1) AS "Geological group at ISPT_TOP",
    ls.geom
FROM
    loca_spatial ls
JOIN
    GEOL gs ON ls.LOCA_ID = gs.LOCA_ID
JOIN
    ISPT it ON ls.LOCA_ID = it.LOCA_ID
WHERE
    CAST(it.ISPT_TOP AS FLOAT) >= CAST(gs.GEOL_TOP AS FLOAT) AND CAST(it.ISPT_TOP AS FLOAT) < CAST(gs.GEOL_BASE AS FLOAT)
ORDER BY
    ls.LOCA_ID, CAST(it.ISPT_TOP AS FLOAT);