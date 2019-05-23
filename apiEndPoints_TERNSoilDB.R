library(htmlTable)


machineName <- as.character(Sys.info()['nodename'])
if(machineName=='soils-discovery'){
  projectRoot <<- '/srv/plumber/TERNLandscapes/SoilDataFederatoRDatabase'
}else{
  projectRoot <<- 'C:/Users/sea084/Dropbox/RossRCode/Git/TERNLandscapes/SoilDataFederatoRDatabase'
}


source(paste0(projectRoot, '/TERNSoilDB_API.R'))
#source(paste0(projectRoot, '/functions.R'))

#* @apiTitle TERN Landscapes Soil Database API
#* @apiDescription An API for accessing soil data hosted by TERN Landscapes. We provide a home for orphaned soil data sets, that nobody else wants to look after. It might not be much of a home, but at least our orphans have food and a cozy bed. 


#* @apiTag TERNSoilsDB An API to query the TERN Soils Database


#' Log system time, request method and HTTP user agent of the incoming request
#' @filter logger
function(req){



  logentry <- paste0(as.character(Sys.time()), ",",
       machineName, ",",
       req$REQUEST_METHOD, req$PATH_INFO, ",",
       str_replace_all( req$HTTP_USER_AGENT, ",", ""), ",",
       req$QUERY_STRING, ",",
       req$REMOTE_ADDR
      )

  dt <- format(Sys.time(), "%d-%m-%Y")

  logDir <- paste0(projectRoot, "/Logs")
  if(!dir.exists(logDir)){
     dir.create(logDir, recursive = T)
    }

  logfile <- paste0(projectRoot, "/Logs/NSSC_API_logs_", dt, ".csv")
  if(file.exists(logfile)){
    cat(logentry, '\n', file=logfile, append=T)
  }else{
    hdr <- paste0('System_time,Server,Request_method,HTTP_user_agent,QUERY_STRING,REMOTE_ADDR\n')
    cat(hdr, file=logfile, append=F)
    cat(logentry, '\n', file=logfile, append=T)
  }

  plumber::forward()
}





#* Returns Soil Property data

#* @param format (Optional) format of the response to return. Either json, csv, or xml. Default = json
#* @param observedPropertyGroup (Required) A code specifying the group of soil observed properties to query.
#* @param observedProperty (Required) The soil property code.



#* @get /TERNSoilDB/SoilData
#* @tag TERNSoilsDB
apiGetTERNSoilDB_SoilData<- function(res, usr='Public', pwd='Public', providers=NULL, observedProperty=NULL, observedPropertyGroup=NULL, format='json'){

tryCatch({

  print(paste0('Providers = ', providers))
        DF <- hDB_getSoilData(providers, observedProperty, observedPropertyGroup)
         label <- 'SoilProperty'
         resp <- cerealize(DF, label, format, res)
         return(resp)
  }, error = function(res)
  {
    print(geterrmessage())
    res$status <- 400
    list(error=jsonlite::unbox(geterrmessage()))
  })
}




#* List of available Data Providers
#* @param format (Optional) format of the response to return. Either json, csv, or xml. Default = json

#* @get /TERNSoilDB/Providers
#* @tag TERNSoilsDB
apiGetTERNSoilDB_GetProviders <- function( res, format='json'){

  tryCatch({

    DF <-hDB_getProviders()
    label <- 'DataProvider'
    resp <- cerealize(DF, label, format, res)

    return(resp)

  }, error = function()
  {
    print(geterrmessage())
    res$status <- 400
    list(error=jsonlite::unbox(geterrmessage()))
  })
}






#* List of available Datasets
#* @param verbose (Optional) return just the dataset name or the dataset name and Provider. Default = T
#* @param format (Optional) format of the response to return. Either json, csv, or xml. Default = json

#* @get /TERNSoilDB/DataSets
#* @tag TERNSoilsDB
apiGetTERNSoilDB_GetDatasets <- function( res, verbose=F, format='json'){
  
  tryCatch({
    
    DF <-hDB_getDatasets(verbose)
    label <- 'DataSets'
    resp <- cerealize(DF, label, format, res)
    
    return(resp)
    
  }, error = function()
  {
    print(geterrmessage())
    res$status <- 400
    list(error=jsonlite::unbox(geterrmessage()))
  })
}








#######     Some utilities    ###########################



cerealize <- function(DF, label, format, res){
  
  
  if(format == 'xml'){
   
    res$setHeader("Content-Type", "application/xml; charset=utf-8")
    xmlT <- writexml(DF, label)
    res$body <- xmlT
    return(res)
    
  }else if(format == 'csv'){
    res$setHeader("content-disposition", paste0("attachment; filename=", label, ".csv"));
    res$setHeader("Content-Type", "application/csv; charset=utf-8")
    res$body <- writecsv(DF)
    return(res)
    
  }else if(format == 'html'){
    res$setHeader("Content-Type", "text/html ; charset=utf-8")
    res$body <- htmlTable(DF, align = "l", align.header = "l", caption = label)
    return(res)
    
  }else{
    return(DF)
  }
  
  
}



writecsv <- function(DF){

  tc <- textConnection("value_str2", open="w")
   write.table(DF, textConnection("value_str2", open="w"), sep=",", row.names=F, col.names=T)
   value_str2 <- paste0(get("value_str2"), collapse="\n")
   close(tc)
   return(value_str2)

}

writexml <- function(df, label){
  
  o <- apply(df, 1, DataFrameToXmlwriter, label)
  s <- unlist(o)
  xml <- paste( s, collapse = '')
  xml2 <- str_replace_all(paste0('<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>\n<', label, 'Records>\n', xml, '</', label, 'Records>'), '&', '')

  
  #cat(xml2, file='c:/temp/x.xml')
  return(xml2)
}

DataFrameToXmlwriter <- function(x, label){

  v <- paste0('<', label, 'Record>')
  for (i in 1:length(names(x))) {
    v <- paste0(v, '<', names(x)[i], '>', x[i], '</', names(x)[i], '> ')
  }  
  v <- paste0(v,'</', label, 'Record>\n')
  return(v)
}

