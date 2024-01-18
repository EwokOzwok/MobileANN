#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinyMobile
#' @import tensorflow
#' @import keras
#' @import dplyr
#' @import utils
#' @import reticulate
#' @noRd
app_server <- function(input, output, session) {
reticulate::use_virtualenv(virtualenv='r-tensorflow', required=T)

# Load Model on Startup ---------------------------------------------------

  model <- keras::load_model_tf(filepath="Seq3", compile = T)
# Help Popup --------------------------------------------------------------

  observe({
    f7Popup(id="NewUserintro", title= f7Align(h3("Quick Introduction"), side=c("center")), swipeToClose = T,
            f7Block(
              f7Shadow(
                intensity = 30,
                hover = F,
                f7Card(f7BlockHeader(text="Navigating the App"),
                       f7Align(h4("Use the buttons at the bottom of the screen to navigate to the different tabs"), side=c("center")),
                       hairlines = F, strong = T, inset =
                         F, tablet = FALSE))),
            f7Block(
              f7Shadow(
                intensity = 30,
                hover = F,
                f7Card(f7BlockHeader(text="What do the buttons do?"),
                       h5(f7Icon("cloud_download"), "- Download sample data"),
                       h5(f7Icon("wand_stars_inverse"),"- Generate ANN predictions"),
                       h5(f7Icon("hammer_fill"),"- Change data & predict again"),
                       hairlines = F, strong = T, inset =
                         F, tablet = FALSE)),
              br(),
              br(),
              br(),
              br(),
              br(),
              f7BlockFooter(f7Align(h4("Swipe up to close this popup"), side=c("center"))))
    )
  })

  observeEvent(input$helppopup, {
    f7Popup(id="NewUserintro", title= f7Align(h3("Quick Introduction"), side=c("center")), swipeToClose = T,
            f7Block(
              f7Shadow(
                intensity = 30,
                hover = F,
                f7Card(f7BlockHeader(text="Navigating the App"),
                       f7Align(h4("Use the buttons at the bottom of the screen to navigate to the different tabs"), side=c("center")),
                       hairlines = F, strong = T, inset =
                         F, tablet = FALSE))),
            f7Block(
              f7Shadow(
                intensity = 30,
                hover = F,
                f7Card(f7BlockHeader(text="What do the buttons do?"),
                       h5(f7Icon("cloud_download"), "- Download sample data"),
                       h5(f7Icon("wand_stars_inverse"),"- Generate ANN predictions"),
                       h5(f7Icon("hammer_fill"),"- Change data & predict again"),
                       hairlines = F, strong = T, inset =
                         F, tablet = FALSE)),
              br(),
              br(),
              br(),
              br(),
              br(),
              f7BlockFooter(f7Align(h4("Swipe up to close this popup"), side=c("center"))))
    )
    output$ModelInformation <- renderUI({
      tagList()
    })
  })



# Data read in ------------------------------------------------------------


  normal<-as.data.frame(normal)
  mild<-as.data.frame(mild)
  moderate<-as.data.frame(moderate)
  severe<-as.data.frame(severe)
  sd_data<-as.data.frame(sd_data)

# Download Data  ----------------------------------------------------------


  output$downloadnormal <- downloadHandler(
    filename = function() {
      paste("Normal Depression - ", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      write.csv(normal, file, row.names = F)
    }
  )


  output$downloadmild <- downloadHandler(
    filename = function() {
      paste("Mild Depression - ", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      write.csv(mild, file, row.names = F)
    }
  )


  output$downloadmoderate <- downloadHandler(
    filename = function() {
      paste("Moderate Depression - ", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      write.csv(moderate, file,row.names = F)
    }
  )


  output$downloadsevere <- downloadHandler(
    filename = function() {
      paste("Severe Depression - ", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      write.csv(severe, file,row.names = F)
    }
  )



# Upload Data -------------------------------------------------------------


  rawData <- reactive({
    req(input$file1)
    paste("uploaded)")
    read.csv(input$file1$datapath)

  })


# Display Model -----------------------------------------------------------


  observeEvent(input$ModelLoad, {
    output$ModelInformation <- renderUI({
      tagList(
        f7Card(
          f7Align(h2("Model"), side=c("center")),
          HTML('<center><img src="https://i.ibb.co/xSv4NZV/Neural-Net.png" width=70%></center>'),
          hairlines = F, strong = T, inset =
            F, tablet = FALSE)
      )
    })

  })



# Generate Prediction -----------------------------------------------------


  observeEvent(input$ModelPredict, {
    req(rawData())
    data<-as.matrix(rawData())
    pred<- model %>% predict(data)
    preddata<-as.data.frame(pred)
    colnames(preddata)<-c("Normal", "Mild", "Moderate", "Severe")



    if((preddata$Normal > preddata$Mild)&(preddata$Normal > preddata$Moderate)&(preddata$Normal > preddata$Severe)){
      Class<-c("Normal")
      PredictionLikelihood<-preddata$Normal*100
    }

    if((preddata$Mild > preddata$Normal)&(preddata$Mild > preddata$Moderate)&(preddata$Mild > preddata$Severe)){
      Class<-c("Mild")
      PredictionLikelihood<-preddata$Mild*100
    }

    if((preddata$Moderate > preddata$Normal)&(preddata$Moderate > preddata$Mild)&(preddata$Moderate > preddata$Severe)){
      Class<-c("Moderate")
      PredictionLikelihood<-preddata$Moderate*100
    }

    if((preddata$Severe > preddata$Normal)&(preddata$Severe > preddata$Mild)&(preddata$Severe > preddata$Moderate)){
      Class<-c("Severe")
      PredictionLikelihood<-preddata$Severe*100
    }



    output$pred1 <- renderText({
      paste(c("Student's predicted depression class after mid-terms:"), Class)

    })

    output$pred2 <- renderText({
      paste(c("Prediction Confidence:", round(PredictionLikelihood, digits = 2), "%"))

})
      output$Predictions<-renderUI({
        tagList(
          f7Card(
            f7Align(h2("Prediction"), side=c("center")),
            textOutput("pred1"),
            textOutput("pred2"),
            br(),
            hairlines = F, strong = T, inset =
              F, tablet = FALSE)
        )

})
    })

# Clear Prediction Space --------------------------------------------------

    observeEvent(input$Clear, {
      output$Predictions <- renderText({})
      output$pred11 <- renderText({})
      output$pred22 <- renderText({})
      })

  observeEvent(input$Clear1, {
  output$newmodelpreds<- renderUI({
    tagList()
  })
  })

  observeEvent(input$Clear2, {
    output$delta_ace_pred<- renderUI({
      tagList()
    })
  })

# Altering Input data -----------------------------------------------------

observeEvent(rawData(),{
  vardata<-rawData()
  updateNumericInput(session,"DEP1",value=vardata[,1])
  updateNumericInput(session,"PEARLS1",value=vardata[,2])
  updateNumericInput(session,"GQmean1",value=vardata[,3])
  updateNumericInput(session,"SJ1",value=vardata[,4])
  updateNumericInput(session,"OI1",value=vardata[,5])
  updateNumericInput(session,"I1",value=vardata[,6])
  updateNumericInput(session,"SK1",value=vardata[,7])
  updateNumericInput(session,"M1",value=vardata[,8])
  updateNumericInput(session,"CH1",value=vardata[,9])
  updateNumericInput(session,"AHSa1",value=vardata[,10])
  updateNumericInput(session,"AHSp1",value=vardata[,11])
  updateNumericInput(session,"RSE1",value=vardata[,12])

  updateNumericInput(session,"DEP2",value=vardata[,13])
  updateNumericInput(session,"PEARLS2",value=vardata[,14])
  updateNumericInput(session,"GQmean2",value=vardata[,15])
  updateNumericInput(session,"SJ2",value=vardata[,16])
  updateNumericInput(session,"OI2",value=vardata[,17])
  updateNumericInput(session,"I2",value=vardata[,18])
  updateNumericInput(session,"SK2",value=vardata[,19])
  updateNumericInput(session,"M2",value=vardata[,20])
  updateNumericInput(session,"CH2",value=vardata[,21])
  updateNumericInput(session,"AHSa2",value=vardata[,22])
  updateNumericInput(session,"AHSp2",value=vardata[,23])
  updateNumericInput(session,"RSE2",value=vardata[,24])
})



observeEvent(input$NewPred,{
  req(rawData())
  data1<-matrix(nrow = 1, ncol = 24)
  data1[,1]<-input$DEP1
  data1[,2]<-input$PEARLS1
  data1[,3]<-input$GQmean1
  data1[,4]<-input$SJ1
  data1[,5]<-input$OI1
  data1[,6]<-input$I1
  data1[,7]<-input$SK1
  data1[,8]<-input$M1
  data1[,9]<-input$CH1
  data1[,10]<-input$AHSa1
  data1[,11]<-input$AHSp1
  data1[,12]<-input$RSE1
  data1[,13]<-input$DEP2
  data1[,14]<-input$PEARLS2
  data1[,15]<-input$GQmean2
  data1[,16]<-input$SJ2
  data1[,17]<-input$OI2
  data1[,18]<-input$I2
  data1[,19]<-input$SK2
  data1[,20]<-input$M2
  data1[,21]<-input$CH2
  data1[,22]<-input$AHSa2
  data1[,23]<-input$AHSp2
  data1[,24]<-input$RSE2
  print(data1)

  pred1<- model %>% predict(data1)
  preddata1<-as.data.frame(pred1)


  colnames(preddata1)<-c("Normal", "Mild", "Moderate", "Severe")



  if((preddata1$Normal > preddata1$Mild)&(preddata1$Normal > preddata1$Moderate)&(preddata1$Normal > preddata1$Severe)){
    Class1<-c("Normal")
    PredictionLikelihood1<-preddata1$Normal*100
  }

  if((preddata1$Mild > preddata1$Normal)&(preddata1$Mild > preddata1$Moderate)&(preddata1$Mild > preddata1$Severe)){
    Class1<-c("Mild")
    PredictionLikelihood1<-preddata1$Mild*100
  }

  if((preddata1$Moderate > preddata1$Normal)&(preddata1$Moderate > preddata1$Mild)&(preddata1$Moderate > preddata1$Severe)){
    Class1<-c("Moderate")
    PredictionLikelihood1<-preddata1$Moderate*100
  }

  if((preddata1$Severe > preddata1$Normal)&(preddata1$Severe > preddata1$Mild)&(preddata1$Severe > preddata1$Moderate)){
    Class1<-c("Severe")
    PredictionLikelihood1<-preddata1$Severe*100
  }



  output$pred11 <- renderText({
    paste(c("Student's predicted depression class after mid-terms:"), Class1)

  })

  output$pred22 <- renderText({
    paste(c("Prediction Confidence:", round(PredictionLikelihood1, digits = 2), "%"))

  })

  output$newmodelpreds<-renderUI({
    tagList(
      f7Block(
        f7Shadow(
          intensity = 5,
          hover = TRUE,
          f7Card(
            f7Align(h2("New Prediction"), side=c("center")),
            textOutput("pred11"),
            textOutput("pred22")
          ))

    )
    )
  })


})




# Change ACES Button ------------------------------------------------------
observeEvent(input$changeace,{
  req(rawData())
  data_ace<-as.matrix(rawData())
  print(data_ace)
  PreACES_sd<-sd_data[2,1]
  PostACES_sd<-sd_data[14,1]
  PreDEP_sd<-sd_data[1,1]
  PostDEP_sd<-sd_data[13,1]

  PreACES_SD_rate<-input$changePREaceslider
  PostACES_SD_rate<-input$changePOSTaceslider

  PreDEP_SD_rate<-input$changePREdepslider
  PostDEP_SD_rate<-input$changePOSTdepslider

  data_ace[,2]<-data_ace[,2]+(PreACES_sd*PreACES_SD_rate)
  data_ace[,14]<-data_ace[,14]+(PostACES_sd*PostACES_SD_rate)

  data_ace[,1]<-data_ace[,1]+(PreDEP_sd*PreDEP_SD_rate)
  data_ace[,13]<-data_ace[,13]+(PostDEP_sd*PostDEP_SD_rate)

  pred_ace_delta<- model %>% predict(data_ace)
  print(pred_ace_delta)

  pred_ace_delta_df<-as.data.frame(pred_ace_delta)

  colnames(pred_ace_delta_df)<-c("Normal", "Mild", "Moderate", "Severe")



  if((pred_ace_delta_df$Normal > pred_ace_delta_df$Mild)&(pred_ace_delta_df$Normal > pred_ace_delta_df$Moderate)&(pred_ace_delta_df$Normal > pred_ace_delta_df$Severe)){
    Class_ace<-c("Normal")
    PredictionLikelihood_ace<-pred_ace_delta_df$Normal*100
  }

  if((pred_ace_delta_df$Mild > pred_ace_delta_df$Normal)&(pred_ace_delta_df$Mild > pred_ace_delta_df$Moderate)&(pred_ace_delta_df$Mild > pred_ace_delta_df$Severe)){
    Class_ace<-c("Mild")
    PredictionLikelihood_ace<-pred_ace_delta_df$Mild*100
  }

  if((pred_ace_delta_df$Moderate > pred_ace_delta_df$Normal)&(pred_ace_delta_df$Moderate > pred_ace_delta_df$Mild)&(pred_ace_delta_df$Moderate > pred_ace_delta_df$Severe)){
    Class_ace<-c("Moderate")
    PredictionLikelihood_ace<-pred_ace_delta_df$Moderate*100
  }

  if((pred_ace_delta_df$Severe > pred_ace_delta_df$Normal)&(pred_ace_delta_df$Severe > pred_ace_delta_df$Mild)&(pred_ace_delta_df$Severe > pred_ace_delta_df$Moderate)){
    Class_ace<-c("Severe")
    PredictionLikelihood_ace<-pred_ace_delta_df$Severe*100
  }



  output$pred_ace <- renderText({
    paste(c("Student's predicted depression class after mid-terms:"), Class_ace)

  })

  output$pred_ace_conf <- renderText({
    paste(c("Prediction Confidence:", round(PredictionLikelihood_ace, digits = 2), "%"))

  })

  output$delta_ace_pred<-renderUI({
    tagList(
      f7Block(
        f7Shadow(
          intensity = 5,
          hover = TRUE,
          f7Card(
            f7Align(h2("New Prediction"), side=c("center")),
            textOutput("pred_ace"),
            textOutput("pred_ace_conf")
          ))

      ),
      br()
    )
  })







})




}



