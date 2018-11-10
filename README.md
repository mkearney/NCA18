
# \#NCA18 tweets

Collecting data on Twitter statuses containing the \#nca18 hashtag.

## Importing the data

To download the Twitter data, use the following code:

``` r
## install rtweet if not already
if (!requireNamespace("rtweet", quietly = TRUE)) {
  install.packages("rtweet")
}
## read status IDs
sids <- rtweet::read_twitter_csv("status_id.csv")

## lookup full tweets dat
d <- rtweet::lookup_tweets(sids$status_id)
```

### Status frequency

Frequency of NCA tweets.

![](nca18-ts.png)

### Top tweeters

Accounts that have posted the most statuses.

![](nca18-usrs.png)

### Top mentions

Accounts most frequently mentioned.

![](nca18-ats.png)

### Sentiment analysis

Sentiment (positive/negative) of statuses over time.

![](nca18-sa.png)

### Network analysis

Semantic (quotes, retweets, and mentions) network connections.

![](nca18-network.png)

### Word cloud

Most popular words appearing in statuses (stop words excluded).

![](nca18-wc.png)
