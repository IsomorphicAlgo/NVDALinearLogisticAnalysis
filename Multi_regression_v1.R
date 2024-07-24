# Install necessary packages if not already installed

# Load the libraries
library(readr)
library(dplyr)
library(tidyr)
library(broom)
library(ggplot2)
library(corrplot)

# Read in the CSV files
nvda_stock_ticks <- read_csv("stock_ticks.csv")
nvda_tech_indis <- read_csv("technical_indicators.csv")

print(colnames(nvda_stock_ticks))
print(colnames(nvda_tech_indis))

nvda_stock_ticks_duplicates <- nvda_stock_ticks %>%
  group_by(datetime) %>%
  filter(n() > 1)

nvda_tech_indis_duplicates <- nvda_tech_indis %>%
  group_by(bydatetime) %>%
  filter(n() > 1)

# Print the duplicates if any
if (nrow(nvda_stock_ticks_duplicates) > 0) {
  print("Duplicates found in nvda_stock_ticks:")
  print(nvda_stock_ticks_duplicates)
} else {
  print("No duplicates found in nvda_stock_ticks.")
}

if (nrow(nvda_tech_indis_duplicates) > 0) {
  print("Duplicates found in nvda_tech_indis:")
  print(nvda_tech_indis_duplicates)
} else {
  print("No duplicates found in nvda_tech_indis.")
}

# As we can see there was 8438 rows after the duplicate filter. Running code to remove

nvda_stock_ticks_clean <- nvda_stock_ticks %>%
  distinct(datetime, .keep_all = TRUE)

nvda_tech_indis_clean <- nvda_tech_indis %>%
  distinct(bydatetime, .keep_all = TRUE)
nvda_tech_indis_clean <- nvda_tech_indis_clean %>% rename(datetime = bydatetime, signal = bysignal, histogram = byhistogram)

nvda_joined <- full_join(nvda_stock_ticks_clean, nvda_tech_indis_clean, by = c("datetime", "id", "symbol"))

print(colnames(nvda_joined))
write.csv(nvda_joined, "nvda_joined.csv")
columns_to_convert <- c("open", "high", "low", "close", "volume", "macd", "signal", "histogram", "ema", "rsi")

nvda_joined[columns_to_convert] <- lapply(nvda_joined[columns_to_convert], as.numeric)
# Convert datetime from string to POSIXct date-time format
nvda_joined$datetime <- as.POSIXct(nvda_joined$datetime, format="%Y-%m-%d %H:%M:%S")

# Split datetime into individual date and time columns
nvda_joined$date <- as.Date(nvda_joined$datetime)
nvda_joined$time <- format(nvda_joined$datetime, format="%H:%M:%S")

# Select numeric columns for correlation, excluding 'close'
numeric_cols <- c("open", "high", "low", "close", "volume", "macd", "signal", "histogram", "ema", "rsi")
nvda_joined_numeric <- nvda_joined_nodate[numeric_cols]

correlation_matrix <- cor(nvda_joined_numeric)

# Print the correlation matrix
print("Correlation matrix:")
print(correlation_matrix)

correlations_nvda <- cor(nvda_joined_numeric$close, nvda_joined_numeric)
print(correlations_nvda)
# Correlation plot with numbers
corrplot(correlations_nvda, method = "number") 
s