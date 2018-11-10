
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
sids <- rtweet::read_twitter_csv(
  "https://raw.githubusercontent.com/mkearney/NCA18/master/status_id.csv"
)

## lookup full tweets dat
d <- rtweet::lookup_tweets(sids$status_id)
```

Frequency of \#NCA18 tweets:

<p style="align=center">

<img src="nca18-ts.png">

</p>

Most active accounts:

<p style="align=center">

<img src="nca18-usrs.png">

</p>

Most frequently mentioned:

<p style="align=center">

<img src="nca18-ats.png">

</p>

Sentiment (positive/negative) of tweets:

<p style="align=center">

<img src="nca18-sa.png">

</p>

Semantic (quotes, retweets, and mentions) network:

<p style="align=center">

<img src="nca18-network.png">

</p>

Word cloud:

<p style="align=center">

<img src="nca18-wc.png">

</p>
