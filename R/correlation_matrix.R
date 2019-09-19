modelData <- PaidChecksInvoices[,c("CheckAddedbyID", "InvoiceAddedbyID", "PAYMENTMETHOD", "DeltaTime", "HOD", "DOW_num")]
dataSubset <- modelData
dataSubset <- dataSubset[(dataSubset$DeltaTime > 0),]

M <- cor(dataSubset)
corrplot(M, method = "circle")