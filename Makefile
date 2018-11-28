all: report.html # make complete report

analysis1: report_old.html

analysis2: report2.html

output.png: output.dot
	dot -Tpng < $< > $@
	rm -f output.dot
	
output.dot: Makefile makefile2dot.py
	python makefile2dot.py < $< >$@

clean:
	rm -f words.txt freq_let.tsv freq_let.png report.md report.rmd report.html output.png   
	rm -f words.txt report2.rmd report2.html report2.md freq_let.tsv freq_let.png
	rm -f words.txt histogram.tsv histogram.png report_old.html report_old.md #clean all
	
clean2:
	rm -f words.txt report2.rmd report2.html report2.md freq_let.tsv freq_let.png
	
clean_old:
	rm -f words.txt histogram.tsv histogram.png report_old.html report_old.md

	
report2.html: report2.rmd freq_let.tsv freq_let.png
	Rscript -e 'rmarkdown::render("$<")' # render report old and new
	
report_old.html: report_old.rmd histogram.tsv histogram.png
	Rscript -e 'rmarkdown::render("$<")' # render report old
	
report.html: report.rmd freq_let.tsv freq_let.png histogram.tsv histogram.png
	Rscript -e 'rmarkdown::render("$<")' # render report old and new
	
report2.rmd:
	Rscript -e 'writeLines(readLines(file("reportgen.txt",open="r"), 20), "report2.rmd")'
	
report.rmd:
	Rscript -e 'writeLines(readLines(file("reportgen.txt",open="r"), 37), "report.rmd")' #generated rmd

freq_let.png: freq_plot.R freq_let.tsv
	Rscript $< 
	rm -f Rplots.pdf # make freq_let.png from rscript

histogram.png: histogram.tsv
	Rscript -e 'library(ggplot2); qplot(Length, Freq, data=read.delim("$<")); ggsave("$@")'
	rm Rplots.pdf # make histogram.png by executing r commands using -e (execute) flag read first input "$<" and save in output "$@"
	
freq_let.tsv: freq_let.r words.txt
	Rscript $< # make freq_let.tsv from rscript and words
	
histogram.tsv: histogram.r words.txt
	Rscript $< # make histogram.tsv from rscript and words

words.txt: /usr/share/dict/words
	[ -f "/usr/share/dict/words" ] && cp $< $@ || python download.py #if else statement in shell if file available copy if not use .py script to download 




# words.txt:
#	Rscript -e 'download.file("http://svnweb.freebsd.org/base/head/share/dict/web2?view=co", destfile = "words.txt", quiet = TRUE)' 

#	Rscript -e 'library(ggplot2); ggplot(data=read.delim("$<"), aes(fill = freq_dat$start_letter/sum(freq_dat$start_letter),y = start_letter, x = letters)) + geom_bar( stat = "identity") + labs(fill = "Ratio") + theme(axis.text.x = element_text(angle = 45, hjust = 1), aspect.ratio = 20/30, plot.title = element_text(hjust = 0.5)) + ggtitle("Frequency of begining letters") + ylab("frequency") + xlab("letters"); ggsave("$@")' # ggplot freq_let.png without R script
