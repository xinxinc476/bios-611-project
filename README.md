BIOS 611 Project
================

Customer Personality Analysis
-----------------------------

### Project description 

In this project, I am interested in conducting a customer personality analysis to determine whom the company's ideal customers are, which would help the company tailor the products to the customers' needs and create more effective marketing plans, hence making more profits. The dataset can be accessed through the following link: https://www.kaggle.com/imakash3011/customer-personality-analysis.

The dataset has 2240 observations/rows, each row representing the data from a unique customer. There are 29 variables/columns consisting of customers' demographic information like birth year, education level, and marital status, their purchase history like the amount spent on wines, fruits, and meat in the last two years, and the methods they use to buy the products like the number of purchases made through the company's website, a catalog, and in stores. More detailed descriptions of the variables can be found using the same link above.


### Docker

To replicate the analysis shown here, you need to install Docker, a software which allows you to create "reproducible deployments." Once you have installed Docker, you can build a Docker image and create a Docker container from the given Dockerfile by:
	
	docker build - < Dockerfile -t project

Then you can run the container on Rstudio server by:

	docker run -v $(pwd):/home/rstudio -e PASSWORD=pw -p 8787:8787 -t project

By typing "localhost:8787" on your browser and logging in using "rstudio" as the Username and "pw" (or any other password you choose) as the Password, you can access the Rstudio server.  


### Make

You can use Make to generate the final report by:

	make report.pdf 


### RShiny

You can start a shiny app within R Studio at the command line by:

	docker run -p 8788:8788 -p 8787:8787 -e PASSWORD=pw -v $(pwd):/home/rstudio -t project

Then within R studio, you can launch the shiny app from the command line/terminal by:

	Rscript code/shiny.R

The Shiny app should be accessible on localhost:8788 on your browser. 

The Shiny app shows a clustering of the customers based on the number days they enrolled with the company (until 2014/12/31), their yearly household incomes, and their expenditures (the total amount spent on wine, fruits, meat, fish, sweets, and gold in 2012~2014). 
