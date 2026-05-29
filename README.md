## Tools

### AGS2DB (AGS → GeoPackage)

**What it does**  
Converts an AGS4 file into a GIS-ready GeoPackage or SQLite database.

**Inputs**
- **Input file**: `.ags` (AGS4).


**Output**
- **GeoPackage** `.gpkg` or **SpatialLite** `.sqlite` 

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

## Contributing

Contributions are welcome. To keep the project manageable, please follow the workflow below.

### Feature requests and bug reports

Before starting work, please check the existing Issues to see whether the feature or bug has already been raised.

For new features, larger changes, or anything that may affect how the plugin works, please open an Issue first. This helps avoid duplicated work and gives us a chance to discuss the approach before code is written.

For small fixes, such as typos or minor documentation updates, you can open a pull request directly.

### Development workflow

1. Fork the repository.
2. Create a new branch for your change.
3. Keep each branch focused on one feature, bug fix, or documentation change.
4. Make your changes.
5. Test the plugin in QGIS before submitting.
6. Update the documentation if your change affects how the plugin is used.
7. Open a pull request back to the main repository.

Please avoid combining unrelated changes in a single pull request. For example, a new feature, a bug fix, and formatting changes should normally be submitted as separate pull requests.

### Branch naming

Use a short, descriptive branch name, for example:

- `fix-layer-loading-error`
- `add-export-option`
- `update-readme`

### Pull requests

When opening a pull request, please include:

- a short description of what has changed;
- the Issue number it relates to, if applicable;
- the QGIS version used for testing;
- any notes about known limitations or follow-up work.

### Code style

Please follow the style and structure already used in the plugin. Keep changes as small and focused as possible, and avoid committing local cache files, generated files, or development environment settings.

---

### Licensing & attribution

This plugin is licensed **GPL-2.0-or-later**.  
It uses the British Geological Survey **AGSAPI**.  
*Contains public sector information licensed under the Open Government Licence v3.0.*  
See the OGL: https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/
