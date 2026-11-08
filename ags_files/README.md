# AGS test files

Dummy AGS files for reproducing the issues logged in [`../queries/SQL_QUERY_ISSUES.md`](../queries/SQL_QUERY_ISSUES.md).

**Naming:** `test_<IssueID>_<short_description>.ags`

Each dummy file is a cut-down copy of a real source file. Lines are copied unchanged, and only the records listed below are edited. Each edited record says so in its remarks field (`TEST <IssueID>: ...`).

## Source files

| File | Notes |
|---|---|
| `TC8086AF4_add4_trit.ags` | A720 Sheriffhall Roundabout Improvement (AGS 4.0.4), 59 groups. Real data, not edited. |

## Dummy files

### `test_S1_made_ground_missing_depths.ags`

- **Issue:** S1. In `base_made_ground_depth_level_spatial.sql`, a missing final depth or made ground base was reported as "Confirmed Base".
- **Source:** `TC8086AF4_add4_trit.ags`
- **Groups:** PROJ, TRAN, ABBR, TYPE, UNIT (copied whole) and LOCA, GEOL (4 holes only)

| Hole | Edit | Before S1 fix | After S1 fix |
|---|---|---|---|
| BH90 | none (control) | Confirmed Base, 59.69 mAOD | Confirmed Base, 59.69 mAOD |
| TP46SB | none (control: MG base 0.50 = final depth 0.50) | Uncertain (Not Bottomed) | Uncertain (Not Bottomed) |
| BH112 | `LOCA_FDEP` removed | **Confirmed Base**, 65.74 mAOD, mapped | Unknown (Missing Depth Data), not mapped |
| BH92 | `GEOL_BASE` removed from both made ground rows (`GEOL_LEG` 102) | **Confirmed Base**, no level, mapped with a NULL Z | Unknown (Missing Depth Data), not mapped |

### `test_S4_trit_blank_spec_depth.ags`

- **Issue:** S4. In `tabulates_triaxial_strength_test_summary_spatial.sql`, a blank `SPEC_DPTH` never fell back to `SAMP_TOP`.
- **Source:** `TC8086AF4_add4_trit.ags`
- **Groups:** PROJ, TRAN, ABBR, TYPE, UNIT (copied whole) and LOCA, GEOL, SAMP, TRIG, TRIT (BH113A only)
- **Only reproduces when `TRIT.SPEC_DPTH` is a TEXT column**, i.e. when at least one value is non-numeric. If every value is numeric, AGS2DB types the column REAL, blanks become NULL, and the old query already fell back correctly. Specimen 13/2 is given an `m` suffix to force TEXT, and SQLite still reads it as 3.34.
- **`TRIT_REM` added:** the source file has no `TRIT_REM` heading, and the query fails without it (issue C1a). This test file adds a `TRIT_REM` column (TYPE `X`) to TRIT so the query runs, and uses it for the `TEST S4: ...` notes.

| Specimen (BH113A) | Edit (TRIT and TRIG) | Existing query | Revised query |
|---|---|---|---|
| Sample 8, spec 2 (SAMP_TOP 1.20, was SPEC_DPTH 1.37) | `SPEC_DPTH` removed | Depth, level, legend code and description all NULL | Depth 1.20, level 55.44 mAOD, legend 220 |
| Sample 13, spec 2 (SAMP_TOP 3.20) | `SPEC_DPTH` `3.34` → `3.34m` | Depth 3.34, level 53.30 mAOD, legend 224 | unchanged |

### `test_N1_grag_text_depths.ags`

- **Issue:** N1. In `sample_descriptions_from_grag_where_depth_lt_3m.sql`, the depth filter and sort compared text instead of numbers.
- **Source:** `TC8086AF4_add4_trit.ags`
- **Groups:** PROJ, TRAN, ABBR, TYPE, UNIT (copied whole) and LOCA, SAMP, GRAG (BH94A, BH90)
- **Only reproduces when `GRAG.SPEC_DPTH` is a TEXT column** (see S4 note). The `0.90m` value forces TEXT.

