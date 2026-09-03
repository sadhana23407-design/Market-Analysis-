-- 1. SECTORS & ASSETS
CREATE TABLE IF NOT EXISTS assets (
    asset_id INTEGER PRIMARY KEY AUTOINCREMENT,
    ticker TEXT UNIQUE NOT NULL,
    asset_name TEXT NOT NULL,
    sector_name TEXT NOT NULL
);

-- 2. GEOPOLITICAL EVENTS
CREATE TABLE IF NOT EXISTS geopolitical_events (
    event_id INTEGER PRIMARY KEY AUTOINCREMENT,
    event_name TEXT NOT NULL,
    region TEXT NOT NULL,
    start_date DATE NOT NULL
);

-- 3. DAILY PRICES
CREATE TABLE IF NOT EXISTS daily_prices (
    price_id INTEGER PRIMARY KEY AUTOINCREMENT,
    asset_id INTEGER NOT NULL,
    trade_date DATE NOT NULL,
    close_price REAL NOT NULL,
    FOREIGN KEY (asset_id) REFERENCES assets(asset_id),
    UNIQUE(asset_id, trade_date)
);

-- SEED ASSETS
INSERT OR IGNORE INTO assets (ticker, asset_name, sector_name) VALUES 
    ('LMT', 'Lockheed Martin', 'Defense'),
    ('XOM', 'ExxonMobil', 'Energy'),
    ('DAL', 'Delta Air Lines', 'Transportation'),
    ('SPY', 'S&P 500 ETF', 'Market Benchmark');

-- SEED MULTI-ERA EVENTS
INSERT OR IGNORE INTO geopolitical_events (event_name, region, start_date) VALUES 
    ('Iraq War Outbreak', 'Middle East', '2003-03-20'),
    ('Crimea Annexation', 'Eastern Europe', '2014-02-20'),
    ('Russia-Ukraine Conflict', 'Eastern Europe', '2022-02-24'),
    ('Israel-Gaza Conflict', 'Middle East', '2023-10-07'),
    ('Red Sea Shipping Crisis', 'Middle East/Global Trade', '2023-12-15');