
# Shiny Word Cloud App
# Nikhil Singh

library(shiny)
library(tm)
library(memoise)
library(wordcloud)
library(stringr)
library(devtools)
library(twitteR)
library(stringr)
library(httr)
library(rsconnect)

#save(clean_tweet,clean_tweet_pumlatte,clean_tweet_psl, file = "cleantext.rdata")
load("cleantext.rdata")

# Create word cloud ui and server using https://shiny.rstudio.com/gallery/word-cloud.html template
# books <<- list("Starbucks tweets" = "nikhil_clean_tweets", 
#                "Starbucks Pumpkin Spice Latte tweets" = "nikhil_clean_pumlatte", 
#                "Starbucks #psl tweets" = "nikhil_clean_psl")

books = list("Starbucks tweets" = clean_tweet, 
             "Starbucks Pumpkin Spice Latte tweets" = clean_tweet_pumlatte) 
             #"Starbucks #psl tweets" = clean_tweet_psl)

# getTermMatrix <- memoise(function(book) {
#   if (!(book %in% books)) #if not in then stop
#     stop("Unknown book")
# 
#   #text <- readLines(sprintf("./%s.txt", book))
# 
#   # myCorpus = Corpus(VectorSource(text))
#   # myCorpus = tm_map(myCorpus, content_transformer(tolower))
#   # myCorpus = tm_map(myCorpus, removePunctuation)
#   # myCorpus = tm_map(myCorpus, removeNumbers)
#   # myCorpus = tm_map(myCorpus, removeWords,
#   #                   c(stopwords("SMART"), "thy", "thou", "thee", "the", "and", "but"))
#   # myDTM = TermDocumentMatrix(myCorpus,
#   #                            control = list(minWordLength = 1))
#   # m = as.matrix(myDTM)
#   #
#   # sort(rowSums(m), decreasing = TRUE)
# })

getTermMatrix1 = function(book){
  #if (!(book %in% books)) #if not in then stop
  #  stop("Unknown book")
  
  #text <- readLines(sprintf("./%s.txt", book))
  text = books[[book]]
  #print(text)
  myCorpus = Corpus(VectorSource(text))
  myCorpus = tm_map(myCorpus, content_transformer(tolower))
  myCorpus = tm_map(myCorpus, removePunctuation)
  myCorpus = tm_map(myCorpus, removeNumbers)
  myCorpus = tm_map(myCorpus, removeWords,
                    c(stopwords("SMART"), "thy", "thou", "thee", "the", "and", "but"))
  myDTM = TermDocumentMatrix(myCorpus,
                             control = list(minWordLength = 1))
  m = as.matrix(myDTM)
  
  sort(rowSums(m), decreasing = TRUE)
  return(m)
}

#tmp = getTermMatrix1("Starbucks tweets")

ui <- fluidPage( 
  titlePanel("Starbucks Word Cloud"),
  
  sidebarLayout(
    # Sidebar with a slider and selection inputs
    sidebarPanel(
      selectInput("selection", "Choose word(s):",
                  choices = names(books)),
      actionButton("update", "Change"),
      hr(),
      sliderInput("freq",
                  "Minimum Frequency:",
                  min = 1,  max = 50, value = 15),
      sliderInput("max",
                  "Maximum Number of Words:",
                  min = 1,  max = 300,  value = 100)
    ),
    
    # Show Word Cloud
    mainPanel(
      plotOutput("plot")
      # tableOutput("table")
    )
  )
)


server <- function(input, output, session) { 
  # Define a reactive expression for the document term matrix
  terms <- reactive({
    # Change when the "update" button is pressed...
    input$update
    # ...but not for anything else
    isolate({
      withProgress({
        setProgress(message = "Processing corpus...")
        getTermMatrix1(input$selection)
      })
    })
  })
  
  # Make the wordcloud drawing predictable during a session
  wordcloud_rep <- repeatable(wordcloud)
  # output$table <- renderTable({
  #   head(terms())
  # })
  
  output$plot <- renderPlot({
    v <- terms()
    df = data.frame(word = rownames(v), count = rowSums(v))
    wordcloud_rep(df$word, df$count, scale=c(0.5,3),
                  min.freq = input$freq, max.words=input$max,
                  colors=brewer.pal(8, "Dark2"))
  })
}

#Run app
shinyApp(ui = ui, server = server)
