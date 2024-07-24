# Libraries
library(tidyverse)

# Data courtesy of https://www.kaggle.com/datasets/prajwaldongre/nvidia-corp-share-price-2000-2024/data

#Testing Data

# read in the dataset
nvda_data <- read.csv("C:/Users/micha/OneDrive/Desktop/NVDALinearLogisticAnalysis/stock_ticks.csv");
head(nvda_data)

close_open_model <- lm(high ~ volume, data = nvda_data)

# Print the model summary
summary(close_open_model)
# Create a new data frame with the volume values for which we want to predict the close prices
new_data <- data.frame(volume = c(325225700))

# Use the model to make predictions
predicted_close <- predict(close_open_model, newdata = new_data)

# Print the predicted close prices
print(predicted_close)

