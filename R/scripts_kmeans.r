
#elbow method for number of clusters

k_df <- data.frame(sse = numeric(10), k = numeric(10) )
par(mfrow=c(4,3), oma=c(0,0,4,0))
for(i in 1:length(uniqueUsers)){

	plotTitle <- paste("UserID:", uniqueUsers[i], sep=" ")
	dataSubset <- modelData[modelData$CheckAddedbyID == uniqueUsers[i],]
	dataSubset <- dataSubset[,c("DeltaTime", "HOD", "DOW_num")]

	for(j in 1:10){
		k2 <- kmeans(dataSubset, centers = j, nstart = 25)
		k_df$k[j] <- j
		k_df$sse[j] <- k2$tot.withinss
		#PaidChecksInvoices$k <- k2$cluster
	}

	plot(k_df$k, k_df$sse, main=plotTitle, type = "l", xlab="Number of clusters (k)", ylab="Total within-clusters sum of squares")
}

title("K Means Total Within-Clusters Sum of Squares vs Number of Clusters", outer=TRUE)



return_k <- setNames(data.frame(matrix(ncol = 9, nrow = 0)), c("AP7INVOICESID", "CHECKS7ID", "PaymentAmount", "CheckAddedbyID", "InvoiceAddedbyID","PAYMENTMETHOD","DeltaTime", "HOD", "DOW_num"))
#modelData <- PaidChecksInvoices[,c("AP7INVOICESID", "CHECKS7ID", "PaymentAmount", "CheckAddedbyID", "InvoiceAddedbyID","PAYMENTMETHOD","DeltaTime", "HOD", "DOW_num")]

Days <-  c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")

# plotting clusters for k = 2
par(mfrow=c(4,3), oma=c(0,0,4,0))
for(i in 1:length(uniqueUsers)){


	plotTitle <- paste("UserID:", uniqueUsers[i], sep=" ")

	dataSubset <- modelData[modelData$CheckAddedbyID == uniqueUsers[i],]
	reducedSubset <- dataSubset[,c("DeltaTime", "HOD", "DOW_num")]

	if(i == 2 | i == 1){
		k2 <- kmeans(reducedSubset, centers = 3, nstart = 25)
	}else{
		k2 <- kmeans(reducedSubset, centers = 2, nstart = 25)
	}
	
	reducedSubset$k <- k2$cluster

	k2_table <- as.data.frame(table(k2$cluster))
	MinK <- k2_table$Var1[which.min(k2_table$Freq)]
	outliers <- reducedSubset[reducedSubset$k == MinK,]

	print(nrow(outliers))
	print(nrow(reducedSubset))
	cat("\n")

	dataSubset$cluster <- k2$cluster
	dataSubset$outlier <- k2$cluster
	dataSubset$outlier[dataSubset$outlier == MinK] <- 1
	dataSubset$outlier[dataSubset$outlier != MinK] <- 0
	dataSubset$userID <- uniqueUsers[i]
	#dataSubset$DOW_str <- Days[dataSubset$DOW_num]

	pca <- princomp(reducedSubset, scores = TRUE, cor = ncol(reducedSubset) > 2)
	plot(pca$scores)

	dataSubset$xCoord <- pca$scores[,1]
	dataSubset$yCoord <- pca$scores[,2]

	return_k <- rbind(return_k, dataSubset)


	#clusplot(reducedSubset, k2$cluster, color=TRUE, shade=T, lines=0, main=plotTitle)
}

title("K Means for 2 Clusters", outer=TRUE)


#princomp(reducedSubset, scores = TRUE, cor = ncol(reducedSubset) > 2)
#comp1 and comp2 are coordinates....

return_k$id <- 1:nrow(return_k)
return_k <- return_k[,c("id", "userID", "AP7INVOICESID", "CHECKS7ID", "PaymentAmount", "CheckAddedbyID", "InvoiceAddedbyID", "PAYMENTMETHOD", "DeltaTime", "HOD", "DOW_num", "DOW_str", "cluster", "outlier", "xCoord", "yCoord")]

#returnJson <- toJSON(list(
	#user1 = return[return$userID == 1,],
	#user8 = return[return$userID == 8,],
	#user9 = return[return$userID == 9,],
	#user12 = return[return$userID == 12,],
	#user13 = return[return$userID == 13,],
	#ser26 = return[return$userID == 26,],
	#ser27 = return[return$userID == 27,],
	#user28 = return[return$userID == 28,],
	#user31 = return[return$userID == 31,]

	#), pretty = TRUE)
#write(returnJson, "kmeans_outliers.json")
