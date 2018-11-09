
## Estimate pos/neg sentiment for each tweet
nca$sentiment <- syuzhet::get_sentiment(
  textfeatures:::text_cleaner(nca$text), "afinn")

## Function to parse time intervals
time_intervals <- function(x) {
  stopifnot(is.atomic(x) && length(x) == 1L)
  if (is.numeric(x)) {
    return(x)
  }
  x <- tolower(x)
  if (grepl("year", x)) {
    n <- 60 * 60 * 24 * 365
  } else if (grepl("quarter", x)) {
    n <- 365 / 4
  } else if (grepl("month", x)) {
    n <- 60 * 60 * 24 * 30
  } else if (grepl("week", x)) {
    n <- 60 * 60 * 24 * 7
  } else if (grepl("day", x)) {
    n <- 60 * 60 * 24
  } else if (grepl("hour", x)) {
    n <- 60 * 60
  } else if (grepl("min", x)) {
    n <- 60
  } else if (grepl("sec", x)) {
    n <- 1
  } else {
    stop("interval must be secs, mins, hours, days, weeks, months, or years",
         call. = FALSE)
  }
  x <- as.double(gsub("[^[:digit:]|\\.]", "", x))
  if (any(is.na(x), identical(x, ""))) {
    x <- 1
  }
  n * x
}

## create and save plot
nca %>%
  filter(created_at > "2018-11-05") %>%
  mutate(time = round_time(created_at, "2 hours")) %>%
  group_by(time) %>%
  summarise(sentiment = mean(sentiment, na.rm = TRUE)) %>%
  mutate(valence = ifelse(sentiment > 0L, "Positive", "Negative")) %>%
  ggplot(aes(x = time, y = sentiment)) +
  geom_smooth(method = "loess", span = .3, colour = "#aa11aadd", fill = "#bbbbbb11") +
  #geom_bar(aes(fill = valence), alpha = .7, stat = "identity", width = 1250) +
  geom_point(aes(colour = valence), alpha = .9, size = 2.5) +
  theme_mwk(base_size = 14) +
  theme(legend.position = "none") +
  scale_fill_manual(values = c(Positive = "#2244ee", Negative = "#dd2222")) +
  scale_colour_manual(values = c(Positive = "#0022cc", Negative = "#bb0000")) +
  labs(x = NULL, y = NULL,
       title = "Sentiment of #NCA18 tweets by hour",
       subtitle = "Mean positive/negative sentiment scores of tweets") +
  ggsave("../nca18-sa.png", width = 8, height = 7, units = "in")
