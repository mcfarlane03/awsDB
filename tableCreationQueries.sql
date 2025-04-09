CREATE SCHEMA IF NOT EXISTS testMetaSchema;

create table if not exists testmetaschema.tblmastertable
(
    id                      serial
        primary key,
    stationid               varchar(10),
    timestamp               integer not null,
    interval                integer,
    consbatteryvoltage      real,
    txbatterystatus         real,
    rxcheckpercent          real,
    referencevoltage        real,
    supplyvoltage           real,
    altitude                real,
    latitude                real,
    longitude               real,
    parish                  varchar(20),
    piip                    varchar(15),
    lastsync                integer,
    localmqtt               varchar(20),
    remotemqtt              varchar(20),
    pistate                 boolean,
    fanstate                boolean,
    sleepmode               boolean,
    rain                    real,
    rainrate                real,
    rainbatterystatus       real,
    hail                    real,
    hailrate                real,
    hailbatterystatus       real,
    dewpoint                real,
    evapotrans              real,
    inhumidity              real,
    outhumidity             real,
    leafwet1                real,
    leafwet2                real,
    forecast                real,
    intemp                  real,
    intempbatterystatus     real,
    outtemp                 real,
    outtempbatterystatus    real,
    lowouttemp              real,
    highouttemp             real,
    leaftemp1               real,
    leaftemp2               real,
    indewpoint              real,
    heatingtemp             real,
    heatingvoltage          real,
    humidex                 real,
    humidex1                real,
    apptemp                 real,
    heatindex               real,
    cloudbase               real,
    radiation               real,
    highradiation           real,
    uv                      real,
    highuv                  real,
    uvbatterystatus         real,
    maxsolarrad             real,
    luminosity              real,
    soilmoist1              real,
    soilmoist2              real,
    soilmoist3              real,
    soilmoist4              real,
    soiltemp1               real,
    soiltemp2               real,
    soiltemp3               real,
    soiltemp4               real,
    barometer               real,
    windchill               real,
    winddir                 real,
    windgustdir             real,
    windgust                real,
    windspeed               real,
    windrun                 real,
    windbatterystatus       real,
    so2                     real,
    noise                   real,
    lightningdistance       real,
    lightningdisturbercount real,
    lightningenergy         real,
    lightningnoisecount     real,
    lightningstrikecount    real,
    pressure                real
);

create table if not exists testmetaschema.tblweatherstation
(
    stationid          varchar(10) not null
        primary key,
    lastsync           integer,
    consbatteryvoltage real,
    rxcheckpercent     real,
    txbatterystatus    real,
    referencevoltage   real,
    supplyvoltage      real,
    altitude           real,
    latitude           real,
    longitude          real,
    parish             varchar(20),
    piip               varchar(15),
    localmqtt          varchar(20),
    remotemqtt         varchar(20),
    pistate            boolean,
    fanstate           boolean,
    sleepmode          boolean
);

create table if not exists testmetaschema.tblraindata
(
    rainid            serial
        primary key,
    timestamp         integer     not null,
    stationid         varchar(10) not null
        references testmetaschema.tblweatherstation,
    rain              real,
    dewpoint          real,
    rainrate          real,
    evapotrans        real,
    inhumidity        real,
    outhumidity       real,
    leafwet1          real,
    leafwet2          real,
    rainbatterystatus real,
    hail              real,
    hailrate          real,
    hailbatterystatus real,
    forecast          real
);

create table if not exists testmetaschema.tblwinddata
(
    windid            serial
        primary key,
    timestamp         integer     not null,
    stationid         varchar(10) not null
        references testmetaschema.tblweatherstation,
    barometer         real,
    windchill         real,
    windgustdir       real,
    windgust          real,
    windspeed         real,
    winddir           real,
    windrun           real,
    windbatterystatus real
);

create table if not exists testmetaschema.tblsoildata
(
    soilid     serial
        primary key,
    timestamp  integer     not null,
    stationid  varchar(10) not null
        references testmetaschema.tblweatherstation,
    soilmoist1 real,
    soilmoist2 real,
    soilmoist3 real,
    soilmoist4 real,
    soiltemp1  real,
    soiltemp2  real,
    soiltemp3  real,
    soiltemp4  real
);

create table if not exists testmetaschema.tblradiationdata
(
    radiationid     serial
        primary key,
    timestamp       integer     not null,
    stationid       varchar(10) not null
        references testmetaschema.tblweatherstation,
    uv              real,
    uvbatterystatus real,
    highuv          real,
    highradiation   real,
    radiation       real,
    maxsolarrad     real,
    luminosity      real
);

create table if not exists testmetaschema.tbltempdata
(
    tempid               serial
        primary key,
    timestamp            integer     not null,
    stationid            varchar(10) not null
        references testmetaschema.tblweatherstation,
    intemp               real,
    intempbatterystatus  real,
    outtemp              real,
    outtempbatterystatus real,
    lowouttemp           real,
    highouttemp          real,
    leaftemp1            real,
    leaftemp2            real,
    indewpoint           real,
    heatingtemp          real,
    heatingvoltage       real,
    humidex              real,
    humidex1             real,
    apptemp              real,
    heatindex            real,
    cloudbase            real
);

create table if not exists testmetaschema.tblairqualitydata
(
    airqualityid serial
        primary key,
    timestamp    integer     not null,
    stationid    varchar(10) not null
        references testmetaschema.tblweatherstation,
    so2          real,
    noise        real
);

create table if not exists testmetaschema.tbllightningdata
(
    lightningid             serial
        primary key,
    timestamp               integer     not null,
    stationid               varchar(10) not null
        references testmetaschema.tblweatherstation,
    lightningdistance       real,
    lightningdisturbercount real,
    lightningenergy         real,
    lightningnoisecount     real,
    lightningstrikecount    real
);

