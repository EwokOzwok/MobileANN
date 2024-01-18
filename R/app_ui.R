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
                                                           h4("Generate predictions of a first-year college student's depression after midterms using data collected in the summer (Timepoint 1 & 2)."),
                                                           h4("Select 'Data Inputs' below to view the model inputs"),
                                                           hr(),
                                                           f7Align(h4("Potential use cases:"), side=c("center")),
                                                           f7Align(h4("Enter/Import intake data for a patient & generate predictions for the efficacy of a one or multiple EBTs for a single patient"), side=c("center")),
                                                           f7Align(h4("Enter/Import a patient's progress data & generate updated predictions of likelihood of successful treatment with the current EBT"), side=c("center")),
                                                           f7Align(h4("Enter/Import available predictors & generate categorical or continuous predictions to help guide mission-critical clinical decisions"), side=c("center")),
                                                           br(),
                                                           f7Align(h6("DEVELOPED IN PART UNDER GRANT NUMBER 1H79SP082142-01 FROM THE SUBSTANCE ABUSE AND MENTAL HEALTH SERVICES ADMINISTRATION (SAMHSA) U.S. DEPARTMENT OF HEALTH AND HUMAN SERVICES (HHS)."), side=c("center")),
                                                           hr()
                                                   )
                                   ),
                                   f7AccordionItem(title= "Data Inputs", open=F,
                                                   f7Block(h3("12 Time 1 Variables (July 5th) and 12 Time 2 Variables (August 5th)"),
                                                           hr(),
                                                           h5("Depression"),
                                                           h5("ACES"),
                                                           h5("Gratitude"),
                                                           h5("Self-Compassion"),
                                                           h5("Hope - Agency & Pathways"),
                                                           h5("Self-Esteem")
                                                   )
                                   ),
                       hairlines = F, strong = T, inset =
                         F, tablet = FALSE)))),
              f7Block(
                f7Shadow(
                  intensity = 5,
                  hover = TRUE,
                  f7Card(
                    br(),
                f7Segment(container=c("row"),
                          f7Button(inputId ="helppopup", label = "Quick Intro"),
                          f7Button("ModelLoad", "Display ANN")),
                br())),
                uiOutput("ModelInformation")),

            ),

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
          ),

          f7Tab(
            tabName = "PredictionTab",
            icon = f7Icon("wand_stars_inverse"),
            active = TRUE,
            f7Block(
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

              uiOutput("Predictions"),

                f7Card(title="Neural Network",
                  hr(),
                  br(),
                  f7Segment(container=c("row"),
                            f7Button("ModelPredict", "Predict"),
                            f7Button("Clear", "Clear")),
                  br(),
                  hr(),
                  hairlines = F, strong = T, inset =
                    F, tablet = FALSE))
            ),

          f7Tab(
            tabName = "ChangePred",
            icon = f7Icon("hammer_fill"),
            active = TRUE,
            uiOutput("newmodelpreds"),
            f7Segment(container=c("row"),
                      f7Button("NewPred", "New Prediction"),
                      f7Button("Clear1", "Clear")),
            f7Block(
              f7Shadow(
                intensity = 5,
                hover = TRUE,
                f7Card(
                       f7Accordion(f7Align(h2("View & Change Inputs"), side=c("center")),
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
                       hairlines = F, strong = T, inset =
                         F, tablet = FALSE))
            )),

          f7Tab(
            tabName = "PerspectiveTab",
            icon = f7Icon("perspective"),
            active = TRUE,
            f7Block(
              f7Shadow(
                intensity = 5,
                hover = TRUE,
                f7Card(title = "Perspectives",
                       br(),
                       uiOutput("delta_ace_pred"),
                       f7Segment(container=c("row"),
                                 f7Button("changeace", "New Prediction"),
                                 f7Button("Clear2", "Clear")),
                       br(),
                       f7Align(h3("Change Scores by Standard Deviation"), side=c("center")),
                       fluidRow(
                         column(8, align="center", offset = 0,
                                f7Stepper("changePREaceslider", "Pre ACEs",
                                          value = 0, step = .25, min = -2, max = 2, fill=T, raised = T,
                                          rounded=T, decimalPoint = 2))),
                       br(),
                       fluidRow(
                         column(8, align="center", offset = 0,
                                f7Stepper("changePOSTaceslider", "Post ACEs",
                                          value = 0, step = .25, min = -2, max = 2, fill=T, raised = T,
                                          rounded=T, decimalPoint = 2))),
                       br(),
                       fluidRow(
                         column(8, align="center", offset = 0,
                                f7Stepper("changePREdepslider", "Pre Depression",
                                          value = 0, step = .25, min = -2, max = 2, fill=T, raised = T,
                                          rounded=T, decimalPoint = 2))),
                       br(),
                       fluidRow(
                         column(8, align="center", offset = 0,
                                f7Stepper("changePOSTdepslider", "Post Depression",
                                          value = 0, step = .25, min = -2, max = 2, fill=T, raised = T,
                                          rounded=T, decimalPoint = 2))),


                       br(),
                       hr(),
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
    HTML('<script async src="https://www.googletagmanager.com/gtag/js?id=G-FR41PQ9Y8B"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag(“js”, new Date());

  gtag(“config”, “G-FR41PQ9Y8B”);
</script>'),
    # includeHTML("google-analytics.html"),
    # includeCSS("www/framework7.bundle.min.css")
    HTML('<link rel="stylesheet" type="text/css" href="https://ewokozwok.github.io/MobileANN/www/framework7.bundle.min.css">')

    # favicon(),
    # bundle_resources(
    #   path = app_sys("app/www"),
    #   app_title = "MobileANN"
    # )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
