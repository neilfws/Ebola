library(rvest)
library(ggplot2)
library(dplyr)

setwd("~/Dropbox/projects/github_projects/ebola")
# get the table of cases
u <- "https://en.wikipedia.org/wiki/West_African_Ebola_virus_epidemic_timeline_of_reported_cases_and_deaths"
cases <- read_html(u) %>% html_nodes("table") %>% .[[2]] %>% html_table(fill = TRUE)

# get rid of the commas; convert to numeric
cases[, 2:9] <- apply(cases[, 2:9], 2, function(x) gsub(",", "", x))
cases[, 2:9] <- apply(cases[, 2:9], 2, as.numeric)

colnames(cases) <- c("date", "cases.total", "deaths.total", "cases.guinea", "deaths.guinea", "cases.liberia", "deaths.liberia", "cases.sierra_leone", "deaths.sierra_leone", "sources")
cases$Date <- as.Date(cases$date, "%d %b %Y")

# gather the cases/deaths into 1 column
cases.1 <- gather(cases, key, value, -Date, -date, -sources)

# then split into country
cases.2 <- separate(cases.1, key, into = c("count", "country"), sep = "\\.")


# are we there yet? quick and dirty attempt to reproduce Wikipedia plots
png("output/ebola.png", 800, 600)
print(ggplot(cases.2, aes(Date, value)) + geom_point(aes(color = count)) + facet_wrap(~ country) + theme_bw() + scale_color_manual(values = c("skyblue3", "darkorange")) + labs(y = "count", title = "Cumulative total Ebola cases"))
dev.off()
