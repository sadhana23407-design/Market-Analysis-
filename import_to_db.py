import csv
import sqlite3

conn = sqlite3.connect("database.db")
cursor = conn.cursor()

files = ["LMT.csv", "XOM.csv", "DAL.csv", "SPY.csv"]

for file_name in files:
    with open(file_name, "r") as f:
        reader = csv.reader(f)
        next(reader)  # Skip CSV header row
        
        # Explicitly maps 3 CSV columns to the matching database fields
        cursor.executemany(
            """
            INSERT OR IGNORE INTO daily_prices (asset_id, trade_date, close_price)
            VALUES (?, ?, ?)
            """,
            reader
        )

conn.commit()
conn.close()
print("Successfully imported all price records into database.db!")