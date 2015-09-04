# Open latest day of Mendota limno data and calculate average phyco. Estimate secchi and
# upload result to buoy_current_conditions.
# This has to run before midnight (server time) to catch the correct directory and file name

library(RMySQL)

# Get current date. When this script runs, UTC is one day ahead so we can just use our current jday.
date <- Sys.Date()
year <- as.character(format(date,"%Y"))
jday <- as.character(format(date,"%j"))  #It's char because it will be part of the path
datestr <- as.character(format(date,"%Y%m%d"))

#for testing:
#jday <- 175

path <- paste0("/opt/data/mendota/",year,"/",jday,"/");
limnofile <- paste0(path,"MendotaBuoy_limnodata_",datestr,".dat")

#for testing
#limnofile <- "MendotaBuoy_limnodata_20150623.dat"
#limnofile <- "/opt/data/mendota/2015/175/MendotaBuoy_limnodata_20150624.dat"

if (file.exists(limnofile)) {
  df.A <- read.csv(limnofile,header=F,stringsAsFactors=FALSE)
  nrowsA <- nrow(df.A)
  
  #Get sampledata off of last record, convert to Central Time
  utc <- df.A[nrowsA,1]  
  lt <- as.POSIXct(utc,tz="UTC")
  attributes(lt)$tzone <- "America/Chicago"
  sampledate <- substr(as.character(lt),0,20)
  
  
  ### Get Data
  phycoSamps <- 0  #sample Counter
  Phyco <- 0       #data array
  chlorSamps <- 0  #sample Counter
  Chlor <- 0       #data array
  
  for (r in 5:nrowsA) {
    
    c <- as.numeric(df.A[r,31])
    p <- as.numeric(df.A[r,32])
    
    if (  (c<5000)&&(c>0) ) {
      chlorSamps <- chlorSamps + 1
      Chlor[chlorSamps] <- c
    }
    if (  (p<5000)&&(p>0) ) {
      phycoSamps <- phycoSamps + 1
      Phyco[phycoSamps] <- p
    }        
  }#for r
  
  phyco_avg <- mean(Phyco)
  phyco_median <- median(Phyco)
  chlor_avg <- mean(Chlor)
  chlor_median <- median(Chlor)
 
  ###Algorithm 
  if (phyco_median <= 1750) {
      secchi_est <- (1/(0.282 + (0.0004275*phyco_median)))
  } else {
      secchi_est <- NA
  }
  
  ### Upload to buoy_current_conditions in both dbmaker and deims_ntl

  conn <- dbConnect(MySQL(),dbname="dbmaker", client.flag=CLIENT_MULTI_RESULTS) 
  #table: buoy_current_conditions;  fields: sampledate,lakeid,secchi_est,phyco_median

  ###Develop SQL command
  sql <- paste0("update buoy_current_conditions set ")
  if (!is.na(secchi_est)) {
    sql <- paste0(sql,"secchi_est= ",as.character(secchi_est))
  } else {
    sql <- paste0(sql,"secchi_est=NULL")
  }    
  sql <- paste0(sql," ,phyco_median=",as.character(phyco_median))
  sql <- paste0(sql," where lakeid='ME'")
    
  result <- dbGetQuery(conn,sql)  
  dbDisconnect(conn)  
  
  #Update the record in deims_ntl.buoy_current_conditions also
  conn <- dbConnect(MySQL(),dbname="deims_ntl", client.flag=CLIENT_MULTI_RESULTS) 
  #table: buoy_current_conditions;  fields: sampledate,lakeid,secchi_est,phyco_median
  result <- dbGetQuery(conn,sql)  
  dbDisconnect(conn)  
  
  
}#if file exists

