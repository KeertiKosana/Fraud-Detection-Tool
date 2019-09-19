library(shiny)
library(dygraphs)
library(rJava)
library(RJDBC)
library(Rtsne)

library(cluster)
library(fpc)

drv <- JDBC("com.microsoft.sqlserver.jdbc.SQLServerDriver", "/Library/Java/JavaVirtualMachines/jdk1.8.0_101.jdk/Contents/Home/lib/sqljdbc4.jar")
conn <- dbConnect(drv, "jdbc:sqlserver://localhost:1433; Database=FESeven2;", "sa", "hui34B*asd")


GL7_accounts <- dbGetQuery(conn, statement="SELECT DISTINCT [GL7ACCOUNTSID] FROM [FESeven2].[dbo].[GL7TRANSACTIONS]")

TxTypes <- dbGetQuery(conn, statement="SELECT DISTINCT [TRANSACTIONTYPE] FROM [FESeven2].[dbo].[GL7TRANSACTIONS]")


Invoice_Paid <-dbGetQuery(conn, statement = "SELECT [AP7INVOICESID], [PAYMENTDATE]
                         FROM [FESeven2].[dbo].[AP7PAYMENTS]
                         WHERE [STATUS] = 2")

Invoice_Added <-dbGetQuery(conn, statement = "SELECT [AP7INVOICESID], [INVOICEDATE]
                         FROM [FESeven2].[dbo].[AP7INVOICES]")


Invoice_by_Account <- dbGetQuery(conn, statement = "SELECT [PARENTID] as AP7INVOICESID, [GL7ACCOUNTSID]
                          FROM [FESeven2].[dbo].[BBDISTRIBUTIONS]
                          WHERE [SYSTEMMASK] = 4 AND [PARENTOBJECTTYPE] = 268;")

Invoice_df <- merge(Invoice_Paid, Invoice_Added, by="AP7INVOICESID")
Invoice_df <- merge(Invoice_df, Invoice_by_Account, by="AP7INVOICESID")
Invoice_df$DeltaDate <- as.numeric(as.Date(Invoice_df$PAYMENTDATE) - as.Date(Invoice_df$INVOICEDATE))
Invoice_df <- Invoice_df[Invoice_df$DeltaDate > 0, ]
Invoice_df <- Invoice_df[Invoice_df$DeltaDate < 50, ]


Transactions_by_Type <- dbGetQuery(conn, statement = "SELECT [GL7ACCOUNTSID],[TRANSACTIONTYPE],[POSTDATE],[DATECHANGED]
                          FROM [FESeven2].[dbo].[GL7TRANSACTIONS]"
                          )

Transactions_by_Type$DeltaDate <- as.numeric(as.Date(Transactions_by_Type$DATECHANGED) - as.Date(Transactions_by_Type$POSTDATE))







Invoices <- dbGetQuery(conn, statement = "SELECT [AP7INVOICESID], [INVOICEDATE], [AP7VENDORSID], [STATUS] as InvoiceStatus, [INVOICEAMOUNT], [REMITTO], [PAYMENTMETHOD], [ADDEDBYID]
                          FROM [FESeven2].[dbo].[AP7INVOICES]"
)

Payments <- dbGetQuery(conn, statement = "SELECT [AP7INVOICESID], [CHECKS7ID], [STATUS] as PaidStatus, [AMOUNT], [PAYMENTDATE]
                          FROM [FESeven2].[dbo].[AP7PAYMENTS]"
)

Checks <- dbGetQuery(conn, statement = "SELECT [CHECKS7ID], [PAYEENAME], [AMOUNT], [DATEADDED] as CheckAddedDate, [ADDEDBYID]
                          FROM [FESeven2].[dbo].[CHECKS7]"
)

Users <- dbGetQuery(conn, statement = "SELECT [USERSID], [NAME], [DESCRIPTION]
                          FROM [FESeven2].[dbo].[USERS]"
)


PaidChecks <- merge(Payments, Checks, by="CHECKS7ID")
PaidChecksInvoices <- merge(PaidChecks, Invoices, by="AP7INVOICESID")
PaidChecksInvoices$InvoiceAddedByName <- Users$NAME[PaidChecksInvoices$ADDEDBYID.x]
PaidChecksInvoices$CheckAddedByName <- Users$NAME[PaidChecksInvoices$ADDEDBYID.y]

NameMatch <- PaidChecksInvoices[PaidChecksInvoices$PAYEENAME == PaidChecksInvoices$CheckAddedByName & PaidChecksInvoices$PAYEENAME == PaidChecksInvoices$InvoiceAddedByName,]

PaidChecksInvoices$DeltaTime <- as.numeric(difftime(PaidChecksInvoices$CheckAddedDate, PaidChecksInvoices$INVOICEDATE, units="hours"))

PaidChecksInvoices$HOD <- as.numeric(substr(PaidChecksInvoices$CheckAddedDate, 12, 13))
PaidChecksInvoices$DOW_str <- strftime(PaidChecksInvoices$CheckAddedDate,'%A')
PaidChecksInvoices$DOW_num <- as.numeric(strftime(PaidChecksInvoices$CheckAddedDate,'%w'))

PaidChecksInvoices <- PaidChecksInvoices[PaidChecksInvoices$PaidStatus == 2,]
modelData <- PaidChecksInvoices[,c("ADDEDBYID.y", "AMOUNT.x","PAYMENTMETHOD","DeltaTime", "HOD", "DOW_num")]

k2 <- kmeans(modelData, centers = 2, nstart = 25)
PaidChecksInvoices$k <- k2$cluster

k2Table <- as.data.frame(table(k2$cluster))
MinK <- k2Table$Var1[which.min(k2Table$Freq)]

outliers <- PaidChecksInvoices[PaidChecksInvoices$k == MinK,]


