CREATE SCHEMA IF NOT EXISTS testMetaSchema;

-- Complete master table with ALL columns
CREATE TABLE IF NOT EXISTS testMetaSchema.tblMasterTable (
    id SERIAL PRIMARY KEY,
    stationID VARCHAR(10),
    timestamp INT NOT NULL,
    interval INT,

    -- Station data
    consBatteryVoltage REAL,
    txBatteryStatus REAL,
    rxCheckPercent REAL,
    referenceVoltage REAL,
    supplyVoltage REAL,

    -- Location data
    locationName VARCHAR(20),
    altitude REAL, -- Same as altimeter
    latitude REAL,
    longitude REAL,
    parish VARCHAR(20),

    -- Pi/System data
    piIP VARCHAR(15),
    lastSync INT,
    localMqtt VARCHAR(20),
    remoteMqtt VARCHAR(20),
    piState BOOL,
    fanState BOOL,
    sleepMode BOOL,

    -- Rain and humidity data
    rain REAL,
    rainRate REAL,
    rainBatteryStatus REAL,
    hail REAL,
    hailRate REAL,
    hailBatteryStatus REAL,
    dewPoint REAL,
    evapoTrans REAL, -- ET in your dataset
    inHumidity REAL,
    outHumidity REAL,
    leafWet1 REAL,
    leafWet2 REAL,
    forecast REAL,

    -- Temperature data
    inTemp REAL,
    inTempBatteryStatus REAL,
    outTemp REAL,
    outTempBatteryStatus REAL,
    lowOutTemp REAL,
    highOutTemp REAL,
    leafTemp1 REAL,
    leafTemp2 REAL,
    inDewpoint REAL,
    heatingTemp REAL,
    heatingVoltage REAL,

    -- Comfort indices
    humidex REAL,
    humidex1 REAL,
    appTemp REAL,
    heatIndex REAL,
    cloudBase REAL,

    -- Radiation data
    radiation REAL,
    highRadiation REAL,
    UV REAL,
    highUV REAL,
    uvBatteryStatus REAL,
    maxSolarRad REAL,
    luminosity REAL,

    -- Soil data
    soilMoist1 REAL,
    soilMoist2 REAL,
    soilMoist3 REAL,
    soilMoist4 REAL,
    soilTemp1 REAL,
    soilTemp2 REAL,
    soilTemp3 REAL,
    soilTemp4 REAL,

    -- Wind data
    barometer REAL, -- Same as pressure
    windchill REAL,
    windDir REAL,
    windGustDir REAL,
    windGust REAL,
    windSpeed REAL,
    windrun REAL,
    windBatteryStatus REAL,

    -- Air quality data
    so2 REAL,
    noise REAL,

    -- Lightning data
    lightningDistance REAL,
    lightningDisturberCount REAL,
    lightningEnergy REAL,
    lightningNoiseCount REAL,
    lightningStrikeCount REAL
);

-- The specialized tables remain unchanged but will pull from master table
CREATE TABLE IF NOT EXISTS testMetaSchema.tblWeatherStation(
    stationID VARCHAR(10) PRIMARY KEY,
    lastSync INT NOT NULL,
    consBatteryVoltage REAL,
    rxCheckPercent REAL,
    txBatteryStatus REAL,
    referenceVoltage REAL,
    supplyVoltage REAL,
    stationName VARCHAR(20),
    altitude REAL,
    latitude REAL,
    longitude REAL,
    parish VARCHAR(20),
    piIP VARCHAR(15),
    localMqtt VARCHAR(20),
    remoteMqtt VARCHAR(20),
    piState BOOL,
    fanState BOOL,
    sleepMode BOOL
);

CREATE TABLE IF NOT EXISTS testMetaSchema.tblRainData(
    rainID SERIAL PRIMARY KEY,
    timestamp INT NOT NULL,
    stationID VARCHAR(10) NOT NULL,
    rain REAL,
    dewPoint REAL,
    rainRate REAL,
    evapoTrans REAL,
    inHumidity REAL,
    outHumidity REAL,
    leafWet1 REAL,
    leafWet2 REAL,
    rainBatteryStatus REAL,
    hail REAL,
    hailRate REAL,
    hailBatteryStatus REAL,
    forecast REAL,
    foreign key (stationID) references testMetaSchema.tblWeatherStation
);

CREATE TABLE IF NOT EXISTS testMetaSchema.tblWindData(
    windID SERIAL PRIMARY KEY,
    timestamp INT NOT NULL,
    stationID VARCHAR(10) NOT NULL,
    barometer REAL,
    windchill REAL,
    windGustDir REAL,
    windGust REAL,
    windSpeed REAL,
    windDir REAL,
    windrun REAL,
    windBatteryStatus REAL,
    foreign key (stationID) references testMetaSchema.tblWeatherStation
);

CREATE TABLE IF NOT EXISTS testMetaSchema.tblSoilData(
    soilID SERIAL PRIMARY KEY,
    timestamp INT NOT NULL,
    stationID VARCHAR(10) NOT NULL,
    soilMoist1 REAL,
    soilMoist2 REAL,
    soilMoist3 REAL,
    soilMoist4 REAL,
    soilTemp1 REAL,
    soilTemp2 REAL,
    soilTemp3 REAL,
    soilTemp4 REAL,
    foreign key (stationID) references testMetaSchema.tblWeatherStation
);

CREATE TABLE IF NOT EXISTS testMetaSchema.tblRadiationData(
    radiationID SERIAL PRIMARY KEY,
    timestamp INT NOT NULL,
    stationID VARCHAR(10) NOT NULL,
    UV REAL,
    uvBatteryStatus REAL,
    highUV REAL,
    highRadiation REAL,
    radiation REAL,
    maxSolarRad REAL,
    luminosity REAL,
    foreign key (stationID) references testMetaSchema.tblWeatherStation
);

CREATE TABLE IF NOT EXISTS testMetaSchema.tblTempData(
    tempID SERIAL PRIMARY KEY,
    timestamp INT NOT NULL,
    stationID VARCHAR(10) NOT NULL,
    inTemp REAL,
    inTempBatteryStatus REAL,
    outTemp REAL,
    outTempBatteryStatus REAL,
    lowOutTemp REAL,
    highOutTemp REAL,
    leafTemp1 REAL,
    leafTemp2 REAL,
    inDewpoint REAL,
    heatingTemp REAL,
    heatingVoltage REAL,
    -- Comfort data moved from the deleted comfort table
    humidex REAL,
    humidex1 REAL,
    appTemp REAL,
    heatIndex REAL,
    cloudBase REAL,
    foreign key (stationID) references testMetaSchema.tblWeatherStation
);

CREATE TABLE IF NOT EXISTS testMetaSchema.tblAirQualityData(
    airQualityID SERIAL PRIMARY KEY,
    timestamp INT NOT NULL,
    stationID VARCHAR(10) NOT NULL,
    so2 REAL,
    noise REAL,
    foreign key (stationID) references testMetaSchema.tblWeatherStation
);

CREATE TABLE IF NOT EXISTS testMetaSchema.tblLightningData(
    lightningID SERIAL PRIMARY KEY,
    timestamp INT NOT NULL,
    stationID VARCHAR(10) NOT NULL,
    lightningDistance REAL,
    lightningDisturberCount REAL,
    lightningEnergy REAL,
    lightningNoiseCount REAL,
    lightningStrikeCount REAL,
    foreign key (stationID) references testMetaSchema.tblWeatherStation
);