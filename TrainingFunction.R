trainClassificationModel <- function(x,y,ETA,NROUNDS){
  #where x are input data, y are the labels (sex) of the input data, ETA is the learning rate,
  # and NROUNDs the initial number of trees 
  require(xgboost)
  print("Training classification model ...")
  dtrain<-xgb.DMatrix(data = as.matrix(x), label = as.matrix(y))
  xgbcv <- xgb.cv(data = dtrain, eta=ETA,
                  nrounds = NROUNDS, nfold = 5, early_stopping_rounds = 20,print_every_n = 10,
                  objective = "binary:logistic", verbose = 2,booster="gbtree")
  nroundPos<-xgbcv$best_iteration  #select the best iteration to train the model on the full data
  watchlist=list(train=dtrain)
  mdl <- xgb.train(data = dtrain,
                   nround = nroundPos,  subsample=0.5,watchlist = watchlist, eta=ETA, print_every_n = 10,
                   objective = "binary:logistic", verbose = 2,booster="gbtree")
  print("... done.")
  
  return(mdl)
}