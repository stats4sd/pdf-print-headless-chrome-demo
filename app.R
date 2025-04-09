#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

source('generate_pdf.R')

# Define UI for application that draws a histogram
ui <- fluidPage(

    shinyjs::useShinyjs(),
  
    # Application title
    titlePanel("Test PDF printing"),

      actionButton("generate", "Generate PDF file"),
          
      textOutput("file"),      
    
      shinyjs::hidden(actionButton("reset", "delete file and reset")),
          
      shinyjs::hidden(downloadButton("download", "Download PDF file"))
    
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  
  if(file.exists('test.pdf')) {
    output$file <- renderText('test.pdf ready for download')
  } else {
    output$file <- renderText('no file generated')
  }
    

  
    observe({
        shinyjs::toggleElement(id = 'reset', condition = file.exists('test.pdf'))
        shinyjs::toggleElement(id = 'download', condition = file.exists('test.pdf'))
    })
  
    generatedFile <- observeEvent(input$generate, {
      
      withProgress( 
        message = 'Generating pdf file', 
        detail = 'This may take a while...', 
        value = 0, 
        {
          incProgress(1/5)
          file <- generate_pdf()
          output$file <- renderText('test.pdf ready for download')
          
          shinyjs::toggleElement(id = 'reset', condition = file.exists('test.pdf'))
          shinyjs::toggleElement(id = 'download', condition = file.exists('test.pdf'))    
        })
      
    })
    
    reset <- observeEvent(input$reset, {
      file.remove("test.pdf")
      output$file <- renderText('no file generated')
      shinyjs::toggleElement(id = 'reset', condition = file.exists('test.pdf'))
      shinyjs::toggleElement(id = 'download', condition = file.exists('test.pdf'))  
    })
    
    
    output$download <- downloadHandler(
      filename = function() {
        paste("test", ".pdf", sep = "")
      },
      content = function(file) {
        file.copy("test.pdf", file)
      }
    )
    
    
}

# Run the application 
shinyApp(ui = ui, server = server)
