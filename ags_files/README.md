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
