## load packages
library(rtweet)

## install and load ggplot
if (!requireNamespace("ggplot2", quietly = TRUE)) install.packages("ggplot2")
library(ggplot2)

## install gridExtra
if (!requireNamespace("gridExtra", quietly = TRUE)) install.packages("gridExtra")

## table output function
tab_sort <- function (x, n = 10, mentions = FALSE) {
  sumrow <- data.frame(
    "screen_name" = paste(length(unique(x)), "users"),
    "n_tweets" = length(x),
    "prop_tweets" = 1.000,
    stringsAsFactors = FALSE
  )
  x <- sort(table(x), decreasing = TRUE)
  x <- data.frame(
    "screen_name" = names(x),
    "n_tweets" = as.integer(x),
    stringsAsFactors = FALSE
  )
  x$prop_tweets <- x$n_tweets / sum(x$n_tweets, na.rm = TRUE)
  x$prop_tweets <- round(x$prop_tweets, 3)
  x <- head(x, n)
  x <- rbind(x, sumrow)
  row.names(x) <- c(seq_len(nrow(x) - 1L), "total")
  if (mentions) {
    names(x)[2:3] <- c("n_mentions", "prop_mentions")
  }
  x
}

## function for cleaning text and creating word freq table
clean_text_table <- function(data) {
  txt <- tolower(plain_tweets(data$text))
  txt <- gsub("&amp;", "", txt)
  txt <- gsub("#nca17", "", txt, ignore.case = TRUE)
  txt <- unlist(strsplit(txt, " "))
  txt <- gsub("^[[:punct:]]{1,}|[[:punct:]]{1,}$", "", txt)
  txt <- trimws(txt)
  txt <- txt[txt != ""]
  swds <- stopwordslangs$word[stopwordslangs$lang == "en" & stopwordslangs$p > .99]
  txt <- txt[!txt %in% swds]
  sort(table(txt), decreasing = TRUE)
}

## plot the time series of #nca18 activity
format_xdate <- function(x) sub("[ ]{2,}", " ", format(x, "%b %e", tz = "UTC"))
nca %>%
#  mutate(created_at = as.POSIXct(format(created_at, tz = "UTC"), tz = "America/Boise")) %>%
  ts_plot("12 hours", color = "#002222cc", size = 0.8) +
  scale_x_datetime(labels = format_xdate, date_breaks = "2 days") +
  theme_mwk(base_size = 14) +
  labs(x = NULL, y = NULL, title = "Frequency of #NCA18 Twitter statuses in 12-hour intervals",
       subtitle = "Statuses collected via Twitter's standard search endpoint (REST API) using rtweet",
       caption = theme_mwk_caption_text()) +
  geom_point(shape = 21, size = 5, fill = "greenyellow", color = "#002222") +
  ggsave("nca18-ts.png", width = 7.5, height = 5.5, units = "in")

## most frequent tweeters table
usrs <- tab_sort(nca$screen_name)
png("nca18-usrs.png", height = 3.1, width = 4.25, "in", res = 300)
par(bg = "white")
gridExtra::grid.table(usrs, theme = gridExtra::ttheme_default(base_size = 9))
dev.off()

## most frequent mentions table
naomit <- function(x) x[!is.na(x)]
usrs <- tab_sort(naomit(unlist(nca$mentions_screen_name)), mentions = TRUE)
png("nca18-ats.png", height = 3.1, width = 4.25, "in", res = 300)
par(bg = "white")
gridExtra::grid.table(usrs, theme = gridExtra::ttheme_default(base_size = 9))
dev.off()

## create frequency table for popular words
wds <- table(unlist(tokenizers::tokenize_tweets(nca$text,
  stopwords = stopwordslangs$word[stopwordslangs$p > .999])))
minfreq <- quantile(as.double(wds), .9)

png("nca18-wc.png", height = 8, width = 8, "in", res = 300)
par(bg = "black")
wordcloud::wordcloud(
  names(wds),
  as.integer(wds),
  min.freq = minfreq,
  random.color = FALSE,
  random.order = FALSE,
  colors = gg_cols(6)
)
dev.off()

## update git repo (this is from my own utils R package)
tfse::rm_.DS_Store()


