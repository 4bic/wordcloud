#install
install.packages("tm") #textmining
install.packages("SnowballC") #text stemming
install.packages("wordcloud") #word cloud generator
install.packages("RColorBrewer") #color palettes

#load
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")

#read file
filePath <- "/home/wordcloud/man_in_arena.txt"
text <- readLines(filePath)

#load data
docs <- Corpus(VectorSource(text))

#inspect contents of the document
inspect(docs)

#replace "/, @, |" with space
toSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))

#remove unnecessary whitespaces
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "\\|")
docs <- tm_map(docs, toSpace, "/")

#remove common words(stop words) & TEXTSTEMMING
#convert to lowercase
docs <- tm_map(docs, content_transformer(tolower))

#remove numbers
docs <- tm_map(docs, removeNumbers)

#remove english common stop words
docs <- tm_map(docs, removeWords, stopwords("english"))

#remove own / undesired stopword
docs <- tm_map(docs, removeWords, c("Kenya", "We"))

#remove punctuations
docs <- tm_map(docs, removePunctuation)

#eliminate extra white spaces
docs <- tm_map(docs, stripWhitespace)
 #text stemming
#docs <- tm_map(docs, stemDocument)

#build a term-document matrix

dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m), decreasing = TRUE)
d <- data.frame(word = names(v), freq=v)
head(d, 10)

#generate word cloud
set.seed(1200)
wordcloud(words = d$word, freq = d$freq, min.freq = 1,
          max.words = 200, random.orders=FALSE, rot.per=0.35,
          colors=brewer.pal(9, "RdPu"))










