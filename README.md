# Climate Benefits of Air Quality Regulation

## Disclaimer

This repository documents ongoing research. The analyses, methodology, and results are preliminary and subject to revision as the project develops.

## Overview

This is the repository for a research project investigating the causal effect of the EPA's 2005 implementation of the National Ambient Air Quality Standards (NAAQS) for fine particulate matter (PM2.5) on transporation-related carbon dioxide (CO2) emissions in the United States.

The preliminary analysis applies `CausalArima` (Menchetti et al., 2023) to EIA data on total transportation-sector CO2 emissions in the U.S. (1960-2023) and aggregated NASA data on on-road CO2 emissions at the county level in the contiguous U.S. (1980-2017).

The current analysis explores extensions of spatial panel modeling using the `splm` package (Millo & Piras, 2012) to estimate counterfactual CO2 emissions at the county level.

## Repository Structure: Current Analysis (`current_analysis`)

- `data`: This folder contains the raw data (downloaded online, internal to NSAPH, etc.) used in the analysis. If publicly available, the datasets are cited via links in footnotes.
  - Due to size constraints, the `CMS_DARTE_V2_1735` (on-road CO2 emissions) and `dataverse_files` (PM2.5 concentrations) data sets are not included in this repository.
  - For `CMS_DARTE_V2_1735`, see [source](https://daac.ornl.gov/CMS/guides/CMS_DARTE_V2.html) or [Google Drive](https://drive.google.com/drive/folders/1JzMBRfZViuME22leN3n780HsCKTs6-L1?usp=drive_link).
  - For `dataverse_files`, see [source](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/4GDRB1) or [Google Drive](https://drive.google.com/drive/folders/1RrmPcP52OdRvOs7PLh0vGutQOU0E-TNL?usp=drive_link).
- `scripts`: This folder contains the R Markdown (.Rmd) files with the code and documentation.
  - `01_prepare_data.Rmd`: This file loads, cleans, and aggregates CO2 emissions and PM2.5 concentration data from census block group and ZCTA levels, respectively, to the county level. It then merges the datasets, filters extreme observations, and prepares county-level data for subsequent analyses.
  - `02_run_causalarima.Rmd`: This file applies the `CausalArima` method to individual counties to estimate the causal effect of the 2005 intervention on CO2 emissions, saving county-level effect estimates and associated statistics.
  - `03_explore_causalarima.Rmd`: This file explores the county-level `CausalArima` results through geographic visualizations and investigates the relationship between estimated CO2 effects and observed PM2.5 changes using linear regression and generalized additive models.
  - `04_run_plm.Rmd`: This file fits fixed-effects panel regression models with lagged CO2 emissions using the `plm` package. It then generates counterfactual CO2 predictions for 2005-2010, compares predicted and observed emissions, and evaluates model residuals.
  - `05_run_splm.Rmd`: This file extends the panel regression approach to account for spatially correlated errors using the `splm` package and a k-nearest-neighbor spatial weights matrix. It then generates counterfactual CO2 predictions for 2005–2010 and evaluates model residuals.

## Repository Structure: Preliminary Analysis (`preliminary_analysis`)

- `data`: This folder contains the raw data (downloaded online, internal to NSAPH, etc.) used in the analysis. If publicly available, the datasets are cited via links in footnotes.
  - Due to size constraints, the `CMS_DARTE_V2_1735` (on-road CO2 emissions) and `dataverse_files` (PM2.5 concentrations) data sets are not included in this repository.
  - For `CMS_DARTE_V2_1735`, see [source](https://daac.ornl.gov/CMS/guides/CMS_DARTE_V2.html) or [Google Drive](https://drive.google.com/drive/folders/1JzMBRfZViuME22leN3n780HsCKTs6-L1?usp=drive_link).
  - For `dataverse_files`, see [source](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/4GDRB1) or [Google Drive](https://drive.google.com/drive/folders/1RrmPcP52OdRvOs7PLh0vGutQOU0E-TNL?usp=drive_link).
- `files`: This folder contains the files (.Rmd and .pdf) with the code and documentation.
  - `aggregation`: This file aggregates data on PM2.5 concentration in the U.S. from the ZCTA level to the census block group level to join with the NASA data.
  - `final_county`: This file performs causal inference at the county level. It first cleans the NASA data (outputting `co2_county.csv`) and then runs `CausalArima` on one specified county. Finally, with `co2_county_causal_arima.csv` from `run_causal_arima.R`, it plots the results of significant counties on a map of the U.S.
  - `final_national`: This file performs causal inference at the national level. It first cleans the EIA data along with data on multiple potential covariates (outputting `national.csv`) and then runs `CausalArima` using U.S. trade/GDP ratio, real GDP on a log scale, and urban population ratio as covariates.
  - `run_causal_arima`: This file runs `CausalArima` iteratively through every available county in the contiguous U.S. (with `co2_county.csv` from `final_county.Rmd`) and outputs `co2_county_causal_arima.csv`.
  - `draft`: This file combines all relevant steps from the files above into one document while adding regression analysis via ordinary least squares (OLS) and weighted least squares (WLS).
- `plots`: This folder contains the important visualizations generated in the files.
- `results`: This folder contains the important data sets generated, processed, and used in the files.
