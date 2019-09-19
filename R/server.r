shinyServer(function(input, output) {
  
    GL7_trans_account  <- reactive({
    data <- dbGetQuery(conn, statement = sprintf("SELECT *
                                                    FROM [FESeven2].[dbo].[GL7TRANSACTIONS]
                                                    WHERE [GL7ACCOUNTSID] = %s", input$Account))
    return(data)
    })
    
    GL7_trans_account_desc  <- reactive({
      data <- dbGetQuery(conn, statement = sprintf("SELECT [DESCRIPTION]
                                                   FROM [FESeven2].[dbo].[GL7ACCOUNTS]
                                                   WHERE [GL7ACCOUNTSID] = %s", input$Account))
      return(data)
    })
    
    
    #get all non NULL transactions for account #
    GL7Transaction_list <- reactive({
      
      data <- dbGetQuery(conn,statement = sprintf("SELECT [GL7TRANSACTIONSID] FROM [FESeven2].[dbo].[BBDISTRIBUTIONS]
                                                  WHERE [GL7ACCOUNTSID] = %s AND [GL7TRANSACTIONSID] IS NOT NULL", input$Account))
      
      
      rows <- nrow(data)
      
      df <- data.frame(
        Sequence = numeric(rows), 
        postDate = as.Date(numeric(rows), origin="1970-01-01"), 
        transactionType = numeric(rows),
        amount = numeric(rows)
        )
      
      for(i in 1:rows){
        
        newData <- dbGetQuery(conn,statement = sprintf("SELECT 
                                                [SEQUENCE],
                                                [POSTDATE],
                                                [AMOUNT],
                                                [TRANSACTIONTYPE]
                                                FROM [FESeven2].[dbo].[GL7TRANSACTIONS]
                                                WHERE [GL7TRANSACTIONSID] = %s", data$GL7TRANSACTIONSID[i]))
        
        df$Sequence[i] <- newData$SEQUENCE
        df$postDate[i] <- newData$POSTDATE
        df$transactionType[i] <- newData$TRANSACTIONTYPE
        df$amount[i] <- newData$AMOUNT
      }
      
      return(df)
    })
    
    
    GL7Transaction_list_reduced <- reactive({
      data <- GL7Transaction_list()
      #data <- PaidChecksInvoices[,c("ADDEDBYID.y", "AMOUNT.x","PAYMENTMETHOD","DeltaTime", "HOD", "DOW_num")]
      
      tsne <- Rtsne(data[,-1], dims = 2, perplexity=20, verbose=TRUE, max_iter = 500, check_duplicates = FALSE)
      
      #exeTimeTsne<- system.time(Rtsne(df[,-1], dims = 2, perplexity=30, verbose=TRUE, max_iter = 500, check_duplicates = FALSE))
      return(tsne)
    })
    
output$TransactionReduced <- renderPlot({
  data <- GL7Transaction_list_reduced()
  plot(data$Y)
  title(main = "t-Distributed Stochastic Neighbor Embedding Cluster Plot")
})



#K means plots
output$kMeans_global <- renderPlot({

  clusplot(modelData, k2$cluster, color=TRUE, shade=T, lines=0, main="K Means for K = 2")

})

output$outliers <- renderTable({
  data <- outliers[,c("AP7INVOICESID", "CHECKS7ID", "PAYEENAME", "AP7VENDORSID", "INVOICEAMOUNT", "InvoiceAddedByName", "CheckAddedByName", "CheckAddedDate", "INVOICEDATE", "DeltaTime","HOD", "DOW_str")]
  return(data)
})


output$InvoiceAccount <- renderPlot({
  data <- Invoice_df[Invoice_df$GL7ACCOUNTSID == input$Account,]
  barplot(table(data$DeltaDate))
  title(main = "Invoice Activity by Account", xlab="Number of Days", ylab="Frequency")
})


output$InvoiceGlobal <- renderPlot({
  barplot(table(Invoice_df$DeltaDate))
  title(main = "Global Invoice Activity", xlab="Number of Days", ylab="Frequency")
})

output$TransactionTypeAccount <- renderPlot({
  data <- Transactions_by_Type[Transactions_by_Type$GL7ACCOUNTSID == input$Account,]
  data <- Transactions_by_Type[Transactions_by_Type$TRANSACTIONTYPE == input$TransactionType,]
  barplot(table(data$DeltaDate))
  title(main = "Transaction Activity by Account")
})



output$AccountDesc <- renderText({
  desc <- GL7_trans_account_desc()
  paste("Description: ",desc$DESCRIPTION)
})    
    
    
output$GL7_summary <- renderTable({
  dataset <- GL7_summary
  summary(dataset)
})

# Show the first "n" observations
output$view <- renderTable({
  head(GL7_trans_account(), n = input$obs)
})


output$GL7_postDate<- renderDygraph({
  
  transData<-GL7_trans_account()
  
  #dates <- powerData[,1]
  #yesterday <- strftime(dates[length(dates)],"%Y-%m-%d %H:%M:%S")
  #oneWeek <- strftime(dates[length(dates)-168],"%Y-%m-%d %H:%M:%S")  
  
  dygraph(as.data.frame(transData$AMOUNT,transData$POSTDATE),group=1, main = "Post Date vs Amount")%>%
    #dyRangeSelector(dateWindow = c(oneWeek, yesterday), height = 60)%>%
    dySeries("transData$AMOUNT", label="Amount [$]")%>%
    dyAxis("y", label = "Amount")
  
})

output$GL7_addedDate<- renderDygraph({
  
  transData<-GL7_trans_account()
  
  #dates <- powerData[,1]
  #yesterday <- strftime(dates[length(dates)],"%Y-%m-%d %H:%M:%S")
  #oneWeek <- strftime(dates[length(dates)-168],"%Y-%m-%d %H:%M:%S")  
  
  dygraph(as.data.frame(transData$AMOUNT,transData$DATEADDED),group=1, main = "Transaction Date Added")%>%
    #dyRangeSelector(dateWindow = c(oneWeek, yesterday), height = 60)%>%
    dySeries("transData$AMOUNT", label="Amount [$]")%>%
    dyAxis("y", label = "Amount")
  
})

output$GL7_changedDate<- renderDygraph({
  
  transData<-GL7_trans_account()
  
  #dates <- powerData[,1]
  #yesterday <- strftime(dates[length(dates)],"%Y-%m-%d %H:%M:%S")
  #oneWeek <- strftime(dates[length(dates)-168],"%Y-%m-%d %H:%M:%S")  
  
  dygraph(as.data.frame(transData$AMOUNT,transData$DATECHANGED),group=1, main = "Transaction Date Changed")%>%
    #dyRangeSelector(dateWindow = c(oneWeek, yesterday), height = 60)%>%
    dySeries("transData$AMOUNT", label="Amount [$]")%>%
    dyAxis("y", label = "Amount")
  
})
  
  
})