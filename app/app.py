from flask import Flask, request, jsonify, make_response
import psycopg2
import os
from dotenv import load_dotenv
from datetime import datetime
import psycopg2.extras
import time

load_dotenv()

app = Flask(__name__)

def get_db_connection():
    """Helper function to create database connection"""
    return psycopg2.connect(
        user=os.getenv("DATABASE_USERNAME"),
        password=os.getenv("DATABASE_PASSWORD"),
        host=os.getenv("DATABASE_IP"),
        port=os.getenv("DATABASE_PORT"),
        database=os.getenv("DATABASE_NAME")
    )

@app.route("/")
def hello_world():
    return "<p>Weather Station API</p>"

@app.route("/stations/all", methods=['GET'])
def get_all_stations():
    try:
        cnx = get_db_connection()
        cursor = cnx.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cursor.execute("SELECT * FROM testmetaschema.tblweatherstation")
        stations = [dict(row) for row in cursor.fetchall()]
        cursor.close()
        cnx.close()
        return make_response(jsonify(stations), 200)
    except Exception as e:
        print(f"Error: {e}")
        return make_response({"error": str(e)}, 500)

@app.route("/stations/<serialnumber>", methods=['GET'])
def get_station_info(serialnumber):
    try:
        cnx = get_db_connection()
        cursor = cnx.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cursor.execute("""
            SELECT * FROM testmetaschema.tblweatherstation 
            WHERE serialnumber = %s
        """, (serialnumber,))
        station = cursor.fetchone()
        cursor.close()
        cnx.close()
        
        if not station:
            return make_response({"error": "Station not found"}, 404)
            
        return make_response(jsonify(dict(station)), 200)
    except Exception as e:
        print(f"Error: {e}")
        return make_response({"error": str(e)}, 500)

# Individual table routes
@app.route("/data/radiation/<serialnumber>", methods=['GET'])
def get_radiation_data(serialnumber):
    return get_table_data(serialnumber, "tblradiationdata")

@app.route("/data/rain/<serialnumber>", methods=['GET'])
def get_rain_data(serialnumber):
    return get_table_data(serialnumber, "tblraindata")

@app.route("/data/soil/<serialnumber>", methods=['GET'])
def get_soil_data(serialnumber):
    return get_table_data(serialnumber, "tblsoildata")

@app.route("/data/temperature/<serialnumber>", methods=['GET'])
def get_temperature_data(serialnumber):
    return get_table_data(serialnumber, "tbltempdata")

@app.route("/data/wind/<serialnumber>", methods=['GET'])
def get_wind_data(serialnumber):
    return get_table_data(serialnumber, "tblwinddata")

@app.route("/data/airquality/<serialnumber>", methods=['GET'])
def get_airquality_data(serialnumber):
    return get_table_data(serialnumber, "tblairqualitydata")

@app.route("/data/lightning/<serialnumber>", methods=['GET'])
def get_lightning_data(serialnumber):
    return get_table_data(serialnumber, "tbllightningdata")

def get_table_data(serialnumber, table_name):
    """Helper function to get data from specific tables"""
    try:
        # Get query parameters
        limit = request.args.get('limit', default=1000, type=int)
        start_date = request.args.get('start_date')
        end_date = request.args.get('end_date')
        
        cnx = get_db_connection()
        cursor = cnx.cursor(cursor_factory=psycopg2.extras.DictCursor)
        
        # Base query
        query = f"""
            SELECT * FROM testmetaschema.{table_name}
            WHERE serialnumber = %s
        """
        params = [serialnumber]
        
        # Add date filtering if provided
        if start_date:
            try:
                # Convert date string to epoch timestamp (integer)
                start_datetime = datetime.strptime(start_date, '%Y-%m-%d')
                start_timestamp = int(start_datetime.timestamp())
                query += " AND timestamp >= %s"
                params.append(start_timestamp)
            except ValueError:
                return make_response({"error": "Invalid start_date format. Use YYYY-MM-DD"}, 400)
        
        if end_date:
            try:
                # Include the entire end day (23:59:59)
                end_datetime = datetime.strptime(end_date, '%Y-%m-%d').replace(hour=23, minute=59, second=59)
                end_timestamp = int(end_datetime.timestamp())
                query += " AND timestamp <= %s"
                params.append(end_timestamp)
            except ValueError:
                return make_response({"error": "Invalid end_date format. Use YYYY-MM-DD"}, 400)
        
        # Add sorting and limiting
        query += " ORDER BY timestamp DESC LIMIT %s"
        params.append(limit)
        
        cursor.execute(query, params)
        data = [dict(row) for row in cursor.fetchall()]
        
        cursor.close()
        cnx.close()
        
        if not data:
            return make_response({"error": "No data found for this station"}, 404)
            
        return make_response(jsonify(data), 200)
        
    except Exception as e:
        print(f"Error: {e}")
        return make_response({"error": str(e)}, 500)

if __name__ == '__main__':
    app.run(debug=True, port=8080)