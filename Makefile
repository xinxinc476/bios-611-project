.PHONY: clean

clean: 
	rm -f derived_data/*
	rm -f figures/*
	rm -f report.pdf
	rm -f Rplots.pdf

# report
report.pdf:\
 derived_data/marketing_campaign_clean.csv\
 figures/figure1.png\
 code/classification_models.R\
 report.Rmd
	Rscript -e "rmarkdown::render('report.Rmd')"
 
# derived data
# data cleaning:
# remove NA values and unreasonable values in income and age
# combine categories in education and marital status
derived_data/marketing_campaign_clean.csv:\
 source_data/marketing_campaign.csv\
 code/data_clean.R code/utils.R
	Rscript code/data_clean.R

# figures
# Figure1: heat map of the RFM scores
figures/figure_heatmap.png:\
 derived_data/marketing_campaign_clean.csv\
 code/plot.R code/utils.R
        Rscript code/plot.R

# Figure2: expenditure vs. income, education, marital status, and # of childs
figures/figure2.png:\
 derived_data/marketing_campaign_clean.csv\
 code/plot.R code/utils.R
	Rscript code/plot.R


