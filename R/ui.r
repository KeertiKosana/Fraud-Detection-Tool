library(shiny)

# Define UI for dataset viewer application
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Analyzing Data.."),
  br(),
  
  sidebarLayout(
    sidebarPanel( 
      
      selectInput("Account", "Choose Account:", 
                              GL7_accounts,
                              selected = GL7_accounts$GL7ACCOUNTSID[157])),
    
#    selectInput("TransactionType", "Transaction Type:", 
 #               TxTypes,
  #              selected = TxTypes$TRANSACTIONTYPE[1]),
  
    mainPanel()
  
    ),
  
  
   #plotOutput("plot")
      #textOutput("AccountDesc")
      
      fluidRow(
        
        column(6,
               plotOutput("InvoiceGlobal")
               ),
        column(6,
              
               
               plotOutput("InvoiceAccount"))
      ), # End Row 1

plotOutput("kMeans_global"),
tableOutput("outliers"),
plotOutput("TransactionReduced"),

  fluidRow(
    
    column(12,  dygraphOutput("GL7_addedDate"))
    #column(12,dygraphOutput("GL7_changedDate"))
  ),
  
  #dygraphOutput("GL7_postDate"),
  #br(),
  br()
  
  
  
  # Show a summary of the dataset and an HTML table with the 
  # requested number of observations
  #verbatimTextOutput("summary"),
  #tableOutput("user_summary"),
  #tableOutput("GL7_trans_summary")
  #tableOutput("view")
  
))