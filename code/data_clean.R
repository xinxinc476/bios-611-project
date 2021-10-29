library(tidyverse)
data <- read.delim('source_data/marketing_campaign.csv') %>% as_tibble()
names(data) <- tolower(names(data))

# income has 24 NA values, max(income)=666666
# remove NA values and income = 666666
data <- data %>% filter(data$income < 666666, na.rm = TRUE)

data$age <- 2014-data$year_birth 
# max(age) = 121
# remove age >= 100
data <- data %>% filter(data$age < 100)
# after removing, range(age) = (18, 74)
data <- data %>% select(-c(year_birth))

data$dt_customer <- as.Date(data$dt_customer, format = "%d-%m-%Y")
last_day <- as.Date("2014-10-04")
data$days_enrollment <- as.integer(last_day - data$dt_customer)
data <- data %>% select(-c(dt_customer))

data$num_childs <- data$kidhome + data$teenhome
data$has_child <- as.integer(data$num_childs > 0)
data <- data %>% select(-c(kidhome, teenhome))

data$marital_status[which(data$marital_status %in% c("Absurd","Divorced","Single","Widow","YOLO"))] = "Alone"
data$marital_status[which(data$marital_status=="Married")] = "Together"

data$education[which(data$education %in% c("2n Cycle", "Basic"))] = "Undergraduate"
data$education[which(data$education %in% c("Graduation","Master", "PhD"))] = "Postgraduate"

data <- data %>% select(-c(z_costcontact, z_revenue))
write_csv(data, 'derived_data/country_indicators.csv')
