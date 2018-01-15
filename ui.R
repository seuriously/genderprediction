library(shiny)
library(rsconnect)
library(shinydashboard)

rsconnect::setAccountInfo(name='seuriously', token='DC900D5D4906D31ED595C388681A695D', secret='SucQj3x2d3A1kpqHfPgleZ+rn1WI053MHKPyJHzH')

dashboardPage(
  
  skin="black",

  dashboardHeader(
    title = h4("Indonesian Gender Prediction by Names")
    
  ),
  
  
  dashboardSidebar(
    sidebarMenu(
      verbatimTextOutput("text1"),
      fileInput('file1', 'Upload .csv File',
              accept=c('text/csv', 
                       'text/comma-separated-values,text/plain', 
                       '.csv'))
      
    ),
    p("copyright: 2016"),
    p("e: seuriously@gmail.com"),
    tags$head(tags$style(HTML('
      p {
        margin: 0px 14px 0px;
      }
      h4 {
        font-size: 20px;
        margin-top: 3px;
        font-weight: 700;
      }'
    )))
  ),
  
  dashboardBody(
    tags$head(tags$style(HTML('
      .form-control.shiny-bound-input{
        height: 50px;
        font-size: 24px;
        border: 3px solid #ccc;
      }

    '))),
    
    fluidRow(
      box(
        status = "primary",
        width = 12,
        textInput("textinput", placeholder = "Insert Name in Here. For Example 'Ghilman'", label = NULL),
        br(),
        downloadButton('downloadData', 'Download Data'),
        br(),
        br(),
        DT::dataTableOutput("results")
      )
    )
  )
)
