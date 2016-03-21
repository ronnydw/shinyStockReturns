library(shiny)

shinyUI(fluidPage(

  titlePanel("Shiny Stock Returns"),

  sidebarLayout(

    sidebarPanel(
      a("Yahoo symbol lookup", href = "http://finance.yahoo.com/lookup"),
      fluidRow(
        column(width = 4,
               strong("Ticker symbol    "),
               textInput('symbol', NULL, value = "SBUX", placeholder = NULL)
        ),
        column(width = 4,
               strong("Compare    "),
               textInput('compareSymbol', NULL, value = "", placeholder = NULL)
        ),
        column(width = 4, offset = 0,
               br(),
               actionButton("goButton", "Go!")
        )
      ),
      sliderInput('t', 'Period in months', 6, min = 6, max = 60, step = 3),
      radioButtons("refIndex", label = "Reference index",
                   choices = list("S&P 500 (^GSPC)" = 1, "Eurostoxx 50 (^STOXX50E)" = 2, "none" = 3), 
                   selected = 1)
    ),

    mainPanel(
      plotOutput('capitalGrowth')
    )
  )
))
