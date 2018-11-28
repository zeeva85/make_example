library(tidyverse)
words <- readLines("words.txt")

output <- vector("character", length(letters))
for (i in letters) {                           
    output[match(i, letters)] <- paste0("^", i) 
}


df <- tibble(letters,
             start_letter = seq_along(letters))

for (i in output) {
    df [match(i, output), 2] <- sum(str_count(words, pattern = i))
}

write.table(df, "freq_let.tsv",
            sep = "\t", row.names = FALSE, quote = FALSE)






