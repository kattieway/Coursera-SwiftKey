# Take as input any string, and get next words as output
library(quanteda)

uni_words <- readRDS("ngrams1.rds")
bi_words <- readRDS("ngrams2.rds")
tri_words <- readRDS("ngrams3.rds")

#To built a prediction app as a first step we start with a function to return random words from unigrams
unigram_w <- function(n = 5) {  
        return(sample(uni_words[, word_1], size = n))
}
    
#The second function will return previous word based on unigrams

bigram_w <- function(w1, n = 5) {
        prob_words <- bi_words[w1][order(-Prob)]
        if (any(is.na(prob_words)))
                return(unigram_w(n))
        if (nrow(prob_words) > n)
                return(prob_words[1:n, word_2])
        count <- nrow(prob_words)
        uni <- unigram_w(n)[1:(n - count)]
        return(c(prob_words[, word_2], uni))
}

trigram_w <- function(w1, w2, n = 5) {
        prob_words <- tri_words[.(w1, w2)][order(-Prob)]
        if (any(is.na(prob_words)))
                return(bigram_w(w2, n))
        if (nrow(prob_words) > n)
                return(prob_words[1:n, word_3])
        count <- nrow(prob_words)
        bi <- bigram_w(w2, n)[1:(n - count)]
        return(c(prob_words[, word_3], bi))
}



#As all the work above is done we can built a prediction algorythm

predict_word <- function(str, n = 1){

        tokens <- tokens(x = char_tolower(str))
        tokens <- char_wordstem(rev(rev(tokens[[1]])[1:2]), language = "english")
        
        words <- trigram_w(tokens[1], tokens[2], 5)
        chain_1 <- paste(tokens[1], tokens[2], words[1], sep = " ")
        
        print(words[1:n])
}



