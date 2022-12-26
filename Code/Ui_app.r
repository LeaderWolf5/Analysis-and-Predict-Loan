# Import thư viện
library(shinydashboard)
library(shiny)
library(tidyverse)
library(DT)
library(shinycssloaders)
library(plotly)
# xay dung ui
ui <- dashboardPage(
  dashboardHeader(title = "Analysis and Predict Loan", titleWidth = 300),
  dashboardSidebar(width = 300,
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("home")),
      menuItem("Model", tabName = "model", icon = icon("tasks")),
      menuItem("Predict", tabName = "predict", icon = icon("usd"))
    )
  ),
  # xay dung noi dung cho moi menuItem
  dashboardBody(
   tabItems(
     
     tabItem(tabName = "dashboard",
             fluidRow(
               infoBox("Ho Dang Bao", "19IT6", icon = icon("user")),
               infoBox("Nguyen Duc Hoan", "19IT6", icon = icon("user")),
               infoBox("Nguyen Van Hung", "19IT6", icon = icon("user"))
             ),
             
             fluidRow(
               box(title = "Thematic(5)-1_Data analysis", "Project construction project 
                   analysis and loan prediction",background = "light-blue"),
               box(title = "Overview", "Build Shiny App","Use R with Regression model and
                   Visualization",background = "light-blue")
             ),
             
             fluidPage(
               tabBox(
                 id = "tabset1",
                 height = 550,
                 width = 12,
                 tabPanel("Data",
                          DT::dataTableOutput("data_loan")),
                 tabPanel("Description", 
                          box(title = "Structure",withSpinner(verbatimTextOutput("Strr")), width = 6),
                          box(title = "Statistics",
                              selectInput("var", "Select variable", choices = names(df_loan)),
                              verbatimTextOutput("Summ")
                              )),
          
                 tabPanel("Plots",
                          fluidRow(
                              box(width = 4,
                                  selectInput(inputId = "VarX",
                                              label = "Choose X-axis variable",
                                              choices = names(df_loan))),
                              box(width = 4,
                                  selectInput(inputId = "VarY",
                                              label = "Select Y-axis Variable:",
                                              choices = names(df_loan))),
                              box(width = 4,
                                  selectInput("plot_type","Plot Type", 
                                              list(scatter = "scatter",
                                                  boxplot = "boxplot", 
                                                   histogram = "histogram", 
                                                   density = "density", 
                                                   bar = "bar"))),
                            ),
                            mainPanel(width = 10,
                               plotOutput("plot"))
                          )
                 
               )
             )
     ),
     
     # Xây dựng phần Model
     tabItem(tabName = "model",
             fluidPage(tabBox(width = 12,height = 800,
                              tabPanel("Linear Regression",
                                       
                                       box(
                                         selectInput(
                                           "X",
                                           label = "Select variables:",
                                           choices = names(df_loan),
                                           multiple = TRUE,
                                           selected = names(df_loan)
                                         ),
                                         solidHeader = TRUE,
                                         width = "3",
                                         status = "primary",
                                         title = "Predictor variable"
                                       ),
                                       box(
                                         selectInput("Y", label = "Select variable", choices = names(df_loan)),
                                         solidHeader = TRUE,
                                         width = "3",
                                         status = "primary",
                                         title = "Response variable"
                                       ),
                                       box(withSpinner(verbatimTextOutput("Model_LR")),width = 6, title = "Model Summary"),
                                       plotOutput("plot_lr")
                                       
                                       
                                         
                              ),
                              
                              tabPanel("Logistic Regression",
                                       
                                       box(
                                         selectInput(
                                           "In_v",
                                           label = "Select variables:",
                                           choices = names(df_loan),
                                           multiple = TRUE,
                                           selected = names(df_loan)
                                         ),
                                         solidHeader = TRUE,
                                         width = "3",
                                         status = "primary",
                                         title = "Independent variable"
                                       ),
                                       box(
                                         selectInput("D_v", label = "Select variable", choices = names(df_loan)),
                                         solidHeader = TRUE,
                                         width = "3",
                                         status = "primary",
                                         title = "Dependent variable"
                                       ),
                                       
                                       box(withSpinner(verbatimTextOutput("glr_model")),width = 6, title = "Model Summary"),     
                                       box(plotOutput("plot_glm") )
                                       
                              )
               
                       ) 
             )
     ),
     
     
     tabItem(tabName = "predict",
             box(
               width = "12",
               box(
                 width = "4",
                 textInput("log_annual_inc", "Annual income"),
                 textInput("fico", "Credit Score"),
                 textInput("int_rate", "Rate"),
                 textInput("installment", "Installment"),
                 textInput("credit_policy", "Credit policy"),
                 textInput("dti", "Debt to income")
               ),
               box(
                 width = "4",
                 textInput("days_with_cr_line", "Days with credit line"),
                 textInput("revol_bal", "Revol bal"),
                 textInput("revol_util", "Revol util"),
                 textInput("inq_last_6mths", "Inquiries last 6mths"),
                 textInput("delinq_2yrs", "Delinquencies 2yrs"),
                 textInput("pub_rec", "Public record")
               ),
               box(
                 width = "4",
                 selectInput("purpose", "Variable:",
                             c("credit_card" = "credit_card",
                               "debt_consolidation" = "debt_consolidation",
                               "education" = "education",
                               "other"= "other")),
                 br(),
                 actionButton("predict", "Predict"),
                 br(),
                 br(),
                 textOutput("prediction")
                 # plotlyOutput("prediction")
               )
             )
     )
     
     
   )# Close tabItems tong
   
  )# close dashboardBody
  
)# close Ui



