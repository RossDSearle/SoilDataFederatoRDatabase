library(plumber)
library(htmltidy)

#deployDir <-'/srv/plumber/TERNLandscapes/SoilDataFederatoRDatabase'

machineName <- as.character(Sys.info()['nodename'])
if(machineName=='soils-discovery'){
  deployDir <<- '/srv/plumber/TERNLandscapes/SoilDataFederatoRDatabase'
  server <- 'http://esoil.io'
}else{
  deployDir <<- 'C:/Users/sea084/Dropbox/RossRCode/Git/TERNLandscapes/APIs/SoilDataFederatoRDatabase'
  server <- 'http://localhost'
}


portNum <- 8076

r <- plumb(paste0(deployDir, "/apiEndPoints_TERNSoilDB.R"))  
print(r)

options("plumber.host" = "0.0.0.0")
options("plumber.apiHost" = "0.0.0.0")
r$run(host= server, port=portNum, swagger=TRUE)







