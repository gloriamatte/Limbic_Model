library(data.table) 
require(cvTools) 
require(caret) 
library(xgboost)

mydataTraining<-fread("mydataTraining.csv", data.table = F) #load the imaging data
DemogTraining<-fread("demogTraininig.csv", data.table = F) #load the labels for variable of interest

mydataTest<-fread("mydataTest.csv", data.table = F) #load the imaging data for external validation
DemogTest<-fread("demogTest.csv", data.table = F) #load labels for the external dataset

#apply the training function: x = mydataTraining, y = DemogTraining
myModel<-trainClassificationModel(mydataTraining, DemogTraining, ETA = 0.01, NROUNDS = 1000)

#apply the trained model to the test data
predictionsTest<-predict(myModel, as.matrix(mydataTest))

#assign binary cutoff to check the performances in the test sample
pred_bin<-predictionsTest
pred_bin[pred_bin<=0.5]<-0
pred_bin[pred_bin>0.5]<-1

cm<-confusionMatrix(as.factor(pred_bin), as.factor(DemogTest))
cm

#to store the continous prediction
DemogTest$predictions<-predictionsTest





