import urllib.request
import json
import csv
from datetime import datetime

tickers = {'LMT': 1, 'XOM': 2, 'DAL': 3, 'SPY': 4}
headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'}

for ticker, asset_id in tickers.items():
    url = f"https://query1.finance.yahoo.com/v8/finance/chart/{ticker}?period1=1630627200&period2=1788393600&interval=1d"
    req = urllib.request.Request(url, headers=headers)
    
    try:
        with urllib.request.urlopen(req) as response:
            data = json.loads(response.read().decode())
            
        result = data['chart']['result'][0]
        timestamps = result['timestamp']
        closes = result['indicators']['quote'][0]['close']
        
        with open(f"{ticker}.csv", "w", newline="") as f:
            writer = csv.writer(f)
            writer.writerow(["asset_id", "trade_date", "close_price"])
            for ts, close in zip(timestamps, closes):
                if close is not None:
                    date_str = datetime.fromtimestamp(ts).strftime('%Y-%m-%d')
                    writer.writerow([asset_id, date_str, round(close, 2)])
                    
        print(f"Successfully generated {ticker}.csv")
    except Exception as e:
        print(f"Error downloading {ticker}: {e}")