| Hole | Edit | Existing query | Revised query |
|---|---|---|---|
| BH94A | `SPEC_DPTH` `0.90` → `0.90m`; `4.20` → `12.00` | Includes 12.00 (text `'12.00' < '3.0'` is true). Order: 0.50, 0.90m, **12.00**, 2.20, 2.80 | 12.00 excluded. Depth shown as a number: 0.5, 0.9, 2.2, 2.8 |
| BH90 | none (control: 0.30, 1.20, 2.20, 6.20) | 0.30, 1.20, 2.20 | same rows, shown as 0.3, 1.2, 2.2 |

### C1 test files: optional headings present

- **Issue:** C1. Some queries name optional AGS headings that `TC8086AF4_add4_trit.ags` does not have, so on that file they fail with `no such column`.
- **Source:** `TC8086AF4_add4_trit.ags`, hole BH94 only. PROJ, TRAN, ABBR, TYPE, UNIT are copied whole.
- **Edit:** each file adds the missing heading(s) to the end of the group (UNIT blank, TYPE `X`). Only a few rows are filled; the rest are blank. No other values are changed.
- **Use:** before the C1 fix, each query fails on `TC8086AF4_add4_trit.ags` and runs on the test file. After the fix, both files run: the column is blank on TC8086 and filled on the test file, and the test-file results are identical to the old query.

| File | Groups | Heading added | Rows filled | Query |
|---|---|---|---|---|
| `test_C1a_trit_rem.ags` | LOCA, GEOL, SAMP, TRIG, TRIT | `TRIT_REM` | specimen 17/2 test 1: `TEST C1a: TRIT_REM added` | `tabulates_triaxial_strength_test_summary_spatial.sql` |
| `test_C1b_ispt_meth_rem.ags` | LOCA, GEOL, ISPT | `ISPT_METH`, `ISPT_REM` | `ISPT_METH` at 1.20 and 2.20 (`BS EN ISO 22476-3:2005+A1:2011`); `ISPT_REM` at 9.70 | `tabulates_standard_penetration_test_spt_summary_spatial.sql` |
| `test_C1cd_detl_rem.ags` | LOCA, GEOL, DETL | `DETL_REM` | 2.20: `TEST C1c: slight hydrocarbon odour`; 9.00: `TEST C1d: soft band` | `contam_terms_in_geol_and_detl_spatial.sql`, `geotechnical_hazard_poor_ground_search_spatial.sql` |
| `test_C1e_geol_form.ags` | LOCA, GEOL | `GEOL_FORM` | 0.50 and 1.20: `Glaciofluvial Deposits`; 6.20: `Till` (illustrative names) | `geology_summary_table.sql` |

The two BH94 `DETL_DESC` values (`very gravelly`, `firm`) match neither keyword list. This means the DETL rows are picked up only through `DETL_REM`:

| Query | On TC8086 (old query) | On test file |
|---|---|---|
| contam terms | fails (`no such column: D.detl_rem`) | 1 row: DETL 2.20–2.70, remark `slight hydrocarbon odour` |
| geotechnical hazard | fails (`no such column: D.detl_rem`) | 5 rows: 4 GEOL (soft/loose strata) + DETL 9.00–9.70, remark `soft band` |
| triaxial | fails (`no such column: T.TRIT_REM`) | 6 rows, remark on the first |
| SPT | fails (`no such column: I.ISPT_METH`) | 5 rows, method on two, remark on one |
| geology summary | fails (`no such column: Geol_Form`) | 7 rows, Stratum filled on three |

After the C1 fix, the queries run on TC8086: triaxial 51 rows, SPT 169, contamination 78, geotechnical hazard 94, geology summary 445, all with the optional columns blank.

