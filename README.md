## Tools

### AGS2DB (AGS → GeoPackage)

**What it does**  
Converts an AGS4 file into a GIS-ready GeoPackage or SQLite database.

**Inputs**
- **Input file**: `.ags` (AGS4).


**Output**
- **GeoPackage** `.gpkg` or `.db` 

**How to use**
1. Open **Processing Toolbox → AGS Tools → AGS2DB**.  
2. Pick your **AGS file** and an **output** path.  
3. Set the **Coordinate reference system**.
4. Run. 

**Notes**
- Start with small AGS files to verify settings.
- If coordinates exist, a point layer is created; otherwise you’ll get non-spatial tables for joins.

---

### AGS Validator (via BGS AGSAPI)

**What it does**  
Validates an AGS4 file against the selected dictionary using the **BGS AGSAPI**, returning a plain-text report (errors, warnings, info).

**Inputs**
- **Input file**: `.ags` (AGS4)
- **AGS version**: one of `4.0.3`, `4.0.4`, `4.1`, `4.1.1` (or **None** to use the API default)
- **Checkers**: one or more of `ags`, `bgs`

**Output**
- **Text report** (`.txt`) summarising validation results.

**How to use**
1. Open **Processing Toolbox → AGS Tools → AGS Validator**.  
2. Select **AGS file**, **dictionary**, and **checkers**.  
3. Choose an **output `.txt`** path and run.  
4. Open the saved report to review issues.

**Notes / requirements**
- **Internet required**: the tool posts your file to the BGS AGSAPI and saves the response.

---

### Licensing & attribution

This plugin is licensed **GPL-2.0-or-later**.  
It uses the British Geological Survey **AGSAPI**.  
*Contains public sector information licensed under the Open Government Licence v3.0.*  
See the OGL: https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/
