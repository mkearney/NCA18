## load packages
library(mwk)
library(rtweet)

## read data
nca <- readRDS("data/nca18.rds")

## search for NCA tweets
nca_new <- search_tweets(
  "nca18 OR nca2018 OR natcomm OR \"national communication association\"",
  n = 45000,
  token = bearer_token(),
  since_id = since_id(nca)
)

## merge data
nca <- bind_rows(nca_new, nca)
nca <- filter(nca, !duplicated(status_id))

## save dat
saveRDS(nca, "data/nca18.rds")

