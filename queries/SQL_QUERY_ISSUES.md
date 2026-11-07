# SQL Query Issues

Tracker for problems found in the `.sql` queries under `queries/`, so they can be fixed bit by bit.

- **Reviewed:** 2026-11-04 (static review only — queries were read, not run against a database)
- **Severity:** **High** = wrong results or query fails · **Medium** = logic / consistency · **Low** = housekeeping
- **Status:** `Open` · `In progress` · `Fixed` · `Won't fix` · `Needs decision` · `Parked` (on hold — needs testing with real AGS files)

Issues that affect several files share an ID with a per-file suffix (e.g. `G1a`, `G1b`) so they can be tracked together.

### Background (how AGS2DB builds the database)

- Each AGS group becomes a table named after the group (`LOCA`, `GEOL`, `ERES`, …).
- A column is `REAL` only if every non-blank value is numeric; otherwise it is `TEXT`, and blanks are stored as `''`.
- `LOCA` is a point layer. Its geometry column is `geom` in a GeoPackage (`.gpkg`) but `GEOMETRY` in a SpatiaLite (`.sqlite`) database.

---

## Spatial (`queries/spatial/`)

| ID | Query file | Issue | Severity | Status |
|---|---|---|---|---|
| G1a | `base_made_ground_depth_level_spatial.sql` | Selects `L.geom`; fails on `.sqlite` output where the geometry column is `GEOMETRY`. **Resolved by documentation:** headers and README state GeoPackage (.gpkg) only; .sqlite support would need an AGS2DB code change. | High | Fixed |
| G1b | `contam_terms_in_geol_and_detl_spatial.sql` | `L.geom` fails on `.sqlite` output (see G1a). | High | Fixed |
| G1c | `elrg_soil_contamination_pivot_table_spatial.sql` | `L.geom` fails on `.sqlite` output (see G1a). | High | Fixed |
| G1d | `geotechnical_hazard_poor_ground_search_spatial.sql` | `L.geom` fails on `.sqlite` output (see G1a). | High | Fixed |
| G1e | `log_label_spatial.sql` | `L.geom` fails on `.sqlite` output (see G1a). | High | Fixed |
| G1f | `rockhead_depth_level_spatial.sql` | `L.geom` fails on `.sqlite` output (see G1a). | High | Fixed |
| G1g | `tabulates_in_situ_vane_test_summary_spatial.sql` | `L.geom` fails on `.sqlite` output (see G1a). | High | Fixed |
| G1h | `tabulates_standard_penetration_test_spt_summary_spatial.sql` | `L.geom` fails on `.sqlite` output (see G1a). | High | Fixed |
| G1i | `tabulates_triaxial_strength_test_summary_spatial.sql` | `L.geom` fails on `.sqlite` output (see G1a). | High | Fixed |
| P1a | `elrg_soil_contamination_pivot_table_spatial.sql` | Ethylbenzene CASE also matches `'o-Xylene'` / `'o-xylene'`, so o-xylene results appear in the Ethylbenzene column. | High | Fixed |
| P2a | `elrg_soil_contamination_pivot_table_spatial.sql` | `MAX()` is applied to text results (`ELRG_RTXT`). `'<'` sorts above digits, so `'<1'` beats `'25'` when more than one row matches a determinand. Broad `LIKE` patterns (e.g. `%Chromium%`, `%Boron%`, `%Lead%`, `%Mercury%`) and duplicate/re-analysed results make this likely. **Parked:** needs consideration with real AGS files. | High | Parked |
| P3a | `elrg_soil_contamination_pivot_table_spatial.sql` | `ELRG_RUNI NOT IN ('mg/l','ug/l')` is case-sensitive (keeps `mg/L`, `ug/L`, `µg/l`) and silently drops all rows where the unit is NULL. | High | Parked |
| P8a | `elrg_soil_contamination_pivot_table_spatial.sql` | Results in different units (e.g. `mg/kg` and `ug/kg`) go into the same column with no conversion. `TC8086AF4_add4_trit.ags` ERES has 1947 `mg/kg` and 329 `ug/kg` rows. | High | Parked |
| P4a | `elrg_soil_contamination_pivot_table_spatial.sql` | Summed columns ("Aliphatic EC >16-35", "Chlorophenols (excluding PCP)") strip `<` and add detection limits as if they were measured values; the result loses its `<` qualifier. **Won't fix — by design:** `<` values are taken at their limit value (e.g. `<2` → 2) for screening; confirmed by user 2026-11-05. | High | Won't fix |
| P5a | `elrg_soil_contamination_pivot_table_spatial.sql` | Reads the `ELRG` table, while the non-spatial version reads `ERES`. Otherwise the two are the same query. Confirm which AGS group is intended. | Medium | Needs decision |
| P6a | `elrg_soil_contamination_pivot_table_spatial.sql` | "Chromium (trivalent)" is actually total chromium (CAS 7440-47-3). Many column aliases have trailing/double spaces, awkward to reference in QGIS. | Low | Open |
| P7a | `elrg_soil_contamination_pivot_table_spatial.sql` | Leftover `-- STREAMING_CHUNK: ...` generator comments (14). | Low | Open |
| S1 | `base_made_ground_depth_level_spatial.sql` | If `LOCA_FDEP` is NULL, `MAX(base) >= NULL` is NULL, so the hole is reported as "Confirmed Base" and given a geometry. Should be "Unknown". Test file: `ags_files/test_S1_made_ground_missing_depths.ags`. | High | Fixed |
| S2 | `base_made_ground_depth_level_spatial.sql` | Uses SpatiaLite functions `X()`, `Y()`, `SRID()`, `MakePointZ()` on `L.geom`. On a GeoPackage these need SpatiaLite/GPKG support and return a SpatiaLite blob — needs testing in QGIS. Fallback SRID hard-coded to 27700 although the tool lets the user pick any CRS. | Medium | Open |
| S3 | `base_made_ground_depth_level_spatial.sql` | Assumes `GEOL_LEG` codes starting with `1` are Made Ground. Check against the legend scheme. **Confirmed:** in `TC8086AF4_add4_trit.ags` ABBR, 101 = TOPSOIL and 102 = MADE GROUND, so topsoil is counted as made ground (e.g. BH94, BH100, BH113 have only topsoil but appear in the results). | Medium | Needs decision |
| S4 | `tabulates_triaxial_strength_test_summary_spatial.sql` | `NULLIF(COALESCE(SPEC_DPTH, SAMP_TOP), '')` returns `''` when `SPEC_DPTH` is blank text, so the `SAMP_TOP` fallback never fires. Should be `COALESCE(NULLIF(SPEC_DPTH,''), NULLIF(SAMP_TOP,''))` (6 places). Test file: `ags_files/test_S4_trit_blank_spec_depth.ags`. | High | Fixed |
| S5 | `tabulates_standard_penetration_test_spt_summary_spatial.sql` | "Numeric N-Value (for Plotting)" is derived from `ISPT_MAIN` (main-drive blow total) instead of `ISPT_NVAL` (the N value). **Re-graded after real-data check:** in `TC8086AF4_add4_trit.ags` MAIN = NVAL for 108/169 tests; the other 61 are refusals with NVAL blank and MAIN = 50, so switching to NVAL would drop them. Decide how refusals should plot. The `REPLACE` cleaning on MAIN is redundant (MAIN is numeric). | Medium | Needs decision |
| C1a | `tabulates_triaxial_strength_test_summary_spatial.sql` | Selects `T.TRIT_REM`, which `TC8086AF4_add4_trit.ags` does not have → query fails (`no such column`). Optional AGS headings may be absent from real files. Test file with the heading: `ags_files/test_C1a_trit_rem.ags`. **Fix:** `TRIT_REM` read via a subquery with a blank default (see C1e). | High | Fixed |
| C1b | `tabulates_standard_penetration_test_spt_summary_spatial.sql` | Selects `ISPT_METH` and `ISPT_REM`, absent from `TC8086AF4_add4_trit.ags` → query fails (see C1a). Test file with the heading: `ags_files/test_C1b_ispt_meth_rem.ags`. **Fix:** `ISPT_METH` and `ISPT_REM` read via subqueries with blank defaults (see C1e). | High | Fixed |
| C1c | `contam_terms_in_geol_and_detl_spatial.sql` | Uses `DETL_REM`, absent from `TC8086AF4_add4_trit.ags` → query fails (see C1a). Test file with the heading: `ags_files/test_C1cd_detl_rem.ags`. **Fix:** DETL is read through a `DetlSafe` CTE that always has `detl_rem` (blank default, see C1e). | High | Fixed |
| C1d | `geotechnical_hazard_poor_ground_search_spatial.sql` | Uses `DETL_REM`, absent from `TC8086AF4_add4_trit.ags` → query fails (see C1a). Test file with the heading: `ags_files/test_C1cd_detl_rem.ags`. **Fix:** DETL is read through a `DetlSafe` CTE that always has `detl_rem` (blank default, see C1e). | High | Fixed |
| B1a | `tabulates_in_situ_vane_test_summary_spatial.sql` | Stratum lookup uses `top <= depth <= base` and takes the upper stratum at a boundary; non-spatial queries and `ISPTN.sql` use `top <= depth < base` (lower stratum). Agree one rule. | Medium | Needs decision |
| B1b | `tabulates_standard_penetration_test_spt_summary_spatial.sql` | Boundary rule differs (see B1a). | Medium | Needs decision |
| B1c | `tabulates_triaxial_strength_test_summary_spatial.sql` | Boundary rule differs (see B1a). | Medium | Needs decision |
| S6 | `rockhead_depth_level_spatial.sql` | Assumes `GEOL_LEG LIKE '8%'` means bedrock. Check against the legend scheme. | Medium | Needs decision |
| S7 | `log_label_spatial.sql` | Relies on `GROUP_CONCAT` keeping the inner subquery's `ORDER BY` — SQLite doesn't guarantee this, so strata could appear out of order. **Not reproducible:** with strata stored out of order (`ags_files/test_S7_geol_rows_out_of_order.ags`), SQLite 3.32 and 3.50 still return depth order. **Resolved:** original kept; `log_label_spatial_alt.sql` added, which uses an ordered window `GROUP_CONCAT` (guaranteed order). Both give identical labels on TC8086, Esholt and the S7 test file; each file's header points to the other (user decision 2026-11-07). | Medium | Fixed |
| S8 | `log_label_spatial.sql` | Casts `GEOL_TOP` but not `GEOL_BASE`, so depth formats can differ; holes with no GEOL rows are dropped by the inner join. | Low | Open |
| S9 | `geotechnical_hazard_poor_ground_search_spatial.sql` | Keyword false positives: `%blow%` matches SPT "blows", `%void%` matches "avoid". `%highly organic%` is redundant with `%organic%`. | Low | Open |
| S10 | `contam_terms_in_geol_and_detl_spatial.sql` | `'% oil%'` misses descriptions that start with "Oil". | Low | Open |
| S11a | `tabulates_in_situ_vane_test_summary_spatial.sql` | Stratum description column is labelled "Sample Geology Description" but these are in situ tests, not samples. | Low | Open |
| S11b | `tabulates_standard_penetration_test_spt_summary_spatial.sql` | Same misleading "Sample Geology Description" label (see S11a). | Low | Open |
| H1a | `base_made_ground_depth_level_spatial.sql` | Header says `LICENSE: MIT / Creative Commons CC0`; repo and other queries are GPL v3. | Low | Open |
| H1b | `rockhead_depth_level_spatial.sql` | MIT/CC0 licence line (see H1a). | Low | Open |
| H1c | `tabulates_in_situ_vane_test_summary_spatial.sql` | MIT/CC0 licence line (see H1a). | Low | Open |
| H1d | `tabulates_standard_penetration_test_spt_summary_spatial.sql` | MIT/CC0 licence line (see H1a). | Low | Open |
| H1e | `tabulates_triaxial_strength_test_summary_spatial.sql` | MIT/CC0 licence line (see H1a). | Low | Open |
| H2a | `base_made_ground_depth_level_spatial.sql` | `DESCRIPTION` is empty, and header layout (`AUTHOR / ORG`, `DIALECT`) differs from the other queries. | Low | Open |
| H2b | `rockhead_depth_level_spatial.sql` | Empty `DESCRIPTION` / different header layout (see H2a). | Low | Open |
| H2c | `tabulates_in_situ_vane_test_summary_spatial.sql` | Empty `DESCRIPTION` / different header layout (see H2a). | Low | Open |
| H2d | `tabulates_standard_penetration_test_spt_summary_spatial.sql` | Empty `DESCRIPTION` / different header layout (see H2a). | Low | Open |
| H2e | `tabulates_triaxial_strength_test_summary_spatial.sql` | Empty `DESCRIPTION` / different header layout (see H2a). | Low | Open |
| P7b | `tabulates_triaxial_strength_test_summary_spatial.sql` | Leftover `-- STREAMING_CHUNK: ...` generator comments (3). | Low | Open |

