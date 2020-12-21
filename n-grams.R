
library(data.table)
library(quanteda)

wd <- getwd()
stemed_words <- readRDS("Tokens.rds")

# From now on we can create bigramd and trigrams using "quatenda" package functions
bi_gram <- tokens_ngrams(stemed_words, n = 2)
tri_gram <- tokens_ngrams(stemed_words, n = 3)

#After creating bigrams and trigrams we are going to built frequency matrixes for unigram, bigram and trigram
#And we will remove all the stopwords (stopwords are frequently used words we use, 
#they could be articles, particles etc) and we don`t need them in the prediction app
#and as long as we want our app to work faster we will reduce matrixes with trim function

uni_dfm <- dfm(stemed_words,remove = stopwords("english"))
uni_dfm <- dfm_trim(uni_dfm, 3)

bi_dfm <- dfm(bi_gram, remove = stopwords("english"))
bi_dfm <- dfm_trim(bi_dfm, 3)

tri_dfm <- dfm(tri_gram,remove = stopwords("english"))
tri_dfm <- dfm_trim(tri_dfm, 3)

#As a next step we will create 3 vectors: 1 for each of our n-gramsto later on use it 
#as a new colomn where we going to see the sums of the each counted word

sum_uni <- colSums(uni_dfm)
uni_words <- data.table(word_1 = names(sum_uni), count = sum_uni)


sum_bi <- colSums(bi_dfm)
bi_words <- data.table(
  word_1 = sapply(strsplit(names(sum_bi), "_", fixed = TRUE), '[[', 1),
  word_2 = sapply(strsplit(names(sum_bi), "_", fixed = TRUE), '[[', 2),
  count = sum_bi)

sum_tri <- colSums(tri_dfm)
tri_words <- data.table(
  word_1 = sapply(strsplit(names(sum_tri), "_", fixed = TRUE), '[[', 1),
  word_2 = sapply(strsplit(names(sum_tri), "_", fixed = TRUE), '[[', 2),
  word_3 = sapply(strsplit(names(sum_tri), "_", fixed = TRUE), '[[', 3),
  count = sum_tri)

#Saving all datatables

saveRDS(uni_words,file = paste(wd, "/uni_words.rds", sep = ''))
saveRDS(bi_words,file = paste(wd, "/bi_words.rds", sep = ''))
saveRDS(tri_words,file = paste(wd, "/tri_words.rds", sep = ''))
