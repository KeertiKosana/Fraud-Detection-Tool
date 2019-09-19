#combine outlier detection results into json object

returnJson <- toJSON(list(
	Kmeans = return_k,
	mahalanobis = return_m,
	autoencoder = return_nn

	), pretty = TRUE)
write(returnJson, "outliers_merged.json")


# identify outliers common to all algorithms
reduced_k <- return_k[,c("id", "userID", "AP7INVOICESID", "CHECKS7ID", "PaymentAmount", "CheckAddedbyID", "InvoiceAddedbyID", "PAYMENTMETHOD", "DeltaTime", "HOD", "DOW_num", "DOW_str", "outlier")]
reduced_m <- return_m[,c("id", "userID", "AP7INVOICESID", "CHECKS7ID", "PaymentAmount", "CheckAddedbyID", "InvoiceAddedbyID", "PAYMENTMETHOD", "DeltaTime", "HOD", "DOW_num", "DOW_str", "outlier")]
reduced_nn <- return_nn[,c("id", "userID", "AP7INVOICESID", "CHECKS7ID", "PaymentAmount", "CheckAddedbyID", "InvoiceAddedbyID", "PAYMENTMETHOD", "DeltaTime", "HOD", "DOW_num", "DOW_str", "outlier")]

common_outliers <- rbind(reduced_nn, reduced_m, reduced_k)
common_outliers <- common_outliers[common_outliers$outlier == 1,]
common_outliers[duplicated(common_outliers$AP7INVOICESID), ]

return_common <- common_outliers[(duplicated(common_outliers$AP7INVOICESID) & duplicated(common_outliers$CHECKS7ID)), ]

return_common$id <- 1:nrow(return_common)

returnCommonJson <- toJSON(list(return_common), pretty = TRUE)

write(returnCommonJson, "commonOutliers.json")