## Non-spatial (`queries/non spatial/`)

| ID | Query file | Issue | Severity | Status |
|---|---|---|---|---|
| P1b | `eres_soil_contamination_pivot_table_no_LOCA.sql` | Ethylbenzene CASE also matches o-Xylene (see P1a). | High | Fixed |
| P2b | `eres_soil_contamination_pivot_table_no_LOCA.sql` | `MAX()` on text results lets `<LOD` values beat real results (see P2a). | High | Parked |
| P3b | `eres_soil_contamination_pivot_table_no_LOCA.sql` | Liquid-unit filter is case-sensitive and drops NULL units (see P3a). | High | Parked |
| P8b | `eres_soil_contamination_pivot_table_no_LOCA.sql` | Mixed `mg/kg` / `ug/kg` units in the same column (see P8a). | High | Parked |
| P4b | `eres_soil_contamination_pivot_table_no_LOCA.sql` | Summed columns add detection limits as measured values (see P4a). **Won't fix — by design:** `<` values are taken at their limit value (e.g. `<2` → 2) for screening; confirmed by user 2026-11-05. | High | Won't fix |
| P5b | `eres_soil_contamination_pivot_table_no_LOCA.sql` | Reads `ERES` while spatial version reads `ELRG` (see P5a). | Medium | Needs decision |
| P6b | `eres_soil_contamination_pivot_table_no_LOCA.sql` | "Chromium (trivalent)" is total Cr; trailing spaces in aliases (see P6a). Description says 122 columns, spatial says 123. | Low | Open |
| N1 | `sample_descriptions_from_grag_where_depth_lt_3m.sql` | `WHERE SPEC_DPTH < 3.0` and `ORDER BY SPEC_DPTH` have no `CAST`. If the column is stored as TEXT, the comparison is textual (`'10.5' < '3.0'` is true) and the sort is alphabetical. Test file: `ags_files/test_N1_grag_text_depths.ags`. | High | Fixed |
| N2 | `sample_descriptions_from_grag_where_depth_lt_3m.sql` | Single-quoted column aliases (`'Sample ID'`) instead of double quotes; missing final `;`. | Low | Fixed |
| C1e | `geology_summary_table.sql` | Selects `GEOL_FORM`, absent from `TC8086AF4_add4_trit.ags` → query fails (see C1a). Test file with the heading: `ags_files/test_C1e_geol_form.ags`. **Fix:** `GEOL_FORM` read via a subquery with a blank default (`Defaults` CTE), so the query runs with or without the heading; tested on AGS2DB .gpkg output of both files. | High | Fixed |
| N3 | `select_from_grag_where_sample_depth_lt_3m_orderby_LOCA_ID_and_depth.sql` | Uses `<= 3.0` although the filename says `lt` (the other GRAG query uses `<`). The two GRAG queries are near-duplicates — decide which to keep and which threshold. | Medium | Needs decision |
| N4 | `add_descriptions_to_contam_results.sql` | `SELECT *` over a join gives duplicate `LOCA_ID` (and `fid` in GeoPackage) columns, which can upset QGIS when loading as a layer. **Won't fix (re-graded Low after testing on AGS2DB .gpkg):** QGIS/OGR keeps the first copy of a duplicated column, so `LOCA_ID` and `fid` come from ERES and are always populated and unique. Only GEOL's copies of headings shared with ERES are dropped when loaded as a layer (e.g. `FILE_FSET` in Esholt). Confirmed by user 2026-11-07. | Low | Won't fix |
| N5 | `add_descriptions_to_samples.sql` | `SELECT *` gives duplicate `LOCA_ID` / `fid` columns (see N4). **Won't fix (re-graded Low after testing on AGS2DB .gpkg):** QGIS/OGR keeps the first copy of a duplicated column, so `LOCA_ID` and `fid` come from SAMP and are always populated and unique. Only GEOL's copies of headings shared with SAMP are dropped when loaded as a layer (e.g. `FILE_FSET`, `GEOL_STAT` in Esholt). Confirmed by user 2026-11-07. | Low | Won't fix |
| B1d | `add_descriptions_to_contam_results.sql` | Boundary rule `top <= depth < base` differs from the spatial test queries (see B1a). | Medium | Needs decision |
| B1e | `add_descriptions_to_samples.sql` | Boundary rule differs from spatial test queries (see B1a). | Medium | Needs decision |
| H3a | `add_descriptions_to_samples.sql` | CR-only (old Mac) line endings — git and many tools show the whole file as one line. | Low | Open |
| H3b | `select_from_grag_where_sample_depth_lt_3m_orderby_LOCA_ID_and_depth.sql` | CR-only line endings (see H3a). | Low | Open |

## Root (`queries/`)

| ID | Query file | Issue | Severity | Status |
|---|---|---|---|---|
| G1j | `borehole_by_depth_and_geol.sql` | Selects `ls.geom`; fails on `.sqlite` output (see G1a). | High | Fixed |
| G1k | `ISPTN.sql` | Selects `ls.geom`; fails on `.sqlite` output (see G1a). | High | Fixed |
| R1 | `borehole_by_depth_and_geol.sql` | `GROUP BY LOCA_ID, GEOL_TOP` with no aggregate functions — arbitrarily hides duplicate rows rather than doing anything useful. | Medium | Open |
| H4a | `borehole_by_depth_and_geol.sql` | No standard header / `QUERY FILENAME` line; not in the `spatial/` folder or renamed to the naming convention. | Low | Open |
| H4b | `ISPTN.sql` | No standard header; not in a folder or renamed (see H4a). | Low | Open |
| H3c | `borehole_by_depth_and_geol.sql` | Mixed line endings show as doubled blank lines. | Low | Open |
| H3d | `ISPTN.sql` | Mixed line endings show as doubled blank lines. | Low | Open |

---

## Files with no issues found

- `non spatial/location_summary_table.sql`
