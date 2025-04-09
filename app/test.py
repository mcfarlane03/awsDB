import os
import psycopg2 
import numpy as np 
import psycopg2.extras as extras 
import pandas as pd 
from dotenv import load_dotenv, find_dotenv

# Load environment variables from .env file
load_dotenv(find_dotenv())  

def execute_values(conn, df, table): 

    tuples = [tuple(x) for x in df.to_numpy()] 

    cols = ','.join(list(df.columns))
    insert_query = "INSERT INTO %s(%s) VALUES %%s" % (table, cols)
    cursor = conn.cursor()

    try:
        extras.execute_values(cursor, insert_query, tuples)
        conn.commit()

    except (Exception, psycopg2.DatabaseError) as error:
        print("Error: %s" % error)
        conn.rollback()
        cursor.close()
        return 1
    print("DF inserted successfully")
    cursor.close()

def populate_tables(conn):

    weather_station_insert = """
        INSERT INTO testmetaschema.tblweatherstation (
            stationid, lastsync, consbatteryvoltage, rxcheckpercent, txbatterystatus, 
            referencevoltage, supplyvoltage, altitude, latitude, longitude, parish, 
            piip, localmqtt, remotemqtt, pistate, fanstate, sleepmode
        )
        SELECT DISTINCT 
            mt.stationid, 
            FIRST_VALUE(mt.timestamp) OVER (PARTITION BY mt.stationid ORDER BY mt.timestamp DESC),
            FIRST_VALUE(mt.consbatteryvoltage) OVER (PARTITION BY mt.stationid ORDER BY mt.timestamp DESC),
            FIRST_VALUE(mt.rxcheckpercent) OVER (PARTITION BY mt.stationid ORDER BY mt.timestamp DESC),
            FIRST_VALUE(mt.txbatterystatus) OVER (PARTITION BY mt.stationid ORDER BY mt.timestamp DESC),
            FIRST_VALUE(mt.referencevoltage) OVER (PARTITION BY mt.stationid ORDER BY mt.timestamp DESC),
            FIRST_VALUE(mt.supplyvoltage) OVER (PARTITION BY mt.stationid ORDER BY mt.timestamp DESC),
            FIRST_VALUE(mt.altitude) OVER (PARTITION BY mt.stationid ORDER BY mt.timestamp DESC),
            FIRST_VALUE(mt.latitude) OVER (PARTITION BY mt.stationid ORDER BY mt.timestamp DESC),
            FIRST_VALUE(mt.longitude) OVER (PARTITION BY mt.stationid ORDER BY mt.timestamp DESC),
            FIRST_VALUE(mt.parish) OVER (PARTITION BY mt.stationid ORDER BY mt.timestamp DESC),
            FIRST_VALUE(mt.piip) OVER (PARTITION BY mt.stationid ORDER BY mt.timestamp DESC),
            FIRST_VALUE(mt.localmqtt) OVER (PARTITION BY mt.stationid ORDER BY mt.timestamp DESC),
            FIRST_VALUE(mt.remotemqtt) OVER (PARTITION BY mt.stationid ORDER BY mt.timestamp DESC),
            FIRST_VALUE(mt.pistate) OVER (PARTITION BY mt.stationid ORDER BY mt.timestamp DESC),
            FIRST_VALUE(mt.fanstate) OVER (PARTITION BY mt.stationid ORDER BY mt.timestamp DESC),
            FIRST_VALUE(mt.sleepmode) OVER (PARTITION BY mt.stationid ORDER BY mt.timestamp DESC)
        FROM testmetaschema.tblmastertable mt
        ON CONFLICT (stationid) DO UPDATE SET
            lastsync = EXCLUDED.lastsync,
            consbatteryvoltage = EXCLUDED.consbatteryvoltage,
            rxcheckpercent = EXCLUDED.rxcheckpercent,
            txbatterystatus = EXCLUDED.txbatterystatus,
            referencevoltage = EXCLUDED.referencevoltage,
            supplyvoltage = EXCLUDED.supplyvoltage,
            altitude = EXCLUDED.altitude,
            latitude = EXCLUDED.latitude,
            longitude = EXCLUDED.longitude,
            parish = EXCLUDED.parish,
            piip = EXCLUDED.piip,
            localmqtt = EXCLUDED.localmqtt,
            remotemqtt = EXCLUDED.remotemqtt,
            pistate = EXCLUDED.pistate,
            fanstate = EXCLUDED.fanstate,
            sleepmode = EXCLUDED.sleepmode;
    """

    insert_statements = [                         
                        """INSERT INTO testmetaschema.tblradiationdata(timestamp, stationid, uv, uvbatterystatus, highuv, highradiation,
                            radiation, maxsolarrad, luminosity)
                        SELECT timestamp, stationid, uv, uvbatterystatus, highuv, highradiation, radiation, maxsolarrad, luminosity
                        FROM testmetaschema.tblmastertable;""",

                        """INSERT INTO testmetaschema.tblraindata(timestamp, stationid, rain, dewpoint, rainrate, evapotrans, inhumidity,
                            outhumidity, leafwet1, leafwet2, rainbatterystatus, hail, hailrate, hailbatterystatus, forecast)
                        SELECT timestamp, stationid, rain, dewpoint, rainrate, evapotrans, inhumidity, outhumidity, leafwet1,
                            leafwet2, rainbatterystatus, hail, hailrate, hailbatterystatus, forecast
                        FROM testmetaschema.tblmastertable;""",

                        """INSERT INTO testmetaschema.tblsoildata(timestamp, stationid, soilmoist1, soilmoist2, soilmoist3, soilmoist4,
                            soiltemp1, soiltemp2, soiltemp3, soiltemp4)
                        SELECT timestamp, stationid, soilmoist1, soilmoist2, soilmoist3, soilmoist4, soiltemp1, soiltemp2,
                            soiltemp3, soiltemp4
                        FROM testmetaschema.tblmastertable;""",
                        
                        """INSERT INTO testmetaschema.tbltempdata(timestamp, stationid, intemp, intempbatterystatus, outtemp,
                            outtempbatterystatus, lowouttemp, highouttemp, leaftemp1, leaftemp2, indewpoint, heatingtemp,
                            heatingvoltage, humidex, humidex1, apptemp, heatindex, cloudbase)
                        SELECT timestamp, stationid, intemp, intempbatterystatus, outtemp, outtempbatterystatus, lowouttemp,
                            highouttemp, leaftemp1, leaftemp2, indewpoint, heatingtemp, heatingvoltage, humidex, humidex1,
                            apptemp, heatindex, cloudbase
                        FROM testmetaschema.tblmastertable;""",

                        """INSERT INTO testmetaschema.tblwinddata(timestamp, stationid, barometer, windchill, windgustdir, windgust,
                            windspeed, winddir, windrun, windbatterystatus)
                        SELECT timestamp, stationid, barometer, windchill, windgustdir, windgust, windspeed, winddir, windrun,
                            windbatterystatus
                        FROM testmetaschema.tblmastertable;""",

                        """INSERT INTO testmetaschema.tblairqualitydata(timestamp, stationid, so2, noise)
                        SELECT timestamp, stationid, so2, noise
                        FROM testmetaschema.tblmastertable;""",

                        """INSERT INTO testmetaschema.tbllightningdata(timestamp, stationid, lightningdistance, lightningdisturbercount,
                            lightningenergy, lightningnoisecount, lightningstrikecount)
                        SELECT timestamp, stationid, lightningdistance, lightningdisturbercount,
                            lightningenergy, lightningnoisecount, lightningstrikecount
                        FROM testmetaschema.tblmastertable;"""
                        ]

    
    
    cursor = conn.cursor()
    cursor.execute("SELECT DISTINCT stationid FROM testmetaschema.tblmastertable;")
    print(cursor.fetchall())
    
    # For each station ID, execute the alter statement
    print("Populating weather station table...")
    cursor.execute(weather_station_insert)
    conn.commit()

    print("Populating other tables...")
    for statement in insert_statements:
        cursor.execute(statement)
        conn.commit()
    cursor.close()
    

