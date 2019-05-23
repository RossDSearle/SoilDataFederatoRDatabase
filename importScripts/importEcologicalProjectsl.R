library(stringr)
library(RSQLite)
library(DBI)


projectRoot <- 'C:/Users/sea084/Dropbox/RossRCode/Git/SoilDataFederatoRDatabase'
Hosted_dbPath <- paste0(projectRoot, '/DB/SoilDataFederatorDatabase.db3')

source(paste0(projectRoot, '/HostedHelpers.R'))

indf <- read.csv('C:/Projects/TernLandscapes/Site Data/Karel/soil_data_ecol_surveys/EcologicalSurverys_soil_data_2019-03-13.csv', stringsAsFactors = F)
nrow(indf)

unique(indf$measurementType)
unique(indf$projectID)

dates <- str_extract(indf$plotObservationID, "(?<=_)[^_]*$")
sid <- str_extract(indf$plotID, "(?<=_)[^_]*$")

ud <- indf[indf$measurementType =='Soil horizon upper depth', ]
nrow(ud)
ld <- indf[indf$measurementType =='Soil horizon lower depth', ]
nrow(ld)

sapply(Split, tail, 1)

provid <- 'EcologicalSurverys_soil_data'

outdf <- data.frame(
  
  Provider = provid,
  Dataset = indf$projectID,
  Observation_ID = sid,
  Longitude = indf$verbatimLongitude,
  Latitude = indf$verbatimLatitude,
  SampleID = '1',
  Date = dates,
  UpperDepth = ud,
  LowerDepth = ld,
  PropertyType = attTypes[i],
  ObservedProperty = propCode[i],
  Value = df1[, atts[i]],
  Units = units[i],
  Quality = 1,
  stringsAsFactors = F
)


provid <- 'EcologicalSurverys_soil_data'
dataset <- 'NatGeoChemicalSurvey'

atts <- c('FIELD.pH',	'pH.1.5',	'EC.1.5',	'Sand..',	'Silt..',	'Clay..')
attTypes <- c('FieldMeasurement',	'LaboratoryMeasurement',	'LaboratoryMeasurement',	'LaboratoryMeasurement',	'LaboratoryMeasurement',	'LaboratoryMeasurement')
propCode <- c('PH_VALUE',	'4A1',	'3A1',	'P10_NR_S', 'P10_NR_Z', 'P10_NR_C')
units <- c('NA', 'NA' , 'dS/m', '%' , '%', '%')


depth <- 'TOS'
depth <- 'BOS'
df1 <- indf[indf$GRAIN.SIZE == 'Bulk' & indf$DEPTH == depth, ]
# ud <- 0
# ld <- 10
 ud = 60
 ld = 80

nrow(df1)
str(df1)

con <- DBI::dbConnect(RSQLite::SQLite(), Hosted_dbPath)

# Datastore
# Provider
# Dataset

for (i in 1:length(atts)) {
  
  print(atts[i])
  
  outdf <- data.frame(
    
    Provider = provid,
    Dataset = dataset,
    Observation_ID = df1$SITEID,
    Longitude = df1$LONGITUDE,
    Latitude = df1$LATITUDE,
    SampleID = '1',
    Date = df1$DATE.SAMPLED,
    UpperDepth = ud,
    LowerDepth = ld,
    PropertyType = attTypes[i],
    ObservedProperty = propCode[i],
    Value = df1[, atts[i]],
    Units = units[i],
    Quality = 1,
    stringsAsFactors = F
  )
  dbWriteTable(con, 'ObservedProperties', outdf, append=T)
}

str(outdf)



#del <- "delete from ObservedProperties"
#doHostedQuery(del)
