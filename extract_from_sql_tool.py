import pandas as pd
import mysql.connector
import nvda_config

Cpassword = nvda_config.mysql_password

def extract_table_to_csv(table_name, cPassword):
    # Connect to the local MySQL server
    connection = mysql.connector.connect(
        host='localhost',
        user='root',         
        password=Cpassword,
        database='nvdav1'
    )
    
    # Query to extract table contents
    query = f"SELECT * FROM {table_name}"
    
    # Read the table into a DataFrame
    df = pd.read_sql(query, connection)
    
    # Write the DataFrame to a CSV file
    df.to_csv(f"{table_name}.csv", index=False)
    
    # Close the connection
    connection.close()

# stock_ticks, technical_indicators, stock_prices, stock_splits, stock_dividends
extract_table_to_csv("stock_ticks", Cpassword)