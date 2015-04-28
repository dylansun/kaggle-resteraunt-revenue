library(Boruta)
library(caret)
library(e1071)
train <- read.csv("data/train.csv")
test  <- read.csv("data/test.csv")

n.train <- nrow(train)

test$revenue <- 1
myData <- rbind(train, test)

rm(train, test)

## Transform time
myData$Open.Date <- as.POSIXct("01/01/2015", format = "%m/%d/%Y") - as.POSIXct(myData$Open.Date, format = "%m/%d/%Y")
myData$Open.Date <- as.numeric(myData$Open.Date/1000)

#consolidate Cities
myData$City    <- as.character(myData$City)
myData$City[myData$City.Group == "Other"] <- "other"
myData$City[myData$City == unique(myData$City)[4]] <- unique(myData$City)[2]
myData$City   <- as.factor(myData$City)
myData$City.Group   <- NULL 

#consolidate Types
myData$Type <- as.character(myData$Type)
myData$Type[myData$Type == "DT"] <- "IL"
myData$Type[myData$Type == "MB"] <- "FC"
myData$Type  <- as.factor(myData$Type)

#Log Transform P variables and Revenue
myData[, paste("P", 1:37, sep = "")] <- log(1+myData[, paste("P", 1:37, sep = "")])
myData$revenue <- log(myData$revenue)

important <- Boruta(revenue ~ ., data = myData[1:n.train,])
fit <- svm(revenue ~ . , data = myData[1:n.train, c(important$finalDecision != "Rejected", TRUE)])
predictions <- as.data.frame(predict(fit, newdata = myData[-c(1:n.train), ]))
submit <- as.data.frame(cbind(seq(0, nrow(predictions) - 1, by = 1), exp(predictions)))
colnames(submit) <- c("Id", "Prediction")
write.csv(submit, "res/my_svm_benchmark.csv", quote = F, row.names = F)
#1840852.74559

rf.fit <- train(revenue ~ ., data = myData[1:n.train, c(important$finalDecision != "Rejected", TRUE)])
rf.pred <- predict(rf.fit, myData[-c(1:n.train), ])

rf.submit <- as.data.frame(cbind(seq(0, length(rf.pred) - 1, by = 1), exp(rf.pred)))
colnames(rf.submit) <- c("Id", "Prediction")
write.csv(rf.submit,  file = "res/rf.sub.csv", row.names = F, quote = F)
#1753115.19882

lr.fit <- lm(revenue ~ ., data = myData[1:n.train, c(important$finalDecision != "Rejected", TRUE)])
lr.pred <- predict(lr.fit, myData[-c(1:n.train), ])
lr.submit <- as.data.frame(cbind(seq(0, length(rf.pred) - 1, by = 1), exp(lr.pred)))
colnames(lr.submit) <- c("Id", "Prediction")
write.csv(lr.submit,  file = "res/lr.sub.csv", row.names = F, quote = F)
#
