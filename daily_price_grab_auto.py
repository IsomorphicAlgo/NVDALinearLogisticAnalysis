import requests
import pandas as pd
import json
import mysql.connector
from datetime import datetime, timedelta, timezone
import time
import nvda_config
import twelvedata as td
from twelvedata import TDClient

# set up login
Cpassword = nvda_config.mysql_password
td = TDClient(apikey=nvda_config.twelve_api_nvda) 
base_url = 'https://api.twelvedata.com'

# Establish MySQL object
mydb = mysql.connector.connect(
    host="localhost",   
    user="root",         
    password=Cpassword,  
    database="bailish_estate"   
)

mycursor = mydb.cursor()

# Twelve Data API parameters
symbol = ["NVDA", "SPX", "XAU/USD", "SPCE", "ABAT", "BB", "GME", "GRRR", "MAXN", "TOMZ", "GOOG", "APLL"]
interval = "1min"
outputsize = 5000 


request_count = 0
while request_count < 1:
        for sym in symbol:
                price_pdf = td.price(
                symbol=sym
                ).as_json()
                timestamp = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M:%S")  # Current timestamp
                
                price_df = pd.DataFrame(price_pdf, index=["price"])

                data_to_insert = [(sym, timestamp, price_df["price"].values[0])]
                # Insert tick data into MySQL
                sql_time_series = """
                INSERT INTO live_price (symbol, datetime, price)
                VALUES (%s, %s, %s)
                """
                mycursor.executemany(sql_time_series, data_to_insert)
                mydb.commit()

                # Increment the request counter
        request_count += 1
        print("Requests elapsed: ", request_count, " at time:", datetime.now())
        # Sleep for a short period before fetching the next data
        time.sleep(59.75) # Adjust the sleep time as needed

        print("Program completed after 390 requests.")
