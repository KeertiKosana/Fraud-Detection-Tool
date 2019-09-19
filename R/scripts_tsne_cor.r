
modelData <- PaidChecksInvoices[,c("CheckAddedbyID", "InvoiceAddedbyID","PAYMENTMETHOD","DeltaTime", "HOD", "DOW_num")]

 
par(mfrow=c(4,3), oma=c(0,0,4,0))

for(i in 1:length(uniqueUsers)){

	plotTitle <- paste("UserID:", uniqueUsers[i], sep=" ")

	if( nrow(modelData[modelData$CheckAddedbyID == uniqueUsers[i],])>500 ){
	
		# if sample size is greater than 500, reduce sample

		dataSubset <- modelData[modelData$CheckAddedbyID == uniqueUsers[i],]
		dataSubset <- dataSubset[sample(nrow(dataSubset), 500), ]
	
		}else{
		
			dataSubset <- modelData[modelData$CheckAddedbyID == uniqueUsers[i],]
	
		}
	
		tsne <- Rtsne(dataSubset[,-1], dims = 2, perplexity=5, verbose=TRUE, max_iter = 500, check_duplicates = FALSE)
		print(nrow(dataSubset))
		plot(tsne$Y, main=plotTitle, xlab="X axis reduced dimensions", ylab="Y axis reduced dimensions")
}

title("tSNE Plots by User (Perplexity 5)", outer=TRUE)


#saving plots as images of size 1000x1200

