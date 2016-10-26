library(XML)
library(ggplot2)
library(reshape2)

setwd("~/Dropbox/projects/github_projects/ebola")
# get all tables on the page
ebola <- readHTMLTable("http://en.wikipedia.org/wiki/Ebola_virus_epidemic_in_West_Africa", 
                  stringsAsFactors = FALSE)
# thankfully our table has a name; it is table #5
# NOT AS OF 2014-09-26! There are now 2 tables and they are 7, 8.
# NOT AS OF 2014-10-02! There are now 2 tables and they are 8, 9.
ebola.current <- ebola[[5]]
ebola.archive <- ebola[[7]]

# again, manual examination reveals that we want rows 2-end and columns 1-3
ebola.new <- rbind(ebola.current[2:nrow(ebola.current), 1:3], ebola.archive[2:nrow(ebola.archive), 1:3])
colnames(ebola.new) <- c("date", "cases", "deaths")
 
# need to fix up a couple of cases that contain text other than the numbers
#ebola.new$cases[nrow(ebola.new)-43]  <- "759"
#ebola.new$deaths[nrow(ebola.new)-43] <- "467"
 
# get rid of the commas; convert to numeric
ebola.new$cases  <- gsub(",", "", ebola.new$cases)
ebola.new$cases  <- as.numeric(ebola.new$cases)
ebola.new$deaths <- gsub(",", "", ebola.new$deaths)
ebola.new$deaths <- as.numeric(ebola.new$deaths)
 
# the days in the dates are encoded 1-31
# are we there yet? quick and dirty attempt to reproduce Wikipedia plot
ebola.m <- melt(ebola.new)
png("output/ebola.png", 800, 600)
print(ggplot(ebola.m, aes(as.Date(date, "%e %b %Y"), value)) + 
       geom_point(aes(color = variable)) + 
       coord_trans(y = "log10") + xlab("Date") + 
       labs(title = "Cumulative totals log scale") + 
       theme_bw())
dev.off()
