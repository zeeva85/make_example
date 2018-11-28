library(tidyverse)

freq_dat <- read.delim("freq_let.tsv")
ggplot(data = freq_dat, aes(
    fill = freq_dat$start_letter/mean(freq_dat$start_letter),
    y = start_letter, x = letters)) + 
    geom_bar( stat = "identity") + 
    labs(fill = "Ratio") + 
    theme(
        axis.text.x = element_text(angle = 45, hjust = 1),
        aspect.ratio = 20/30,
        plot.title = element_text(hjust = 0.5)
    ) + 
    ggtitle("Frequency of begining letters") + 
    ylab("frequency") +
    xlab("letters")

ggsave("freq_let.png")
