-- Set CSV mode and import each file into daily_prices
.mode csv
.import LMT.csv daily_prices --skip 1
.import XOM.csv daily_prices --skip 1
.import DAL.csv daily_prices --skip 1
.import SPY.csv daily_prices --skip 1