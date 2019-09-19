modelData <- PaidChecksInvoices[,c("AP7INVOICESID", "CHECKS7ID", "PaymentAmount", "CheckAddedbyID", "InvoiceAddedbyID","PAYMENTMETHOD","DeltaTime", "HOD", "DOW_num", "DOW_str")]
dataSubset <- modelData
dataSubset <- dataSubset[(dataSubset$DeltaTime > 0),]

model_h2o <- as.h2o(dataSubset)


splits <- h2o.splitFrame(model_h2o, ratios = 0.75, seed = -1)

train_unsupervised  <- splits[[1]]
train_unsupervised <- train_unsupervised[,c("CheckAddedbyID", "DeltaTime", "HOD", "DOW_num")]
	
test <- splits[[2]]
test <- test[,c("CheckAddedbyID", "DeltaTime", "HOD", "DOW_num")]

train_unsupervised_copy  <- splits[[1]]
test_copy <- splits[[2]]

response <- "CheckAddedbyID"
features <- setdiff(colnames(train_unsupervised), response)


model_nn <- h2o.deeplearning(x = features,
                             training_frame = train_unsupervised,
                             model_id = "model_nn",
                             autoencoder = TRUE,
                             reproducible = TRUE, #slow - turn off for real problems
                             ignore_const_cols = FALSE,
                             seed = 42,
                             hidden = c(10, 2, 10), 
                             epochs = 100,
                             activation = "Tanh")


train_features <- h2o.deepfeatures(model_nn, train_unsupervised, layer = 3) %>%
as.data.frame() %>%
as.h2o()



features_dim <- setdiff(colnames(train_features), response)


anomaly <- h2o.anomaly(model_nn, test) %>%
  as.data.frame() %>%
  tibble::rownames_to_column() %>%
  mutate(Class = as.vector(test[, 1]))

  mean_mse <- anomaly %>%
  group_by(Class) %>%
  summarise(mean = mean(Reconstruction.MSE))


  # plot reduced dimensions in global space
  plot(anomaly$rowname, anomaly$Reconstruction.MSE, main="Autoencoder Dimensionality Reduction for All Users", xlab="Instance Number", ylab="Mean Squared Errer (MSE)")
  #abline(h=.010, col="red")


  # plot reduced dimensions in global space color coded by feature
  #par(mfrow=c(2,3), oma=c(0,0,4,0))

  #for(i in 1:6){
  	#plot(anomaly$rowname, anomaly$Reconstruction.MSE, col=dataSubset[,i])
  	#abline(h=.015, col="red")
  #}  

  return_nn <- setNames(data.frame(matrix(ncol = 9, nrow = 0)), c("AP7INVOICESID", "CHECKS7ID", "PaymentAmount", "CheckAddedbyID", "InvoiceAddedbyID","PAYMENTMETHOD","DeltaTime", "HOD", "DOW_num"))

  par(mfrow=c(4,3), oma=c(0,0,4,0))

  for(i in 1:length(uniqueUsers)){

  	dataSubset_new <- as.data.frame(test_copy[test_copy$CheckAddedbyID == uniqueUsers[i],])

  	plotTitle <- paste("UserId:", uniqueUsers[i], sep=" ")

  	x <- anomaly$rowname[anomaly$Class == uniqueUsers[i]]
  	y <- anomaly$Reconstruction.MSE[anomaly$Class == uniqueUsers[i]]
 	plot(x,y, main=plotTitle, xlab="Instance Number", ylab="Mean Squared Errer (MSE)")


 	dataSubset_new$yCoord <- y
	dataSubset_new$xCoord <- x
	dataSubset_new$outlier <- 0

	dataSubset_new$userID <- uniqueUsers[i]


 	if(uniqueUsers[i] == 1){
		#abline(h=.0014, col="red")
		#dataSubset_new$outlier[dataSubset_new$yCoord >= .0014] <- 1
		#dataSubset_new$outlier[dataSubset_new$yCoord <= .0014] <- 0
	}
	else if(uniqueUsers[i] == 8){
		abline(h=0.015, col="red")
		dataSubset_new$outlier[dataSubset_new$yCoord >= .015] <- 1
		dataSubset_new$outlier[dataSubset_new$yCoord <= .015] <- 0
	}
	else if(uniqueUsers[i] == 9){
		abline(h=0.0016, col="red")
		dataSubset_new$outlier[dataSubset_new$yCoord >= .0016] <- 1
		dataSubset_new$outlier[dataSubset_new$yCoord <= .0016] <- 0
	}
	else if(uniqueUsers[i] == 12){
		abline(h=0.01, col="red")
		dataSubset_new$outlier[dataSubset_new$yCoord >= .001] <- 1
		dataSubset_new$outlier[dataSubset_new$yCoord <= .001] <- 0
	}
	else if(uniqueUsers[i] == 13){
		abline(h=0.018, col="red")
		dataSubset_new$outlier[dataSubset_new$yCoord >= .018] <- 1
		dataSubset_new$outlier[dataSubset_new$yCoord <= .018] <- 0
	}
	else if(uniqueUsers[i] == 26){
		abline(h=0.02, col="red")
		dataSubset_new$outlier[dataSubset_new$yCoord >= .02] <- 1
		dataSubset_new$outlier[dataSubset_new$yCoord <= .02] <- 0
	}
	else if(uniqueUsers[i] == 27){
		abline(h=0.002, col="red")
		dataSubset_new$outlier[dataSubset_new$yCoord >= .002] <- 1
		dataSubset_new$outlier[dataSubset_new$yCoord <= .002] <- 0
	}
	else if(uniqueUsers[i] == 28){
		abline(h=0.001, col="red")
		dataSubset_new$outlier[dataSubset_new$yCoord >= .001] <- 1
		dataSubset_new$outlier[dataSubset_new$yCoord <= .001] <- 0
	}
	else if(uniqueUsers[i] == 31){
		abline(h=0.0024, col="red")
		dataSubset_new$outlier[dataSubset_new$yCoord >= .0024] <- 1
		dataSubset_new$outlier[dataSubset_new$yCoord <= .0024] <- 0
	}

	return_nn <- rbind(return_nn, dataSubset_new)
	print(nrow(data.frame(dataSubset_new$outlier[dataSubset_new$outlier == 1] )))
	print(nrow(data.frame(dataSubset_new$outlier)))
	cat("\n")

  }


title("Autoencoder Dimensionality Reduction By UserID", outer=TRUE)

return_nn$id <- 1:nrow(return_nn)
return_nn <- return_nn[,c("id", "userID", "AP7INVOICESID", "CHECKS7ID", "PaymentAmount", "CheckAddedbyID", "InvoiceAddedbyID", "PAYMENTMETHOD", "DeltaTime", "HOD", "DOW_num", "DOW_str", "outlier", "xCoord", "yCoord")]





