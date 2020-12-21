

wd <- getwd()

uni_words <- readRDS("uni_words.rds")
bi_words <- readRDS("bi_words.rds")
tri_words <- readRDS("tri_words.rds")


#Now we are going to continue to work with our datatables using setkey function
#It will make our datatabes sorted in ascending order. The sorted columns will become the key. 

uni_words <- setkey(uni_words, word_1)
bi_words <- setkey(bi_words, word_1, word_2)
tri_words <- setkey(tri_words, word_1, word_2, word_3)


#As a next step we will calculate the number of bigrams types and find a probability of words accuring in bigrams
#by dividing number of times the second word becomes the second part of our bigram 
#and after sort them with setkey function

num_bi <- nrow(bi_words[by = .(word_1, word_2),j=FALSE])
prob_bi <- bi_words[, .(Prob = ((.N) / num_bi)), by = word_2]
setkey(prob_bi, word_2)

#As a next step we will assign the probabilities we just calculated to the unigrams
#as second word of bigrams 

uni_words[, Prob := prob_bi[word_1, Prob]]
uni_words <- uni_words[!is.na(uni_words$Prob)]

#As long as we are done with unigrams we have to do the same steps for bigrams
#by looking for the number of times the first word appeared as "word1" in bigrams
#and sort the resuly with setkey function

first_word <- bi_words[, .(N = .N), by = word_1]
setkey(first_word, word_1)

#Now we will add a new colomn to our table and assign it to a total number of "word1" occured in bigram
bi_words[, TotNum := uni_words[word_1, count]]

# Now we are going to set the discount value to work with Kneser–Ney smoothing method
# which is known as a method primarily used to calculate the probability distribution of n-grams
# This approach has been considered equally effective for both higher and lower order n-grams

discount_value <- 0.75
bi_words[, Prob := ((count - discount_value) / TotNum + discount_value / TotNum * first_word[word_1, N] 
                    * uni_words[word_2, Prob])]

#Now we are going to do all the same for the trigrams

second_word <- tri_words[, .N, by = .(word_1, word_2)]
setkey(second_word, word_1, word_2)

tri_words[, TotNum2 := rep(bi_words[.(word_1,word_2),count], length.out=nrow(tri_words))]

tri_words[, Prob := (count - discount_value) / TotNum2 + discount_value / TotNum2 * second_word[.(word_1, word_2), N] *
            rep(bi_words[.(word_1, word_2), Prob], length.out=nrow(tri_words))]

 
#Now we are going to change our table of unigrams and leave most frequently used 50 unigrams
uni_words <- uni_words[order(-Prob)][1:50]

saveRDS(uni_words, file = "ngrams1.rds")
saveRDS(bi_words, file = "ngrams2.rds")
saveRDS(tri_words, file = "ngrams3.rds")

