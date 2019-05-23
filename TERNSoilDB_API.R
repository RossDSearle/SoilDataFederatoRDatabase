library(stringr)
library(RSQLite)
library(DBI)

projectRoot <- 'C:/Users/sea084/Dropbox/RossRCode/Git/SoilDataFederatoRDatabase'
Hosted_dbPath <- paste0(projectRoot, '/DB/SoilDataFederatorDatabase.db3')

source(paste0(projectRoot, '/TERNSoilDBHelpers.R'))

hDB_getPropertiesList <- function( ObserverdProperties=NULL, observedPropertyGroup=NULL){
  
  if(!is.null(observedPropertyGroup)){
    sql <- paste0("select * from Properties where PropertyGroup = '", observedPropertyGroup, "'")
    props <- doHostedQuery(sql)
    ps <- na.omit(props$Property)
   # ps <- na.omit(Properties[str_to_upper(Properties$PropertyGroup)==str_to_upper(observedPropertyGroup), ]$Property )  
  }else{
    bits <- str_split(ObserverdProperties, ';')
    ps <- bits[[1]]
  }
  return(ps)
}


hDB_getProviders <- function(){
  sql <- 'Select Provider from DataSets GROUP BY Provider'
  p <- doHostedQuery(sql)
  return(p)
  
}

hDB_getDatasets <- function(Provider=NULL, verbose=F){
  
  if(verbose){
    fields <- ' * '
  }else{
    fields <- ' Provider, Dataset '
  }
 
  
  if(is.null(Provider)){
      sql <- paste0('Select', fields, 'from DataSets')
      ds <- doHostedQuery(sql)
      return(ds)
  }else{
      sql <- paste0('Select', fields,  'from DataSets where Provider = "', Provider, '"GROUP BY Provider, Dataset')
      ds <- doHostedQuery(sql)
      return(ds)
  }
}

hDB_getSoilData <-function(Provider=NULL,  ObserverdProperties=NULL, observedPropertyGroup=NULL){
  
  
  # if(!is.null(observedPropertyGroup)){
  #     observedPropertyGroup
  #     
  # }else{
  #     bits <- str_split(ObserverdProperties, ';')
  #     ps <- bits[[1]]
  # }
  
  ps <- hDB_getPropertiesList(ObserverdProperties, observedPropertyGroup)
  
  lodfs <- list(length(ps))
  
  if(is.null(Provider)){
    provsql <- ''
  }else{
    provsql <- paste0(" and Provider = '", Provider, "'")
  }
  
  for (i in 1:length(ps)) {
    prop <- ps[i]
    sql <- paste0("select * from ObservedProperties where ObservedProperty = '", prop, "'", provsql)
    outDF <- doHostedQuery(sql)
    oOutDF <- outDF[order(outDF$Observation_ID, outDF$Dataset, outDF$UpperDepth, outDF$SampleID),]
    lodfs[[i]] <- na.omit(oOutDF)
  }
  outDF = as.data.frame(data.table::rbindlist(lodfs))
  return(outDF)
}




blankResponseDF <- function(){
  
  outDF <- na.omit(data.frame(Organisation=NULL, Dataset=character(), Observation_ID=character(), SampleID=character(), Date=character() ,
                              Longitude=numeric() , Latitude= numeric(),
                              UpperDepth=numeric() , LowerDepth=numeric() , PropertyType=character(), ObservedProperty=character(), Value=numeric(),
                              Units= character(), Quality=integer()))
}