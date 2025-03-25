import psycopg2 
import numpy as np 
import psycopg2.extras as extras 
import pandas as pd 

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

    alter_statement = """UPDATE testmetaschema.tblweatherstation ws
                    SET 
                        lastsync = latest.timestamp,
                        consbatteryvoltage = latest.consbatteryvoltage,
                        rxcheckpercent = latest.rxcheckpercent,
                        txbatterystatus = latest.txbatterystatus,
                        referencevoltage = latest.referencevoltage,
                        supplyvoltage = latest.supplyvoltage,
                        altitude = latest.altitude,
                        latitude = latest.latitude,
                        longitude = latest.longitude,
                        parish = latest.parish,
                        piip = latest.piip,
                        localmqtt = latest.localmqtt,
                        remotemqtt = latest.remotemqtt,
                        pistate = latest.pistate,
                        fanstate = latest.fanstate,
                        sleepmode = latest.sleepmode
                    FROM (
                        SELECT * FROM testmetaschema.tblmastertable
                        WHERE id = (
                            SELECT MAX(id) 
                            FROM testmetaschema.tblmastertable 
                            WHERE stationid = 'UWIT001'
                        )
                    ) latest
                    WHERE ws.stationid = 'UWIT001';"""
    
    cursor = conn.cursor()
    cursor.execute(alter_statement)
    conn.commit()

    for statement in insert_statements:
        cursor.execute(statement)
    conn.commit()
    cursor.close()
    

def main():
    conn = psycopg2.connect(
        host="localhost",
        database="postgres",
        user="postgres",
        password="rozWuk-betkuf"
    )

    df = pd.read_csv(r'C:\Users\Lui\OneDrive\Desktop\metProjCSVs\UWIT001_St.Andrew_21-03-2025-07.csv')
    df = df.rename(columns={'dateTime':'timestamp', 'altimeter': 'altitude', 'ET': 'evapoTrans', 'lightning_distance': 'lightningDistance', 'lightning_energy': 'lightningEnergy', 'lightning_strike_count': 'lightningStrikeCount', 'lightning_disturber_count': 'lightningDisturberCount', 'lightning_noise_count' : 'lightningNoiseCount'})
    print(df.head())
    table = 'testMetaSchema.tblMasterTable'
    execute_values(conn, df, table)
    populate_tables(conn)
    conn.close()



if __name__ == '__main__':
    main()