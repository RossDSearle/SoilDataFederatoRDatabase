library(stringr)
library(RSQLite)
library(DBI)

projectRoot <- 'C:/Users/sea084/Dropbox/RossRCode/Git/SoilDataFederatoRDatabase'
Hosted_dbPath <- paste0(projectRoot, '/DB/SoilDataFederatorDatabase.db3')




doHostedQuery <- function(sql){
  
  conn <- DBI::dbConnect(RSQLite::SQLite(), Hosted_dbPath)
  qry <- dbSendQuery(conn, sql)
  res <- dbFetch(qry)
  dbClearResult(qry)
  dbDisconnect(conn)
  return(res)
}
