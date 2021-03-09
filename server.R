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
        
        output$plot <- renderPlotly({
            withProgress(message = 'Making plot',
                         detail = 'This may take a while...', value = 0, {
            if(is.null(previous())){return(NULL)}
            p <-data.frame(index =1:length(previous()[[1]]),previous())
            plot_ly(p,x=~index ,y = p[[input$aa2]],type = "scatter",mode = 'markers',marker = list( size = 12))
                         })
        })
        

    

})
