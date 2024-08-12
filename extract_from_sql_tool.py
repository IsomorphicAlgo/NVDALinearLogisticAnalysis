import pandas as pd
import mysql.connector
import nvda_config

Cpassword = nvda_config.mysql_password

def extract_table_to_csv(table_name, cPassword, server_db):
    # Connect to the local MySQL server
    connection = mysql.connector.connect(
        host='localhost',
        user='root',         
        password=Cpassword,
        database=server_db
    )
    
    # Query to extract table contents
    query = f"SELECT * FROM {table_name}"
    
    # Read the table into a DataFrame
    df = pd.read_sql(query, connection)
    
    # Write the DataFrame to a CSV file
    df.to_csv(f"{table_name}.csv", index=False)
    
    # Close the connection
    connection.close()

# stock_ticks, technical_indicators, stock_prices, nvda_profile, nvda_new, (live_price)
extract_table_to_csv("live_price", Cpassword, "bailish_estate")
