library(tidyverse)
library(ggplot2)
library(gridExtra)
source('code/utils.R')

data <- read.csv('derived_data/marketing_campaign_clean.csv') %>% as_tibble()
data$expenditure <- data$mntwines+data$mntfruits+data$mntmeatproducts+data$mntfishproducts+data$mntsweetproducts+data$mntgoldprods

# Plots in RFM Analysis section
library(rfm)
data$num_of_purchases <- data$numcatalogpurchases+data$numstorepurchases+data$numwebpurchases

last_day <- as.Date("2014-10-04")
data$latest_visit_date = last_day-data$recency
data_rfm <- data %>% select(id, latest_visit_date, num_of_purchases, expenditure)
rfm_res = rfm_table_customer_2(data = data_rfm, customer_id = id, n_transactions = num_of_purchases, latest_visit_date = latest_visit_date, total_revenue = expenditure, analysis_date = last_day)

p <- rfm_heatmap(rfm_res, print_plot = FALSE)

ensure_directory('figures')
ggsave(file="figures/figure_heatmap.png", p, width = 5, height = 3, units = 'in', scale = 2) 



# Plots in Prediction of Expenditure section
data <- read.csv('derived_data/marketing_campaign_clean.csv') %>% as_tibble()
data$expenditure <- data$mntwines+data$mntfruits+data$mntmeatproducts+data$mntfishproducts+data$mntsweetproducts+data$mntgoldprods

# expenditure vs. income
p_income <- ggplot(data=data, aes(x=income, y=expenditure)) +
  geom_point(color="lightblue") 

# expenditure vs. education
p_edu <- ggplot(data, aes(x=education, y=expenditure)) + 
  geom_boxplot(aes(color = education), show.legend = FALSE)

# expenditure vs. marital status
p_mar <- ggplot(data, aes(x=marital_status, y=expenditure)) + 
  geom_boxplot(aes(color = marital_status), show.legend = FALSE) +
  labs(x = "marital status")

# expenditure vs. number of children
p_childs <- ggplot(data, aes(x=num_childs, y=expenditure, group = num_childs)) + 
  geom_boxplot(aes(color = factor(num_childs)), show.legend = FALSE) +
  labs(x = "number of children")

g <- arrangeGrob(p_income, p_edu, p_mar, p_childs, nrow=2) 
ggsave(file="figures/figure2.png", g, width = 5, height = 3, units = 'in', scale = 2) 
