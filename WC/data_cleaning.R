library(shiny)
library(tm)
library(memoise)
library(wordcloud)
library(stringr)
library(devtools)
library(twitteR)
library(stringr)
library(httr)

api_key <- 	"j8AFNBsPFmuJyR2WrtPoPeWPr"
api_secret <- "CbwhBhGZumtpOKRutoXeQ9Vr1ZI9iPUmUW00i09xZ0gAC0Q6ew"
access_token <- "1164916388-8nfnf0oYBCSrnZCJzul73OU3m5sLJBDPqU66jPi"
access_token_secret <- "xDxx03Yf71wsUwQfHo0SEdcy4RmTdvYhDhAsiq4I2usDE"

setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)

#Data Cleaning
tweets.star <- searchTwitter("@Starbucks", n=5000, lang="en", since="2017-01-01")
tweets <- twListToDF(tweets.star)

tweets.star <- twListToDF(tweets.star)

tweets.pumlatte <- tweets.star[grep("pumpkin spice latte OR #psl", tweets.star$text),]
#tweets.psl <- tweets.star[grep("#psl", tweets.star$text),]

clean_tweet = gsub("&amp", "", tweets$text)
#Get rid of these characters
clean_tweet = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", clean_tweet)
#Get rid of these characters
clean_tweet = gsub("@\\w+", "", clean_tweet)
#Get rid of punctuation
clean_tweet = gsub("[[:punct:]]", "", clean_tweet)
#Get rid of numbers/digits
clean_tweet = gsub("[[:digit:]]", "", clean_tweet)
#Get rid of url
clean_tweet = gsub("http\\w+", "", clean_tweet)
#Get rid of remaining other characters
clean_tweet = gsub("[ \t]{2,}", "", clean_tweet)
clean_tweet = gsub("^\\s+|\\s+$", "", clean_tweet) 

# Get rid of unnecessary spaces
clean_tweet <- str_replace_all(clean_tweet," "," ")
# Get rid of URLs
#clean_tweet <- str_replace_all(clean_tweet, "http://t.co/[a-z,A-Z,0-9]*{8}","")
# Take out retweet header, there is only one
clean_tweet <- str_replace(clean_tweet,"RT @[a-z,A-Z]*: ","")
# Get rid of hashtags
clean_tweet <- str_replace_all(clean_tweet,"#[a-z,A-Z]*","")
# Get rid of references to other screennames
clean_tweet <- str_replace_all(clean_tweet,"@[a-z,A-Z]*","") 
#Change to lowercase
clean_tweet <- tolower(clean_tweet)


clean_tweet_pumlatte = gsub("&amp", "", tweets.pumlatte$text) 
#Get rid of these characters
clean_tweet_pumlatte = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", clean_tweet_pumlatte)
#Get rid of these characters
clean_tweet_pumlatte = gsub("@\\w+", "", clean_tweet_pumlatte)
#Get rid of punctuation
clean_tweet_pumlatte = gsub("[[:punct:]]", "", clean_tweet_pumlatte)
#Get rid of numbers/digits
clean_tweet_pumlatte = gsub("[[:digit:]]", "", clean_tweet_pumlatte)
#Get rid of url
clean_tweet_pumlatte = gsub("http\\w+", "", clean_tweet_pumlatte)
#Get rid of remaining other characters
clean_tweet_pumlatte = gsub("[ \t]{2,}", "", clean_tweet_pumlatte)
clean_tweet_pumlatte = gsub("^\\s+|\\s+$", "", clean_tweet_pumlatte) 

# Get rid of unnecessary spaces
clean_tweet_pumlatte <- str_replace_all(clean_tweet_pumlatte," "," ")
# Get rid of URLs
#clean_tweet_pumlatte <- str_replace_all(clean_tweet_pumlatte, "http://t.co/[a-z,A-Z,0-9]*{8}","")
# Take out retweet header, there is only one
clean_tweet_pumlatte <- str_replace(clean_tweet_pumlatte,"RT @[a-z,A-Z]*: ","")
# Get rid of hashtags
clean_tweet_pumlatte <- str_replace_all(clean_tweet_pumlatte,"#[a-z,A-Z]*","")
# Get rid of references to other screennames
clean_tweet_pumlatte <- str_replace_all(clean_tweet_pumlatte,"@[a-z,A-Z]*","") 
#Change to lowercase
clean_tweet_pumlatte <- tolower(clean_tweet_pumlatte)

# clean_tweet_psl = gsub("&amp", "", tweets.psl$text) 
# #Get rid of these characters
# clean_tweet_psl = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", clean_tweet_psl)
# #Get rid of these characters
# clean_tweet_psl = gsub("@\\w+", "", clean_tweet_psl)
# #Get rid of punctuation
# clean_tweet_psl = gsub("[[:punct:]]", "", clean_tweet_psl)
# #Get rid of numbers/digits
# clean_tweet_psl = gsub("[[:digit:]]", "", clean_tweet_psl)
# #Get rid of url
# clean_tweet_psl = gsub("http\\w+", "", clean_tweet_psl)
# #Get rid of remaining other characters
# clean_tweet_psl = gsub("[ \t]{2,}", "", clean_tweet_psl)
# clean_tweet_psl = gsub("^\\s+|\\s+$", "", clean_tweet_psl) 
# 
# # Get rid of unnecessary spaces
# clean_tweet_psl <- str_replace_all(clean_tweet_psl," "," ")
# # Get rid of URLs
# clean_tweet_psl <- str_replace_all(clean_tweet_psl, "http://t.co/[a-z,A-Z,0-9]*{8}","")
# # Take out retweet header, there is only one
# clean_tweet_psl <- str_replace(clean_tweet_psl,"RT @[a-z,A-Z]*: ","")
# # Get rid of hashtags
# clean_tweet_psl <- str_replace_all(clean_tweet_psl,"#[a-z,A-Z]*","")
# # Get rid of references to other screennames
# clean_tweet_psl <- str_replace_all(clean_tweet_psl,"@[a-z,A-Z]*","") 
# #Change to lowercase
# clean_tweet_psl <- tolower(clean_tweet_psl)
