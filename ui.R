#
# shinysky
# https://github.com/AnalytixWare/ShinySky
# devtools::install_github("AnalytixWare/ShinySky")
#
# example code(shinysky) https://stackoverflow.com/questions/35323980/can-you-use-rs-native-data-editor-to-edit-a-csv-from-within-shiny
# answered by Pork Chop and edited by PeterVermont
#
# example code(fileInput) https://stackoverflow.com/questions/31585191/performing-operations-after-uploading-a-csv-file-in-shiny-r
# answered by NicE
#
# example code(plot by choosing columns) https://stackoverflow.com/questions/52193179/how-to-plot-in-rshiny-depending-on-the-columns-i-choose
# answered by Pork Chop
#
# developed code by Tanaphum Wichaita
# https://github.com/tanaphum


library(shiny)
library(shinydashboard)
library(shinysky)
library(plotly)


# Define UI for application that draws a histogram
shinyUI(dashboardPage(
    dashboardHeader(title = "Upload and Edit CSV"),
    dashboardSidebar(sidebarMenu(id = "tabs",
                                 menuItem("Upload and edit", tabName = "one", icon = icon("dashboard")),
                                 menuItem("plot", tabName = "two", icon = icon("briefcase"))
                                 )
                     
                     ),
    dashboardBody(
        fileInput("datafile", "Choose CSV File",
                  accept = c(
                      "text/csv",
                      "text/comma-separated-values,text/plain",
                      ".csv")
        ),
        tabItems(
            tabItem(tabName = "one",
                        actionButton("reset", "Reset", styleclass = "primary"),
                         hotable("hotable1"),
                         downloadButton('downloadData', 'Download')
                         ),
                 
            tabItem(tabName = "two",
                    uiOutput(outputId = "aa"),
                    textOutput("a"),
                    verbatimTextOutput("summary"),
                    plotlyOutput("plot")
            )
        )
    )
    )
)
