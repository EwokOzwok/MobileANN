#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinyMobile
#' @import tensorflow
#' @import keras
#' @importFrom stats predict
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    shinyMobile::f7Page(
      title = "ANN Predictor",
      options = list(theme=c("auto"), dark=TRUE, preloader = T,  pullToRefresh=TRUE),
      allowPWA=TRUE,
      f7TabLayout(
        # panels are not mandatory. These are similar to sidebars


        navbar = f7Navbar(title= "ANN Depression Predictor"),
        # f7Tabs is a special toolbar with included navigation
        f7Tabs(
          animated = TRUE,
          id = "tab",

          f7Tab(
            tabName = "Hometab",
            icon = f7Icon("house_fill"),
            active = TRUE,
            f7Block(
              f7Shadow(
                intensity = 5,
                hover = TRUE,
                f7Card(f7Accordion(id=NULL,
                                   f7AccordionItem(title = "Brief Description", open=F,
                                                   f7Block(h3("Proof-of-concept app containing a deployed Artifical Neural Network (ANN) model."),
                                                           h4("Generated predicted depression level for a first-year college student after midterms using data collected from July 5th and August 5th. Select 'Data Inputs' below to view the model inputs."),
                                                           hr(),
                                                           f7Align(h4("Use cases:"), side=c("center")),
                                                           f7Align(h4("Enter/Import intake data for a patient & generate predictions for the efficacy of a one or multiple EBTs."), side=c("center")),
                                                           f7Align(h4("Enter/Import patient's progress data & generate updated predictions of likelihood of treatment success"), side=c("center")),
                                                           f7Align(h4("Enter/Import available predictors & generate categorical or continuous predictions to help guide mission-critical clinical decisions"), side=c("center")),
                                                           br(),
                                                           f7Align(h6("DEVELOPED IN PART UNDER GRANT NUMBER 1H79SP082142-01 FROM THE SUBSTANCE ABUSE AND MENTAL HEALTH SERVICES ADMINISTRATION (SAMHSA) U.S. DEPARTMENT OF HEALTH AND HUMAN SERVICES (HHS)."), side=c("center")),
                                                           hr()
                                                   )
                                   ),
                                   f7AccordionItem(title= "Data Inputs", open=F,
                                                   f7Block(h3("The 24 variables used as inputs are listed below:"),
                                                           hr(),
                                                           h5("Depression (Time 1 & Time 2)"),
                                                           h5("Adverse Childhood Experiences (Time 1 & Time 2)"),
                                                           h5("Gratitude (Time 1 & Time 2)"),
                                                           h5("Self-Judgment (Time 1 & Time 2)"),
                                                           h5("Over-identifying with pain (Time 1 & Time 2)"),
                                                           h5("Isolation (Time 1 & Time 2)"),
                                                           h5("Self-Kindness (Time 1 & Time 2)"),
                                                           h5("Mindfulness (Time 1 & Time 2)"),
                                                           h5("Common Humanity (Time 1 & Time 2)"),
                                                           h5("Agency (Time 1 & Time 2)"),
                                                           h5("Pathways to success (Time 1 & Time 2)"),
                                                           h5("Self-Esteem (Time 1 & Time 2)")
                                                   )
                                   ),
                       hairlines = F, strong = T, inset =
                         F, tablet = FALSE), footer=f7Button(inputId ="helppopup", label = "Quick Introduction", color= "darkorchid3", fill=T, shadow=T, rounded = T, size = "small"),
)
          ))
          ),



          f7Tab(
            tabName = "PredictionTab",
            icon = f7Icon("wand_stars_inverse"),
            active = TRUE,
            f7Block(uiOutput("ModelInformation"),
              f7Shadow(
                intensity = 5,
                hover = TRUE,

                f7Card(title= "Upload student data",
                  shinyMobile::f7File("file1", "Upload the .csv",
                                      multiple = TRUE,
                                      accept = c("text/csv",
                                                 "text/comma-separated-values,text/plain",
                                                 ".csv")),
                  hairlines = F, strong = T, inset =
                    F, tablet = FALSE)),

                f7Card(title="Neural Network",
                  hr(),
                  br(),
                  f7Segment(container=c("row"),
                            f7Button("ModelLoad", "Display"),
                            f7Button("ModelPredict", "Predict"),
                            f7Button("Clear", "Clear")),
                  br(),
                  hr(),
                  hairlines = F, strong = T, inset =
                    F, tablet = FALSE),

               uiOutput("Predictions")
                ),

            f7Block(
              f7Shadow(
                intensity = 5,
                hover = TRUE,
                f7Card(title= "View & Change Inputs",
                       f7Accordion(
                         f7AccordionItem(title="Time 1 Inputs",
                                         f7Block(
                                         f7Stepper("DEP1", "Depression Score: Time 1", value= NULL, min=0, max=42, step=1, size="small"),
                                         hr(),
                                         f7Stepper("PEARLS1", "PEARLS Score: Time 1", value=NULL, min=0, max=17, step=1, size="small"),
                                         hr(),
                                         f7Stepper("GQmean1", "Gratitude Score: Time 1", value=NULL, min=1, max=7, step=1, size="small"),
                                         hr(),
                                         f7Stepper("SJ1", "Self-Judgment Score: Time 1", value=NULL, min=2, max=10, step=1, size="small"),
                                         hr(),
                                         f7Stepper("OI1", "Over-Identification Score: Time 1", value=NULL, min=2, max=10, step=1, size="small"),
                                         hr(),
                                         f7Stepper("I1", "Isolation Score: Time 1", value=NULL, min=2, max=10, step=1, size="small"),
                                         hr(),
                                         f7Stepper("SK1", "Self-Kindness Score: Time 1", value=NULL, min=2, max=10, step=1, size="small"),
                                         hr(),
                                         f7Stepper("M1", "Mindfulness Score: Time 1", value=NULL, min=2, max=10, step=1, size="small"),
                                         hr(),
                                         f7Stepper("CH1", "Common Humanity Score: Time 1", value=NULL, min=2, max=10, step=1, size="small"),
                                         hr(),
                                         f7Stepper("AHSa1", "Agency Score: Time 1", value=NULL, min=4, max=32, step=1, size="small"),
                                         hr(),
                                         f7Stepper("AHSp1", "Pathways Score: Time 1", value=NULL, min=4, max=32, step=1, size="small"),
                                         hr(),
                                         f7Stepper("RSE1", "Self-Esteem Score: Time 1", value=NULL, min=10, max=40, step=1, size="small"),
                                         hr())),
                         f7AccordionItem(title="Time 2 Inputs",
                                         f7Block(
                                           f7Stepper("DEP2", "Depression: Time 2", value=NULL, min=0, max=42, step=1, size="small"),
                                           hr(),
                                           f7Stepper("PEARLS2", "PEARLS Score: Time 2", value=NULL, min=0, max=17, step=1, size="small"),
                                           hr(),
                                           f7Stepper("GQmean2", "Gratitude Score: Time 2", value=NULL, min=1, max=7, step=1, size="small"),
                                           hr(),
                                           f7Stepper("SJ2", "Self-Judgment Score: Time 2", value=NULL, min=2, max=10, step=1, size="small"),
                                           hr(),
                                           f7Stepper("OI2", "Over-Identification Score: Time 2", value=NULL, min=2, max=10, step=1, size="small"),
                                           hr(),
                                           f7Stepper("I2", "Isolation Score: Time 2", value=NULL, min=2, max=10, step=1, size="small"),
                                           hr(),
                                           f7Stepper("SK2", "Self-Kindness Score: Time 2", value=NULL, min=2, max=10, step=1, size="small"),
                                           hr(),
                                           f7Stepper("M2", "Mindfulness Score: Time 2", value=NULL, min=2, max=10, step=1, size="small"),
                                           hr(),
                                           f7Stepper("CH2", "Common Humanity Score: Time 2", value=NULL, min=2, max=10, step=1, size="small"),
                                           hr(),
                                           f7Stepper("AHSa2", "Agency Score: Time 2", value=NULL, min=4, max=32, step=1, size="small"),
                                           hr(),
                                           f7Stepper("AHSp2", "Pathways Score: Time 2", value=NULL, min=4, max=32, step=1, size="small"),
                                           hr(),
                                           f7Stepper("RSE2", "Self-Esteem Score: Time 2", value=NULL, min=10, max=40, step=1, size="small"),
                                           hr()))),
                       br(),
                       br(),
                       textOutput("pred11"),
                       textOutput("pred22"),
                       hairlines = F, strong = T, inset =
                         F, tablet = FALSE)),
                f7Button("NewPred", "Generate New Prediction"),

                )),

          f7Tab(
            tabName = "Downloadtab",
            icon = f7Icon("cloud_download"),
            active = TRUE,
            f7Block(
              f7Shadow(
                intensity = 5,
                hover = TRUE,
                f7Card(title = "Download Example Data",
                       br(),
                       f7Segment(container=c("row"),
                                 f7DownloadButton("downloadnormal","Normal"),
                                 f7DownloadButton("downloadmild","Mild")),
                       br(),
                       br(),
                       f7Segment(container=c("row"),
                                 f7DownloadButton("downloadmoderate","Moderate"),
                                 f7DownloadButton("downloadsevere","Severe")),
                       br(),
                       hairlines = F, strong = T, inset =
                         F, tablet = FALSE))
        )
      )

)
)
)
)
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  # add_resource_path(
  #   "www",
  #   app_sys("app/www")
  # )

  tags$head(
    includeCSS("www/framework7.bundle.min.css")
    # favicon(),
    # bundle_resources(
    #   path = app_sys("app/www"),
    #   app_title = "MobileANN"
    # )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
