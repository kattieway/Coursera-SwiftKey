library(quanteda)

wd <- getwd()

#Uploading files to our working directory

twit <- file(paste(wd, "/Code/source/en_US.twitter.txt", sep = ''), "r")
news <- file(paste(wd, "/Code/source/en_US.news.txt", sep = ''), "r")
blogs <- file(paste(wd, "/Code/source/en_US.blogs.txt", sep = ''), "r")

#Even the files are all in text format the system sees them as "integer" type
#we can fix that using readLines function

twitter_us <- readLines(twit)
news_us <- readLines(news)
blogs_us <- readLines(blogs)

#As we know by doing exploritary analysis the size of files are quite big 
#to run our aplication quick and nice we don`t need to use the whole dataset
#in this example we will take only 5% of each file and unite them in one vector

sample_t <- sample(length(twitter_us), length(twitter_us) * 0.05)
twitter_s <- twitter_us[sample_t]

sample_n <- sample(length(news_us), length(news_us) * 0.05)
news_s <- news_us[sample_n]

sample_b <- sample(length(blogs_us), length(blogs_us) * 0.05)
blogs_s <- blogs_us[sample_b]

all_files <- c(twitter_s, news_s, blogs_s)

#To go futher our vector has to be cahnged to the corpus

my_corp <- corpus(all_files)

#Another importants step before building a prediction app is tolkinize and clean the corpus
#by removing all the punctuation, numbers, symbols, urls and keep in mind that some
#word are used with hyphens and here we use "tokens" function from "quanteda" package 

file_tokens <- tokens(
  x = tolower(my_corp),
  remove_punct = TRUE,
  remove_numbers = TRUE,
  split_hyphens = TRUE,
  remove_symbols = TRUE,
  remove_url = TRUE
)

#We don`t want our app to swear so our next is removing bad words from the corpus
#So I downloaded the text file from google which contains a list of swear words
#The words from the list are also have to be tokenized and cleaned

bad_words <- readLines(paste(wd, "/Code/profanity/badwords.txt", sep = ''))

bad_tokens <- tokens(
  bad_words,
  remove_punct = TRUE,
  remove_separators = TRUE,
  split_hyphens = TRUE
)

#Saving the file for the futher work
saveRDS(bad_tokens,file = paste(wd, "/Code/profanity/profanityTokens.rds", sep = ''))

#The next step is removing bad words from the main file and steming them and saving the new file at the end
#We do steming it because we need to use ours words before any inflectional affixes are added

clean_tokens <- tokens_remove(file_tokens,bad_tokens)
stemed_words <- tokens_wordstem(clean_tokens, language = "english")

saveRDS(stemed_words,file = paste(wd, "/Tokens.rds", sep = ''))

