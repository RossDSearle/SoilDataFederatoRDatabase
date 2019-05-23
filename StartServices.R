library(plumber)
library(htmltidy)

deployDir <-'/srv/plumber/TERNLandscapes/SoilDataFederatoRDatabase'

server <- 'http://esoil.io'
portNum <- 8076

r <- plumb(paste0(deployDir, "/apiEndPoints_TERNSoilDB.R"))  
print(r)

options("plumber.host" = "0.0.0.0")
options("plumber.apiHost" = "0.0.0.0")
r$run(host= server, port=portNum, swagger=TRUE)




