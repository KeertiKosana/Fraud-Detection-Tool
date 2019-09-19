# save and subset data
modelData <- PaidChecksInvoices[,c("CheckAddedbyID", "InvoiceAddedbyID", "PAYMENTMETHOD", "DeltaTime", "HOD", "DOW_num")]
dataSubset <- modelData
dataSubset <- dataSubset[(dataSubset$DeltaTime > 0),]
dim <- length(dataSubset)

# determine perplexity value
	par(mfrow=c(2,2), oma=c(0,0,4,0))
	tsne_vec <- c(5,15,30,45)

	for(i in 1:length(tsne_vec)){

		plotTitle <- paste("Perplexity:", tsne_vec[i], sep=" ")

		tsne <- Rtsne(dataSubset[,-1], dims = 2, perplexity=tsne_vec[i], verbose=TRUE, max_iter = 500, check_duplicates = FALSE)

		#print(nrow(dataSubset))

		plot(tsne$Y, main=plotTitle, xlab="X axis reduced dimensions", ylab="Y axis reduced dimensions")

	}
	
	title("tSNE Plots By Perplexity", outer=TRUE)



tsne <- Rtsne(dataSubset[,-1], dims = 2, perplexity=15, verbose=TRUE, max_iter = 500, check_duplicates = FALSE)

	par(mfrow=c(2,3), oma=c(0,0,4,0))

	for(i in 1:dim){

		plotTitle <- colnames(dataSubset)[i]
		
		#print(nrow(dataSubset))

		plot(tsne$Y, main=plotTitle, xlab="X axis reduced dimensions", ylab="Y axis reduced dimensions", col=dataSubset[,i])

	}
	
	title("tSNE Plots All Users (Perplexity 15)", outer=TRUE)


#saving plots as images of size 1000x1200

