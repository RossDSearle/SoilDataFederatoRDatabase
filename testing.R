library(stringr)
library(RSQLite)
library(DBI)

projectRoot <- 'C:/Users/sea084/Dropbox/RossRCode/Git/SoilDataFederatoRDatabase'
Hosted_dbPath <- paste0(projectRoot, '/DB/SoilDataFederatorDatabase.db3')

source(paste0(projectRoot, '/HostedHelpers.R'))
source(paste0(projectRoot, '/API.R'))

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
