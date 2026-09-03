-- 1. Remove duplicate events
DELETE FROM geopolitical_events 
WHERE rowid NOT IN (
    SELECT MIN(rowid) 
    FROM geopolitical_events 
    GROUP BY event_name, start_date
);

-- 2. Check clean event list
SELECT * FROM geopolitical_events;