-- Insert data into Weather Station table
INSERT INTO testmetaschema.tblweatherstation(serialnumber, lastsync, consbatteryvoltage, rxcheckpercent, txbatterystatus,
    referencevoltage, supplyvoltage, altitude, latitude, longitude, parish, piip, localmqtt,
    remotemqtt, pistate, fanstate, sleepmode)
SELECT DISTINCT serialnumber, lastsync, consbatteryvoltage, rxcheckpercent, txbatterystatus,
    referencevoltage, supplyvoltage, altitude, latitude, longitude, parish, piip, localmqtt,
    remotemqtt, pistate, fanstate, sleepmode
FROM testmetaschema.tblmastertable;

-- Insert data into Radiation Data table
INSERT INTO testmetaschema.tblradiationdata(timestamp, serialnumber, uv, uvbatterystatus, highuv, highradiation,
    radiation, maxsolarrad, luminosity)
SELECT timestamp, serialnumber, uv, uvbatterystatus, highuv, highradiation, radiation, maxsolarrad, luminosity
FROM testmetaschema.tblmastertable;

-- Insert data into Rain Data table
INSERT INTO testmetaschema.tblraindata(timestamp, serialnumber, rain, dewpoint, rainrate, evapotrans, inhumidity,
    outhumidity, leafwet1, leafwet2, rainbatterystatus, hail, hailrate, hailbatterystatus, forecast)
SELECT timestamp, serialnumber, rain, dewpoint, rainrate, evapotrans, inhumidity, outhumidity, leafwet1,
    leafwet2, rainbatterystatus, hail, hailrate, hailbatterystatus, forecast
FROM testmetaschema.tblmastertable;

-- Insert data into Soil Data table
INSERT INTO testmetaschema.tblsoildata(timestamp, serialnumber, soilmoist1, soilmoist2, soilmoist3, soilmoist4,
    soiltemp1, soiltemp2, soiltemp3, soiltemp4)
SELECT timestamp, serialnumber, soilmoist1, soilmoist2, soilmoist3, soilmoist4, soiltemp1, soiltemp2,
    soiltemp3, soiltemp4
FROM testmetaschema.tblmastertable;

-- Insert data into Temperature Data table (including comfort data)
INSERT INTO testmetaschema.tbltempdata(timestamp, serialnumber, intemp, intempbatterystatus, outtemp,
    outtempbatterystatus, lowouttemp, highouttemp, leaftemp1, leaftemp2, indewpoint, heatingtemp,
    heatingvoltage, humidex, humidex1, apptemp, heatindex, cloudbase)
SELECT timestamp, serialnumber, intemp, intempbatterystatus, outtemp, outtempbatterystatus, lowouttemp,
    highouttemp, leaftemp1, leaftemp2, indewpoint, heatingtemp, heatingvoltage, humidex, humidex1,
    apptemp, heatindex, cloudbase
FROM testmetaschema.tblmastertable;

-- Insert data into Wind Data table
INSERT INTO testmetaschema.tblwinddata(timestamp, serialnumber, barometer, windchill, windgustdir, windgust,
    windspeed, winddir, windrun, windbatterystatus)
SELECT timestamp, serialnumber, barometer, windchill, windgustdir, windgust, windspeed, winddir, windrun,
    windbatterystatus
FROM testmetaschema.tblmastertable;

-- Insert data into Air Quality Data table
INSERT INTO testmetaschema.tblairqualitydata(timestamp, serialnumber, so2, noise)
SELECT timestamp, serialnumber, so2, noise
FROM testmetaschema.tblmastertable;

-- Insert data into Lightning Data table
INSERT INTO testmetaschema.tbllightningdata(timestamp, serialnumber, lightningdistance, lightningdisturbercount,
    lightningenergy, lightningnoisecount, lightningstrikecount)
SELECT timestamp, serialnumber, lightningdistance, lightningdisturbercount,
    lightningenergy, lightningnoisecount, lightningstrikecount
FROM testmetaschema.tblmastertable;

UPDATE testmetaschema.tblweatherstation ws
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
        WHERE serialnumber = 'UWIT001'
    )
) latest
WHERE ws.serialnumber = 'UWIT001';