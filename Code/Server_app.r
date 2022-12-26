# import cac thu vien
source("Process_data.R")
source("Ui_app.R")
#library(plotly)
library(caTools)
library(caret)
library(ggplot2)
library(broom)
server <- function(input, output) {
  
  # Hien thi du lieu in data(tab Panel)
  output$data_loan = DT::renderDataTable({
    datatable(df_loan, 
              extensions = c("FixedColumns", "FixedHeader", "Scroller"), 
              options = list(
                searching = TRUE,
                autoWidth = TRUE,
                rownames = FALSE,
                scrollX = TRUE,
                scrollY = "400px",
                fixedHeader = TRUE,
                class = 'cell-border stripe',
                fixedColumns = list(
                  leftColumns = 3,
                  heightMatch = 'none'
                )
              )
    )
  })
  
  # Thong ke mo ta
  output$Summ <- renderPrint({
    summary(df_loan[[input$var]])
  })
  output$Strr <- renderPrint({
    str(df_loan)
  })
  
  # Plot Type
  # output$caption<-renderText({
  #   
  #   switch(input$plot_type,
  #          "scatter" = "Scatter",
  #          "boxplot" 	= "Boxplot",
  #          "histogram" = "Histogram",
  #          "density" 	=	"Density plot",
  #          "bar" 		=	"Bar graph")
  # })
  
  # Plot bieu 
  output$plot<-renderPlot({
    
    mtc <- df_loan[ ,c(input$VarX,input$VarY)]
    switch(input$plot_type,
           "scatter" = plot(mtc[,1],mtc[,2],
                  xlab = colnames(mtc)[1],
                  ylab = colnames(mtc)[2],
                  main = paste("Scatter Plot of", input$VarX, "and", input$VarY),
                  col="violet",pch=15
             ),
           
           "boxplot" 	= boxplot(df_loan[,input$VarX],
                  main = paste("Boxplot of", input$VarX),
                  xlab = "Parts Per Billion",
                  ylab = input$VarX,
                  col = "orange",
                  border = "brown",
                  horizontal = TRUE,
                  notch = TRUE),
           
           "histogram" = hist(df_loan[,input$VarX],
                  main=paste("Histogram of", input$VarX),
                  xlab=input$VarX,
                  col="pink"),
           
           "density" 	=	plot(density(df_loan[,input$VarX]), 
                             frame = FALSE, 
                             col = "blue",
                             main = "Density of", input$VarX),
           
           "bar" 		=	barplot(table(df_loan[,input$VarX]), 
                             main="Bar plot",las = 2 ))
  })
  
  # Mô hình hồi quy tuyến tính
  model_lr <- reactive({
    step(lm(paste(input$Y, "~", paste(input$X, collapse = "+")), data = df_loan))
  })
  # Render Summary Mô hình hồi quy tuyến tính
  output$Model_LR<- renderPrint(summary(model_lr()))
  # Plot mô hình hồi quy tuyến tính
  # output$plot_lr <- renderPlot({
  #   plot(df_loan[,input$Y],type = "n")
  #   abline(model_lr(), col = "red")
  # })
  
  # output$plot_lr <- renderPlot({
  #   plot(df_loan[,input$Y],df_loan[,input$X],main = "Scatterplot",
  #        xlab = input$Y, ylab = input$X, pch = 19 )
  #   abline(model_lr(),col = "red" )
  #   lines(lowess(df_loan[,input$Y],df_loan[,input$X]),col ="blue" )
  # },height = 300)
    
  # Tesst Plot 
  output$plot_lr <- renderPlot({
    #req(lmModel())
    par(mfrow=c(2,2))
    plot(model_lr())
  })
  
  # Mo hinh hoi quy logistic
  # Tạo seed và tách mẫu
  # df_not_purpose <- df_loan[,-2]
  set.seed(100)
  # Phân vùng
  Training_Ratio <- createDataPartition(df_loan$not_fully_paid, p=0.7, list = F)
  Training_Data <- df_loan[Training_Ratio,]
  Test_Data <- df_loan[-Training_Ratio,]
  
  model_glm <- reactive({
    step(glm(paste(input$D_v, "~", paste(input$In_v, collapse = "+")), data = Training_Data))
  })
  
  # Summary cua mo hinh hoi quy logit
  output$glr_model<- renderPrint(summary(model_glm()))
 
   # Plot ket qua cua mo hinh hoi quy tuyen tinh
  # probs <- reactive({
  #   predict(model_glm(), newdata = Test_Data, type = "response")
  # })
  # 
  # output$plot_glm <- renderPlot({
  #   library(ROCR)
  #   pred <-as.numeric(prediction(probs,Test_Data$not_fully_paid))
  #   perf <- performance(pred, "tpr", "fpr")
  #   plot(perf, colorize = TRUE)
  # })
  
  model_new <- reactive({
    glm(not_fully_paid~., data = Training_Data,family = "binomial")
  })
  # Xu ly du doan cho vay
  observeEvent(input$predict, {
    prediction <- reactive({
        loan_data <- data.frame(
          credit_policy = as.numeric(input$credit_policy),
          purpose = input$purpose,
          int_rate = as.numeric(input$int_rate),
          installment = as.numeric(input$installment),
          log_annual_inc = as.numeric(input$log_annual_inc),
          dti = as.numeric(input$dti),
          fico = as.numeric(input$fico),
          days_with_cr_line = as.numeric(input$days_with_cr_line),
          revol_bal = as.numeric(input$revol_bal),
          revol_util = as.numeric(input$revol_util),
          inq_last_6mths = as.numeric(input$inq_last_6mths),
          delinq_2yrs = as.numeric(input$delinq_2yrs),
          pub_rec = as.numeric(input$pub_rec)
        )
        predict(newdata = loan_data, type = "response", model_new())
    })
    
    # Output the prediction with text
    output$prediction <- renderText({
      if (prediction() > 0.6) {
        "Co kha nang tra no"
      } else {
        "Khong co kha nang tra no"
      }
      # %predict
      # prediction()
    })
    
    # Output predict with chart
    # output$prediction <- renderPlotly({
    #   plot_ly(values = prediction(),labels = c("Ok","Ko") ,type = "pie")
    # })
    
  })

  
}
