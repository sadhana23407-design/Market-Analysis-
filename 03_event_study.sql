WITH EventPrices AS (
    SELECT DISTINCT
        e.event_id,
        e.event_name,
        e.start_date AS event_date,
        a.ticker,
        p0.close_price AS price_t0,
        p5.close_price AS price_t5,
        ROUND(((p5.close_price - p0.close_price) / p0.close_price) * 100, 2) AS pct_change_5d
    FROM geopolitical_events e
    CROSS JOIN assets a
    JOIN daily_prices p0 ON p0.asset_id = a.asset_id AND p0.trade_date = e.start_date
    LEFT JOIN daily_prices p5 ON p5.asset_id = a.asset_id 
        AND p5.trade_date = (
            SELECT MIN(trade_date) 
            FROM daily_prices 
            WHERE asset_id = a.asset_id AND trade_date >= DATE(e.start_date, '+5 days')
        )
)
SELECT DISTINCT
    event_name,
    event_date,
    ticker,
    price_t0,
    price_t5,
    pct_change_5d || '%' AS return_5d
FROM EventPrices
ORDER BY event_date ASC, ticker ASC;