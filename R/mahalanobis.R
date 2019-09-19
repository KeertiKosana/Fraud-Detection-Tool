

return_m <- setNames(data.frame(matrix(ncol = 9, nrow = 0)), c("AP7INVOICESID", "CHECKS7ID", "PaymentAmount", "CheckAddedbyID", "InvoiceAddedbyID","PAYMENTMETHOD","DeltaTime", "HOD", "DOW_num"))

par(mfrow=c(4,3), oma=c(0,0,4,0))

for(i in 1:length(uniqueUsers)){

	plotTitle <- paste("UserID:", uniqueUsers[i], sep=" ")

	dataSubset <- modelData[modelData$CheckAddedbyID == uniqueUsers[i],]
	reducedSubset <- dataSubset[,c("DeltaTime", "HOD", "DOW_num")]

	mean<-colMeans(reducedSubset)
	Sx<-cov(reducedSubset)
	D2<-mahalanobis(reducedSubset,mean,Sx)
	plot(D2,main=plotTitle, ylab="Distance from distribution")

	D2 <- data.frame(D2)

	dataSubset$yCoord <- D2$D2
	dataSubset$xCoord <- 1:nrow(dataSubset)

	dataSubset$distance <- D2$D2
	dataSubset$outlier <- D2$D2
	dataSubset$userID <- uniqueUsers[i]
	
	if(uniqueUsers[i] == 1){
		abline(h=600, col="red")
		dataSubset$outlier[dataSubset$distance >= 600] <- 1
		dataSubset$outlier[dataSubset$distance <= 600] <- 0
	}
	else if(uniqueUsers[i] == 8){
		abline(h=400, col="red")
		dataSubset$outlier[dataSubset$distance >= 400] <- 1
		dataSubset$outlier[dataSubset$distance < 400] <- 0
	}
	else if(uniqueUsers[i] == 9){
		abline(h=17, col="red")
		dataSubset$outlier[dataSubset$distance >= 17] <- 1
		dataSubset$outlier[dataSubset$distance < 17] <- 0
	}
	else if(uniqueUsers[i] == 12){
		abline(h=90, col="red")
		dataSubset$outlier[dataSubset$distance >= 90] <- 1
		dataSubset$outlier[dataSubset$distance < 90] <- 0
	}
	else if(uniqueUsers[i] == 13){
		abline(h=1000, col="red")
		dataSubset$outlier[dataSubset$distance >= 1000] <- 1
		dataSubset$outlier[dataSubset$distance < 1000] <- 0
	}
	else if(uniqueUsers[i] == 26){
		abline(h=100, col="red")
		dataSubset$outlier[dataSubset$distance >= 100] <- 1
		dataSubset$outlier[dataSubset$distance < 100] <- 0
	}
	else if(uniqueUsers[i] == 27){
		abline(h=100, col="red")
		dataSubset$outlier[dataSubset$distance >= 100] <- 1
		dataSubset$outlier[dataSubset$distance < 100] <- 0
	}
	else if(uniqueUsers[i] == 28){
		abline(h=10, col="red")
		dataSubset$outlier[dataSubset$distance >= 10] <- 1
		dataSubset$outlier[dataSubset$distance < 10] <- 0
	}
	else if(uniqueUsers[i] == 31){
		abline(h=20, col="red")
		dataSubset$outlier[dataSubset$distance >= 20] <- 1
		dataSubset$outlier[dataSubset$distance < 20] <- 0
	}

	return_m <- rbind(return_m, dataSubset)
	print(nrow(data.frame( dataSubset$outlier[dataSubset$outlier == 1] )))
	print(nrow(data.frame(dataSubset$outlier)))
	cat("\n")

}

title("Mahalanobis Distance", outer=TRUE)

return_m$id <- 1:nrow(return_m)
return_m <- return_m[,c("id", "userID", "AP7INVOICESID", "CHECKS7ID", "PaymentAmount", "CheckAddedbyID", "InvoiceAddedbyID", "PAYMENTMETHOD", "DeltaTime", "HOD", "DOW_num", "DOW_str", "outlier", "xCoord", "yCoord")]


#returnJson <- toJSON(list(
	#user1 = return[return$userID == 1,],
	#user8 = return[return$userID == 8,],
	#user9 = return[return$userID == 9,],
	#user12 = return[return$userID == 12,],
	#user13 = return[return$userID == 13,],
	#user26 = return[return$userID == 26,],
	#user27 = return[return$userID == 27,],
	#user28 = return[return$userID == 28,],
	#ser31 = return[return$userID == 31,]

	#), pretty = TRUE)
#write(returnJson, "mahalanobis_outliers.json")

