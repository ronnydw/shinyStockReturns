library(shiny)
library(mgcv)
library(quantmod)
library(ggplot2)

stockDf <- function(sym, period){
  period <- period + 1
  data <- new.env()
  s <- c(sym)
  getSymbols(s, env = data)
  prices <- get(ls(data)[[1]], envir = data)
  md <- last(prices, paste(period, 'months'))[,6] # Adjusted close
  names(md) <- c('return')
  gdata = data.frame(md)
  gdata$date = as.Date(rownames(gdata))
  gdata$return <- gdata$return / gdata$return[1]
  gdata$return <- (gdata$return - 1) * 100
  gdata$symbol <- sym
  return(gdata)
}

shinyServer(

  function(input, output) {
    
    refData <- reactive({
      input$goButton
      isolate(s <- input$symbol)
      m <- input$t
      dfGSPC <- stockDf('^GSPC', m)
      dfSTOXX50E <- stockDf('^STOXX50E', m)
      if (input$refIndex == 1) return(dfGSPC)
      if (input$refIndex == 2) return(dfSTOXX50E)
      return(NULL)
    })    
       
    output$capitalGrowth <- renderPlot({
         input$goButton
         isolate({
           s <- input$symbol 
           cs <- input$compareSymbol
           })
         m <- input$t
         df <- stockDf(s, m)
         if (cs != "") df <- rbind(df, stockDf(cs, m))
         dfi <- refData()
         if (!is.null(dfi)) df <- rbind(df, dfi)
         g <- ggplot(df, aes(x=date, y=return, col=symbol)) + geom_line() + geom_smooth() + 
              labs(title = "Return in %", colour = "", x = "", y="") +
              theme_bw(base_size = 18) + 
              theme(legend.position =c(1,1.05), legend.direction="horizontal", legend.justification="right")
         g
    })
    
  }
)
