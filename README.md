# APP-GenderGap
Analysis of gender disparities in computer science education in Virginia.
# APP Gender Gap Analysis

This repository contains R code and data exploring gender disparities in computer science education across Virginia school divisions. The analysis was prepared as part of my Applied Policy Project (APP) for CodeVA.

## How to Knit the Analysis

To generate the HTML report:

1. Open RStudio
2. Install required packages:

```r
install.packages(c("tidyverse", "sf", "tigris", "readxl", "showtext", "here"))
```

3. Knit the R Markdown file:

```r
rmarkdown::render("code/gender_gap_analysis.Rmd")
```

## Project Structure

```
code/      R scripts and R Markdown file
data/      Aggregated data files used in analysis
final_report/   PDF version of my Applied Policy Project (APP). The first section includes the data analysis, while the rest of the report provides policy recommendations.
```

## Shapefile Data

This project uses Virginia school district boundaries from the U.S. Department of Education's NCES national shapefile:

[NCES School District Boundaries - Current](https://data-nces.opendata.arcgis.com/datasets/school-district-boundaries-current/explore)

Due to large file size, the shapefiles are not included in this repository. To replicate the analysis:

1. Download the national shapefile from the NCES link above.
2. Save the shapefile files into this folder:

```
School_District_Boundaries_-_Current/
```

3. The R Markdown code filters this shapefile for Virginia using:

```r
district_boundaries <- st_read("School_District_Boundaries_-_Current/your_shapefile.shp") %>%
  filter(STATEFP == "51")
```

## Data Privacy Note

All data shared in this repository is aggregated at the district level. Small cell counts under 10 are masked to protect privacy.

## Data Sources

- Virginia Department of Education
- CodeVA
- U.S. Department of Education NCES

## License

MIT License
