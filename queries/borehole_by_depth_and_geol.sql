-- Simple/mini borehole logs used for pop up 
-- labelling an exploratory hole location plan. 
SELECT
    ls.LOCA_ID AS "Exploratory Hole Location",
    CAST(gs.GEOL_TOP AS FLOAT) AS "Depth to the top of stratum (m)",
    CAST(gs.GEOL_BASE AS FLOAT) AS "Depth to the base of stratum (m)",
    substr(gs.GEOL_LEG, 1, 1) AS "Geological group",
    ls.geom
FROM
    loca_spatial ls
JOIN
    GEOL gs ON ls.LOCA_ID = gs.LOCA_ID
GROUP BY
    ls.LOCA_ID, gs.GEOL_TOP
ORDER BY
    ls.LOCA_ID, CAST(gs.GEOL_TOP AS FLOAT);