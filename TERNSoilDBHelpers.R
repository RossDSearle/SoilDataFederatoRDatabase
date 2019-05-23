library(stringr)
library(RSQLite)
library(DBI)


doHostedQuery <- function(sql){
  
  conn <- DBI::dbConnect(RSQLite::SQLite(), Hosted_dbPath)
  qry <- dbSendQuery(conn, sql)
  res <- dbFetch(qry)
  dbClearResult(qry)
  dbDisconnect(conn)
  return(res)
}