### `test_S7_geol_rows_out_of_order.ags`

- **Issue:** S7. `log_label_spatial.sql` relies on a subquery `ORDER BY` to stack strata in depth order, which SQLite does not guarantee.
- **Source:** `TC8086AF4_add4_trit.ags`
- **Groups:** PROJ, TRAN, ABBR, TYPE, UNIT (copied whole) and LOCA, GEOL (BH90, BH94)
- **Edit:** no values changed. BH94's GEOL rows are written in reverse depth order (deepest first); BH90's are left in order (control).
- **Result:** the problem could not be reproduced. Both `log_label_spatial.sql` and `log_label_spatial_alt.sql` list BH94's strata top-down, giving identical labels (SQLite 3.32 and 3.50, on AGS2DB .gpkg output). Keep it as a check that out-of-order rows still come out in depth order.

### `test_S3_topsoil_not_made_ground.ags`

- **Issue:** S3. `base_made_ground_depth_level_spatial.sql` counted every `GEOL_LEG` code starting with `1` as made ground, including 101 (TOPSOIL).
- **Source:** `TC8086AF4_add4_trit.ags`
- **Groups:** PROJ, TRAN, ABBR, TYPE, UNIT (copied whole) and LOCA, GEOL (BH90, BH92, BH94)
- **Edits** (noted in `GEOL_REM`): BH92 0.00–0.30 `GEOL_LEG` 102 → 101 (topsoil over made ground); BH90 0.50–1.00 `GEOL_LEG` 102 → 103 (another 10x code, still made ground). The `103` code isn't listed in ABBR.

| Hole | Strata | Before S3 fix | After S3 fix |
|---|---|---|---|
| BH94 | topsoil (101) only, no edit | **listed:** base 0.20, 65.42 mAOD, Confirmed Base | **not listed** |
| BH92 | 101 over 102 | base 0.50, 56.80 mAOD, Confirmed Base | unchanged |
| BH90 | 102, 102, 103 | base 1.00, 59.69 mAOD, Confirmed Base | unchanged (103 still counted) |

### `test_B1_end_of_hole.ags`

- **Issue:** B1 (end-of-hole part). `add_descriptions_to_samples.sql`, `add_descriptions_to_contam_results.sql` and `ISPTN.sql` matched `GEOL_TOP <= depth < GEOL_BASE`, so a depth equal to the base of the deepest stratum (the bottom of the hole) matched no stratum.
- **Source:** `TC8086AF4_add4_trit.ags`
- **Groups:** PROJ, TRAN, ABBR, TYPE, UNIT (copied whole) and LOCA, GEOL, SAMP, ERES, ISPT (TP43, BH113)
- **Edit:** TP43 ES sample 10 moved from 1.70 to 2.60 (the base of the hole) in SAMP (`SAMP_BASE` 1.80 cleared) and in its 41 ERES rows (noted in `ERES_REM`). Neither real file has a contam result at the base of a hole, so this edit is needed for the contam query. Everything else is unchanged: TP43 D sample 12 at 2.60 and the BH113 SPT at 3.10 are real end-of-hole records.
- **TP43 strata:** 0.00–0.10, 0.10–0.55, 0.55–1.60 (102), 1.60–2.60 (528), final depth 2.60. **BH113:** deepest stratum 2.00–3.10, final depth 3.10.

| Query | Record | Before B1 fix | After B1 fix |
|---|---|---|---|
| samples | TP43 sample 10 (ES) and 12 (D) at 2.60 | GEOL columns blank | stratum 1.60–2.60, legend 528 |
| contam results | TP43 sample 10 at 2.60 (41 results) | GEOL columns blank | stratum 1.60–2.60, legend 528 |
| `ISPTN.sql` | BH113 SPT at 3.10 | missing (2 rows for BH113) | included, group 2 (3 rows) |

Row counts are unchanged for samples (26) and contam results (437). All other rows are identical.
