BIOS 611 Project
================

Customer Personality Analysis
-----------------------------

### Project description 

In this project, I am interested in conducting a customer personality analysis to determine whom the company's ideal customers are, which would help the company tailor the products to the customers' needs and create more effective marketing plans, hence making more profits. The dataset can be accessed through the following link: https://www.kaggle.com/imakash3011/customer-personality-analysis.

The dataset has 2240 observations/rows, each row representing the data from a unique customer. There are 29 variables/columns consisting of customers' demographic information like birth year, education level, and marital status, their purchase history like the amount spent on wines, fruits, and meat in the last two years, and the methods they use to buy the products like the number of purchases made through the company's website, a catalog, and in stores. More detailed descriptions of the variables can be found using the same link above.

#### Docker

To replicate the analysis shown here, you need to install Docker, a software which allows you to create "reproducible deployments." Once you have installed Docker, you can build a Docker image from the given Dockerfile by:
	
	docker build - < Dockerfile -t project

Then you can run the container on Rstudio server by:

	docker run -v $(pwd):/home/rstudio -e PASSWORD=pw -p 8787:8787 -t project

By typing "localhost:8787" in a browser and logging in using "rstudio" as the username and "pw" (or any other password you choose) as the password, you can access the Rstudio server.  


#### RShiny

You can start a shiny app within R Studio at the command line by:

	docker run -p 8788:8788 -p 8787:8787 -e PASSWORD=pw -v $(pwd)"/home/rstudio -t project


