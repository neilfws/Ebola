library(XML)
library(ggplot2)
library(reshape2)
 
# get all tables on the page
ebola <- readHTMLTable("http://en.wikipedia.org/wiki/Ebola_virus_epidemic_in_West_Africa", 
                  stringsAsFactors = FALSE)
# thankfully our table has a name; it is table #5
# this is not something you can really automate
head(names(ebola))
# [1] "Ebola virus epidemic in West Africa"          
# [2] "Nigeria Ebola areas-2014"                     
# [3] "Treatment facilities in West Africa"          
# [4] "Democratic Republic of Congo-2014"            
# [5] "Ebola cases and deaths by country and by date"
# [6] "NULL"
 
ebola <- ebola$`Ebola cases and deaths by country and by date`
 
# again, manual examination reveals that we want rows 2-end and columns 1-3
ebola.new <- ebola[2:nrow(ebola), 1:3]
colnames(ebola.new) <- c("date", "cases", "deaths")
 
# need to fix up a couple of cases that contain text other than the numbers
ebola.new$cases[nrow(ebola.new)-43]  <- "759"
ebola.new$deaths[nrow(ebola.new)-43] <- "467"
 
# get rid of the commas; convert to numeric
ebola.new$cases  <- gsub(",", "", ebola.new$cases)
ebola.new$cases  <- as.numeric(ebola.new$cases)
ebola.new$deaths <- gsub(",", "", ebola.new$deaths)
ebola.new$deaths <- as.numeric(ebola.new$deaths)
 
# the days in the dates are encoded 1-31
# are we there yet? quick and dirty attempt to reproduce Wikipedia plot
ebola.m <- melt(ebola.new)
png("ebola.png", 800, 600)
print(ggplot(ebola.m, aes(as.Date(date, "%e %b %Y"), value)) + 
       geom_point(aes(color = variable)) + 
       coord_trans(y = "log10") + xlab("Date") + 
       labs(title = "Cumulative totals log scale") + 
       theme_bw())
dev.off()
