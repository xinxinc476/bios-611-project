PHONY: clean

clean: 
	rm derived_data/*
	rm figures/*

#data cleaning:
#remove NA values and unreasonable values in income and age
#combine categories in education and marital status
derived_data/marketing_campaign_clean.csv:\
 source_data/marketing_campaign.csv\
 code/data_clean.R code/utils.R
	Rscript code/data_clean.R 
