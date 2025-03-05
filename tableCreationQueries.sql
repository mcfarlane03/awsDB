CREATE SCHEMA IF NOT EXISTS testMetaSchema;

CREATE TABLE IF NOT EXISTS testMetaSchema.tblMasterTable (
	id SERIAL PRIMARY KEY,	-- station data
    stationID INT,
    timestamp INT NOT NULL,
	consBatteryVoltage REAL,
	txBatteryStatus REAL,
	rxCheckPercent REAL,
	interval INT,

	locationID INT, -- location data
	locationName VARCHAR(20),
    altitude REAL,
    latitude REAL,
    longitude REAL,
	parish VARCHAR(20),

	piID	INT, -- pi DATA
	piIP	VARCHAR(15),
	lastSync	INT,
	localMqtt	VARCHAR(20),
	remoteMqtt	VARCHAR(20),
	piState		bool,
	fanState	bool,
	sleepMode	bool,

	rainID SERIAL, -- rain data
    rain REAL,
	dewPoint REAL,
	rainRate REAL,
	evapoTrans REAL,
	inHumidity REAL,
	outHumidity REAL,
	leafWet1 REAL,
    leafWet2 REAL,

	tempID SERIAL,	-- temp data
    heatIndex REAL,
    inTemp REAL,
    outTemp REAL,
    leafTemp1 REAL,
    leafTemp2 REAL,

	radiationID SERIAL, -- radiation data
    radiation REAL,
	UV REAL,

	soilID SERIAL, -- soil data
    soilMoist1 REAL,
    soilMoist2 REAL,
    soilMoist3 REAL,
    soilMoist4 REAL,
    soilTemp1 REAL,
    soilTemp2 REAL,
    soilTemp3 REAL,
    soilTemp4 REAL,

	windID SERIAL, 	-- wind DATA
	barometer REAL,
    windchill REAL,
    windGustDir REAL,
    windGust REAL,
    windSpeed REAL
);

CREATE TABLE IF NOT EXISTS testMetaSchema.tblLocation(
	locationID INT primary key,
	stationName VARCHAR(20),
	stationID int,
	altitude REAL,
    latitude REAL,
    longitude REAL,
	parish VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS testMetaSchema.tblWeatherStation(
	stationID INT PRIMARY KEY,
    timestamp INT NOT NULL,
    consBatteryVoltage REAL,
    rxCheckPercentage REAL,
    txBatteryStatus REAL
);

CREATE TABLE IF NOT EXISTS testMetaSchema.tblRaspPi(
    piID INT PRIMARY KEY,
	piIP	VARCHAR(15),
	lastSync	INT,
	localMqtt	VARCHAR(20),
	remoteMqtt	VARCHAR(20),
	piState		bool,
	fanState	bool,
	sleepMode	bool
);

CREATE TABLE IF NOT EXISTS testMetaSchema.tblRainData(
	rainID	INT,
	timestamp INT NOT NULL,
	stationID INT NOT NULL,
	rain REAL,
	dewPoint REAL,
	rainRate REAL,
	evapoTrans REAL,
	inHumidity REAL,
	outHumidity REAL,
	leafWet1 REAL,
    leafWet2 REAL,
    foreign key (stationID) references testMetaSchema.tblWeatherStation,
    foreign key (rainID) references testMetaSchema.tblMasterTable,
    primary key (rainID,stationID)
);

CREATE TABLE IF NOT EXISTS testMetaSchema.tblWindData(
    windID INT,
    timestamp INT NOT NULL,
	stationID INT NOT NULL,
    barometer REAL,
    windchill REAL,
    windGustDir REAL,
    windGust REAL,
    windSpeed REAL,
    foreign key (stationID) references testMetaSchema.tblWeatherStation,
    foreign key (windID) references testMetaSchema.tblMasterTable,
    primary key (windID,stationID)
);

CREATE TABLE IF NOT EXISTS testMetaSchema.tblSoilData(
    soilID INT,
    timestamp INT NOT NULL,
    stationID INT NOT NULL,
    soilMoist1 REAL,
    soilMoist2 REAL,
    soilMoist3 REAL,
    soilMoist4 REAL,
    soilTemp1  REAL,
    soilTemp2  REAL,
    soilTemp3  REAL,
    soilTemp4  REAL,
    foreign key (stationID) references testMetaSchema.tblWeatherStation,
    foreign key (soilID) references testMetaSchema.tblMasterTable,
    primary key (soilID,stationID)
);

CREATE TABLE IF NOT EXISTS testMetaSchema.radiationData(
    radiationID INT,
    timestamp INT NOT NULL,
    stationID INT NOT NULL,
    UV REAL,
    highUV REAL,
    highRadiation REAL,
    radiation REAL,
    foreign key (stationID) references testMetaSchema.tblWeatherStation,
    foreign key (radiationID) references testMetaSchema.tblMasterTable,
    primary key (radiationID,stationID)
);

CREATE TABLE IF NOT EXISTS testMetaSchema.tblTemperature(
    tempID INT,
    timestamp INT NOT NULL,
    stationID INT NOT NULL,
    intTemp REAL,
    outTemp REAL,
    lowOutTemp REAL,
    highOutTemp REAL,
    leafTemp1 REAL,
    leafTemp2 REAL,
    foreign key (stationID) references testMetaSchema.tblWeatherStation,
    foreign key (tempID) references testMetaSchema.tblMasterTable,
    primary key (tempID,stationID)
);