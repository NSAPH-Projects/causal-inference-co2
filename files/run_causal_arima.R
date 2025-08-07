# Load libraries
library(tidyverse)
library(CausalArima)
library(glue)

# Load wrangled `co2_county.csv` from `final_county.Rmd`
co2 <- read_csv("co2_county.csv")

# Initialize list to store results
results_list <- list()

# Define intervention time point
intervention_date <- as.Date("2005-01-01")

# Get unique counties (to avoid repeating counties over years)
fips_vec <- unique(co2$fips)

# Loop through each county
for (i in seq_along(fips_vec)) {
  my_fips <- fips_vec[i]
  
  # Get county_df for specified FIPS
  county_df <- co2 %>%
    filter(fips == my_fips)
  
  # Skip if no data
  if (nrow(county_df) == 0) {
    warning(glue("No data for FIPS {my_fips}, skipping..."))
    next
  }
  
  # Create vector for dates
  all_dates <- as.Date(paste0(county_df$year, "-01-01"))
  
  # Create time series for outcome with yearly seasonality
  y_ts <- ts(county_df$value, frequency = 1)
  
  # Use tryCatch to avoid full script crashing
  tryCatch({
    # Run CausalArima()
    ce <- CausalArima(y = y_ts,
                      dates = all_dates,
                      int.date = intervention_date,
                      nboot = 1000)
    
    # Get impact as list
    imp <- impact(ce)
    
    # Extract via impact_norm cumulative effect and other statistics
    norm_effect <- imp$impact_norm$sum
    cumulative_effect <- norm_effect$estimate
    sd_norm <- norm_effect$sd
    ci_lower_norm <- cumulative_effect - 1.96 * sd_norm
    ci_upper_norm <- cumulative_effect + 1.96 * sd_norm
    
    # Calculate relative cumulative effect as a decimal
    post_years <- 2005:2010
    post_indices <- which(county_df$year %in% post_years)
    observed_post <- county_df$value[post_indices]
    predicted_post <- ce$forecast
    sum_obs <- sum(observed_post, na.rm = TRUE)
    sum_pred <- sum(predicted_post, na.rm = TRUE)
    rel_cumulative_effect <- (sum_obs - sum_pred) / sum_pred
    
    # Extract via impact_boot cumulative effect and other statistics
    boot_list <- imp$impact_boot
    boot_effect <- boot_list$effect_cum[3, ]
    
    # Store data as tibble
    result_row <- tibble(fips = my_fips,
                         cumulative_effect = cumulative_effect,
                         rel_cumulative_effect = rel_cumulative_effect,
                         sd_norm = sd_norm,
                         ci_lower_norm = ci_lower_norm,
                         ci_upper_norm = ci_upper_norm,
                         p_value_left_norm = norm_effect$p_value_left,
                         sd_boot = boot_effect$sd,
                         ci_lower_boot = boot_effect$inf,
                         ci_upper_boot = boot_effect$sup,
                         p_value_left_boot = as.numeric(boot_list$p_values["p"]))
    
    # Add to current results
    results_list[[length(results_list) + 1]] <- result_row
    
    # Print progress
    message(glue("{i}/{length(fips_vec)}: FIPS {my_fips} processed."))
    
    # Save checkpoint every 50 iterations
    if (i %% 50 == 0 || i == length(fips_vec)) {
      checkpoint_df <- bind_rows(results_list)
      write_csv(checkpoint_df, "checkpoint_results.csv")
      message(glue("Checkpoint saved at iteration {i}"))
    }
    
  }, error = function(e) {
    warning(glue("Error for FIPS {my_fips}: {e$message}"))
  })
}

# Save and export results
co2_county_causal_arima <- bind_rows(results_list)
write_csv(co2_county_causal_arima, "co2_county_causal_arima.csv")
message("All counties processed. Final results saved.")