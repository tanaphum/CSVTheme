#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
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

library(shiny)
library(shinydashboard)
library(shinysky)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    previous<-reactive({
        if (is.null(input$datafile))
            return(NULL)                
        data<-read.csv(input$datafile$datapath)
        data
    })

        sample_data <- reactive({
            
            if(is.null(input$hotable1)){return(previous())}
            else if(!identical(previous(),input$hotable1))
            {
                sample_data <- as.data.frame(hot.to.df(input$hotable1))
                sample_data
            }
        })
        output$hotable1 <- renderHotable({sample_data()}, readOnly = F)
        output$downloadData <- downloadHandler(filename = function() {paste(Sys.Date(), '- My New Table.csv', sep=' ') }
                                               ,content = function(file) {write.csv(sample_data(), file, row.names = FALSE)})
        
        output$aa <- renderUI({
            ## Since your  output$aa already has name aa you cant use it twice!
            selectInput(inputId = "aa2", #can be any name?
                        label="Select:",
                        choices = colnames(previous()))
        })
        
        mysubsetdata <- eventReactive(input$aa2,{
            previous()[[input$aa2]]
        })
        
        
        output$summary <- renderPrint({
            if(is.null(previous())){return(NULL)}
            summary(mysubsetdata())
        })
        
        output$plot <- renderPlot({
            if(is.null(previous())){return(NULL)}
            plot(mysubsetdata())
        })
        
        output$info <- renderText({
            if(is.null(previous())){return(NULL)}
            paste0("x=", input$plot_click$x, "\ny=", input$plot_click$y)
        })

    

})
