library(stringr)
library(RSQLite)
library(DBI)

machineName <- as.character(Sys.info()['nodename'])
if(machineName=='soils-discovery'){
  projectRoot <<- '/srv/plumber/TERNLandscapes/SoilDataFederatoRDatabase'
}else{
  projectRoot <<- 'C:/Users/sea084/Dropbox/RossRCode/Git/TERNLandscapes/APIs/SoilDataFederatoRDatabase'
}
Hosted_dbPath <- paste0(projectRoot, '/DB/SoilDataFederatorDatabase.db3')

source(paste0(projectRoot, '/TERNSoilDB_API.R'))

source(paste0(projectRoot, '/TERNSoilDBHelpers.R'))

hDB_getProviders()

hDB_getDatasets()
hDB_getDatasets( verbose = T)
hDB_getDatasets('Bob')
hDB_getDatasets(Provider = 'Bob', verbose = T)
hDB_getDatasets(Provider = 'Bob', verbose = F)


ObserverdProperties = 'PH_VALUE;3A1'

d <- hDB_getSoilData(ObserverdProperties = ObserverdProperties)
d <- hDB_getSoilData(Provider = 'Bob', ObserverdProperties = ObserverdProperties)
tail(d)


hDB_getSoilData(Provider = 'Bob', ObserverdProperties = ObserverdProperties)


observedPropertyGroup = 'PH'
hDB_getPropertiesList(ObserverdProperties, observedPropertyGroup)
hDB_getSoilData(ObserverdProperties = ObserverdProperties, observedPropertyGroup = observedPropertyGroup)
hDB_getSoilData(ObserverdProperties = ObserverdProperties, observedPropertyGroup = NULL)
