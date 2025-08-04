# Climate Co-Benefits of U.S. Air Quality Regulations on CO2 Emissions

## Overview

This is the repository for a project estimating the causal effect of the EPA's National Ambient Air Quality Standards (NAAQS) for PM2.5 level on transporation-related CO2 emissions in U.S. The project applies `CausalArima` (Menchetti et al., 2021) on EIA data on total transportation-sector CO2 emissions in the U.S. (1960-2023) as well as aggregated NASA data on on-road CO2 emissions at the county level in the contiguous U.S. (1980-2017). The preliminary results look promising.

## Repository Structure

- `data/`: This folder contains the "raw" data (downloaded online, internal to NSAPH, etc.) used in the analysis. If publicly available, the data sets are cited via links in footnotes.
- `files/`: This folder contains the files (.Rmd and .pdf) with the code and documentation.
  - `aggregation/`: This file aggregates data on PM2.5 concentration in the U.S. from the ZCTA level to the census block group level to join with the NASA data.
  - `final_county/`: This file performs causal inference at the county level. It first cleans the NASA data (outputting `co2_county.csv`) and then runs `CausalArima` on one specified county. Finally, with `co2_county_causal_arima.csv` from `run_causal_arima.R`, it plots the results of significant counties on a map of the U.S.
  - `final_national/`: This file performs causal inference at the national level. It first cleans the EIA data along with data on multiple potential covariates (outputting `national.csv`) and then runs `CausalArima` using U.S. trade/GDP ratio, real GDP on a log scale, and urban population ratio as covariates.
  - `run_causal_arima/`: This file runs `CausalArima` iteratively through every available county in the contiguous U.S. (with `co2_county.csv` from `final_county.Rmd`) and outputs `co2_county_causal_arima.csv`.
- `plots/`: This folder contains the important visualizations generated in the files.
- `results/`: This folder contains the important data sets generated, processed, and used in the files.
