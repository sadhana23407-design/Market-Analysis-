WITH HistoricalImpact AS (
    SELECT 
        a.ticker,
        a.asset_name,
        ROUND(AVG((p5.close_price - p0.close_price) / p0.close_price * 100), 2) AS avg_5d_return,
        ROUND(AVG(((p5.close_price - p0.close_price) / p0.close_price * 100) - 
            ((spy5.close_price - spy0.close_price) / spy0.close_price * 100)), 2) AS avg_abnormal_return
    FROM assets a
    CROSS JOIN geopolitical_events e
    -- Get asset prices
    JOIN daily_prices p0 ON p0.asset_id = a.asset_id AND p0.trade_date = e.start_date
    LEFT JOIN daily_prices p5 ON p5.asset_id = a.asset_id 
        AND p5.trade_date = (
            SELECT MIN(trade_date) FROM daily_prices 
            WHERE asset_id = a.asset_id AND trade_date >= DATE(e.start_date, '+5 days')
        )
    -- Get SPY market benchmark prices
    JOIN assets spy_a ON spy_a.ticker = 'SPY'
    JOIN daily_prices spy0 ON spy0.asset_id = spy_a.asset_id AND spy0.trade_date = e.start_date
    LEFT JOIN daily_prices spy5 ON spy5.asset_id = spy_a.asset_id 
        AND spy5.trade_date = (
            SELECT MIN(trade_date) FROM daily_prices 
            WHERE asset_id = spy_a.asset_id AND trade_date >= DATE(e.start_date, '+5 days')
        )
    WHERE a.ticker != 'SPY'
    GROUP BY a.ticker, a.asset_name
)
SELECT 
    ticker,
    asset_name,
    avg_5d_return || '%' AS historical_avg_return,
    avg_abnormal_return || '%' AS historical_avg_abnormal_return,
    CASE 
        WHEN avg_abnormal_return > 3.0 THEN 'HIGH BULLISH (Defense Hedge)'
        WHEN avg_abnormal_return BETWEEN 0.0 AND 3.0 THEN 'MODERATE BULLISH (Energy Hedge)'
        WHEN avg_abnormal_return < 0.0 THEN 'BEARISH / VULNERABLE (High Costs)'
    END AS predicted_event_impact
FROM HistoricalImpact
ORDER BY avg_abnormal_return DESC;