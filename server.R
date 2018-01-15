library(shiny)
library(tau)
library(dplyr)
library(data.table)


function(input, output, session){
  load("env.RData")
  
  filedata <- reactive({
    infile <- input$file1
    intext <- input$textinput
    if (is.null(infile) && intext=="") {
      # User has not uploaded a file yet
      return(NULL)
    }
    else if(intext!="" && is.null(infile)){
      nama = intext
    }
    else if(intext=="" && !is.null(infile)){
      inputcsv <- read.csv(infile$datapath, header = F, stringsAsFactors = F)
      nama = inputcsv$V1
    }
    else {
      inputcsv <- read.csv(infile$datapath, header = F, stringsAsFactors = F)
      inputcsv <- read.csv(file = "nama.txt", header = F, stringsAsFactors = F)
      nama = c(intext, inputcsv$V1)
      # print(data.frame(nama))
    }
    
    allprediction = data.frame(Name=character(), Male_proportion=integer(), Female_proportion=integer())
    for( i in 1:length(nama)){
      r<- textcnt(nama[i], method="ngram", n=4L, tolower = T, split = "[[:space:][:punct:]]+", decreasing=TRUE)
      a<- data.frame(counts = unclass(r), size = nchar(names(r)))
      a<- a %>% add_rownames("gram") %>% filter(size>=3) %>% select(gram)
      temp = allsummarize[which(allsummarize$gram %in% a$gram),]
      b<- data.frame(Name= nama[i], Male_proportion= round(sum(temp$male)/ sum(temp$counts),2), Female_proportion= round(sum(temp$female)/ sum(temp$counts),2))
      allprediction <- data.frame(rbindlist(list(allprediction,b)))
    }
    allprediction$pred <- ifelse(allprediction$Male_proportion>allprediction$Female_proportion, "MALE","FEMALE")
    allprediction
  })
  
  output$text1 <- renderText({ paste(sep = "\n",
   "Note: Input file should",
   "have the following format:",
   "--------------------------",
   "name1",
   "name2",
   "name3",
   "--------------------------",
   "separator between names is",
   "a new line")
  })
  
  output$results <- DT::renderDataTable({
    req(input$textinput)
    dat = filedata()
    names(dat) = c("Name", "Male Confidence", "Female Confidence", "Prediction")
    DT::datatable(filedata(),options = list(pageLength=25, scrollY = T, scrollX = T), rownames = F, escape = FALSE)
  })
  
  output$downloadData <- downloadHandler(
    filename = function() { "rawdata.csv" },
    content = function(file) {
      write.csv(filedata(), file)
    }
  )
  
  
}