def import_data(conn,directory):
    # Assign directory
    # directory = r"C:\Users\Lui\OneDrive\Desktop\metProjCSVs"

    # Iterate over files in directory
    for name in os.listdir(directory):
        if name.lower().endswith('.csv'):
            # Open file from directory
            full_path = os.path.join(directory, name)
            print(f"Processing file {full_path}")

            try:
                    # Open file from full path
                    df = pd.read_csv(full_path)
                    
                    # Rename columns
                    df = df.rename(columns={
                        'dateTime': 'timestamp', 
                        'altimeter': 'altitude', 
                        'ET': 'evapoTrans', 
                        'lightning_distance': 'lightningDistance', 
                        'lightning_energy': 'lightningEnergy', 
                        'lightning_strike_count': 'lightningStrikeCount', 
                        'lightning_disturber_count': 'lightningDisturberCount', 
                        'lightning_noise_count': 'lightningNoiseCount'
                    })
                    
                    # Replace NaN with None
                    df = df.replace({np.nan: None})
                    
                    # Print first few rows (optional)
                    # print(df.head())
                    
                    # Define table name
                    table = 'testMetaSchema.tblMasterTable'
                    
                    # Execute database operations
                    execute_values(conn, df, table)
                    
                
            except FileNotFoundError:
                print(f"File not found: {full_path}")
            except Exception as e:
                print(f"Error processing file {full_path}: {e}")


def main():
    conn = psycopg2.connect(
        user = os.getenv("DATABASE_USERNAME"),                                      
        password = os.getenv("DATABASE_PASSWORD"),                                  
        host = os.getenv("DATABASE_IP"),                                            
        port = os.getenv("DATABASE_PORT"),                                          
        database = os.getenv("DATABASE_NAME")   
    )

    
    import_data(conn, r"C:\Users\Lui\OneDrive\Desktop\metProjCSVs")
    populate_tables(conn)
    conn.close()



if __name__ == '__main__':
    main()