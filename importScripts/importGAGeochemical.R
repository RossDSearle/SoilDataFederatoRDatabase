library(stringr)
library(RSQLite)
library(DBI)

source(HostedHelpers.R)

indf <- read.csv('C:/Projects/TernLandscapes/Site Data/National Geochemical Survey of Australia/Rec2011_020_110706.csv', skip = 11)
nrow(indf)

provid <- 'GeoscienceAustralia'
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
