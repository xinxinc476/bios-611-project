library(tidyverse)

data <- read.csv('derived_data/marketing_campaign_clean.csv') %>% as_tibble()
data$expenditure <- data$mntwines+data$mntfruits+data$mntmeatproducts+data$mntfishproducts+data$mntsweetproducts+data$mntgoldprods

# Convert the numeric variable expenditure as a categorial variable (5 levels)
expend_cate <- rep("<=100", length(data$expenditure))
for(i in 1:length(expend_cate)){
  if(data$expenditure[i] > 1500){
    expend_cate[i] = ">1500"
  }else if(data$expenditure[i] > 1000){
    expend_cate[i] = "1000-1500"
  }else if(data$expenditure[i] > 500){
    expend_cate[i] = "500-1000"
  }else if(data$expenditure[i] >100){
    expend_cate[i] = "100-500"
  }
}
expend_cate = factor(expend_cate, levels = c("<=100","100-500", "500-1000", "1000-1500", ">1500"))

data$expend_cate = expend_cate

rm(expend_cate)
d <- data %>% select(education, marital_status, income, age, days_enrollment, num_childs, expend_cate)

d$education <- as.factor(d$education)
d$marital_status <- as.factor(d$marital_status)



# Divide data into 10 folds 
library(caret)

set.seed(123)
folds = createFolds(d$expend_cate, k = 10, list = TRUE, returnTrain = FALSE)

res=matrix(NA, nrow=6, ncol=6)
colnames(res) = c(levels(d$expend_cate), "overall")
rownames(res) = c("POR", "QDA", "KNN", "SVM", "RF", "NB")

acc <- function(pred, truth){
  cate = levels(d$expend_cate)
  acc_vec = rep(0, 6)
  for (i in 1:5) {
    acc_vec[i] = round(mean(truth[pred==cate[i]]==cate[i]), 4) 
  }
  acc_vec[6] = round(mean(pred == truth), 4)
  return(acc_vec)
}



# Proportional Odds Model (POR)
library(MASS)

acc_por = matrix(NA, nrow = length(folds), ncol = 6)
colnames(acc_por) = colnames(res)
for (i in 1:length(folds)) {
  testIndex = folds[[i]]
  por <- polr(expend_cate~., data = d[-testIndex, ])
  pred = predict(por, newdata = d[testIndex, ])
  acc_por[i, ] = acc(pred, d$expend_cate[testIndex])
}

res["POR", ] = colMeans(acc_por)



# Quadratic Discriminant Analysis (QDA)
acc_qda = matrix(NA, nrow = length(folds), ncol = 6)
colnames(acc_qda) = colnames(res)
for (i in 1:length(folds)) {
  testIndex = folds[[i]]
  qda <- qda(expend_cate~., data = d, subset = (1:dim(d)[1])[-testIndex])
  pred = predict(qda, newdata = d[testIndex, ])
  acc_qda[i, ] = acc(pred$class, d$expend_cate[testIndex])
}

res["QDA", ] = colMeans(acc_qda)



# K-Nearest Neighbors (KNN) with k = 15
library(class)
d_num = d %>% mutate(education = as.numeric(education), marital_status=as.numeric(marital_status))
X = as.matrix(scale(d_num[, -7]))
Y = d_num$expend_cate

acc_knn = matrix(NA, nrow = length(folds), ncol = 6)
colnames(acc_knn) = colnames(res)

set.seed(10000)
for (i in 1:length(folds)) {
  testIndex = folds[[i]]
  pred = knn(X[-testIndex, ], X[testIndex, ], Y[-testIndex], k = 15)
  acc_knn[i, ] = acc(pred, Y[testIndex])
}

res["KNN", ] = colMeans(acc_knn)




