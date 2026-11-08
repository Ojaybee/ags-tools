-- REQUIRES: GeoPackage (.gpkg) from AGS2DB only. Will not work on SpatiaLite (.sqlite) output.
SELECT
    ls.LOCA_ID AS "Exploratory Hole Location",
    CAST(it.ISPT_TOP AS FLOAT) AS "Depth to top of test",
    it.ISPT_NVAL AS "SPT 'N' value",
    substr(gs.GEOL_LEG, 1, 1) AS "Geological group at ISPT_TOP",
    ls.geom
FROM
    loca ls
JOIN
    GEOL gs ON ls.LOCA_ID = gs.LOCA_ID
JOIN
    ISPT it ON ls.LOCA_ID = it.LOCA_ID
WHERE
    -- Boundary rule (B1): a depth on a boundary between two layers is given the LOWER layer (the one
    -- that starts at that depth). A depth at the base of the deepest layer is given that layer.
    CAST(it.ISPT_TOP AS FLOAT) >= CAST(gs.GEOL_TOP AS FLOAT)
    AND (
        CAST(it.ISPT_TOP AS FLOAT) < CAST(gs.GEOL_BASE AS FLOAT)
        OR (CAST(it.ISPT_TOP AS FLOAT) = CAST(gs.GEOL_BASE AS FLOAT)
            AND NOT EXISTS (SELECT 1 FROM GEOL G2 WHERE G2.LOCA_ID = gs.LOCA_ID AND CAST(G2.GEOL_TOP AS FLOAT) = CAST(it.ISPT_TOP AS FLOAT)))
    )
ORDER BY
    ls.LOCA_ID, CAST(it.ISPT_TOP AS FLOAT);