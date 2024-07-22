# Libraries
library(tidyverse)

# Data courtesy of https://www.kaggle.com/datasets/prajwaldongre/nvidia-corp-share-price-2000-2024/data

#Testing Data

# read in the dataset
nvda_data <- read.csv("C:/Users/micha/OneDrive/Desktop/NVDALinearLogisticAnalysis/stock_ticks.csv");
head(nvda_data)

close_open_model <- lm(close ~ volume, data = nvda_data)

# Print the model summary
summary(close_open_model)

