library(tidyverse)
library(ggplot2)
library(gridExtra)
source('code/utils.R')

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
ensure_directory('figures')
ggsave(file="figures/figure1.png", g, width = 5, height = 3, units = 'in', scale = 2) 
