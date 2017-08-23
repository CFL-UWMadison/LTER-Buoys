#Get the current met & limno conditions for Mendota from the AOS web service; update the TOA5 file
#for input to RTMC-Pro. 

outFile <- "/triton/BuoyData/ME/ME_TLS_Display_Current.dat"
#outFile <- "ME_TLS_Display_Current.dat"

## Output data frame

library(jsonlite)
library(curl)
library(rLakeAnalyzer)
library(jsonlite,warn.conflicts=FALSE)

options(scipen=999) #This disables scientific notation for values

#aos_met <- fromJSON("http://metobs.ssec.wisc.edu/app/mendota/buoy/data/json?symbols=t:spd:dir");
aos_met <- fromJSON("http://metobs.ssec.wisc.edu/app/mendota/buoy/data/json?symbols=t:rh:spd:dir:do_ppm&begin=-00:03:00");
#aos_limno <- fromJSON("http://metobs.ssec.wisc.edu/app/mendota/buoy/data/json?symbols=wt_0.0:wt_1.0:wt_2.0:wt_3.0:wt_4.0:wt_5.0:wt_6.0:wt_7.0:wt_8.0:wt_9.0:wt_10.0:wt_11.0:wt_12.0:wt_13.0:wt_14.0:wt_15.0:wt_16.0:wt_17.0:wt_18.0:wt_19.0:wt_20.0");


### Function to find average wind direction developed by Misuta
avgWindDir <- function(V) {
  N <- length(V)
  D <- vector()
  D[1] <- V[1]
  for (i in 2:N) {
    delta <- V[i]-D[i-1]
    if (delta < -180) D[i] <- D[i-1]+delta+360
    if (abs(delta) < 180) D[i] <- D[i-1]+delta
    if (delta > 180) D[i] <- D[i-1]+delta-360
    if (delta==180) return(NA)    
  }
  avgDir <- sum(D)/N
  while (avgDir < 0) avgDir <- avgDir+360
  return(avgDir)
}
###


#The call for last five minutes of data result in a length that varies from request to request, so we need to find length
#aos_met$stamps is a character array so we get its size with length()
stampSize <- length(aos_met$stamps)
#aos_met$data is a matrix, so we get its numrows with nrow()
dataSize <- nrow(aos_met$data)

#print(aos_met$data)

timestamp <- aos_met$stamps[stampSize]
#print(timestamp)
tmp <- as.POSIXct(timestamp,tz="GMT")
sampledate <- format(tmp,tz="America/Chicago") #Convert from GMT to Central Time
lakeid <- "ME"
airtemp <- aos_met$data[dataSize,1]
rh <- aos_met$data[dataSize,2]

#Compute weighted mean of windspeed
wt <- c(1:dataSize) #this is a linear weighting vector
windspeed <- round(weighted.mean(aos_met$data[,3],wt),2)
#unweighted mean
#windspeed <- round(mean(aos_met$data[,2]),2)

#Mean wind direction is too complicated -- take the latest value
winddir <- avgWindDir(aos_met$data[,4])
#winddir <- aos_met$data[dataSize,3] 
#print(class(winddir))
if (winddir < 0) winddir = winddir + 360
if (winddir >= 360) winddir = winddir - 360

# Get the gust
windgust <- max(aos_met$data[,3])
if (windgust < windspeed) windgust <- windspeed

##Temp String is online
# watertemp <- aos_limno$data[1,2]; #1m depth
# depth <- 0
# wt <- 0
# for (i in 1:21) {
#   depth[i] <- i-1
#   wt[i] <- aos_limno$data[1,i]
# }
# thermocline_depth <- thermo.depth(wt, depth, seasonal=FALSE)

do_ppm <- aos_met$data[dataSize,5]

##Temp String is offline
watertemp <- NA
thermocline_depth <- NA

### Do QA/QC on values here

if (is.na(as.numeric(airtemp))) {airtemp <- NA} 
if (is.na(as.numeric(windspeed)) || (windspeed < 0)) {windspeed <- NA} 
if (is.na(as.numeric(windgust)) || (windgust < 0)) {windgust <- NA} 
if (is.na(as.numeric(winddir)) || (winddir < 0) || (winddir > 360)) {winddir <- NA} 
if (is.na(as.numeric(watertemp)) || (watertemp < 0) ) {watertemp <- NA} 
if (is.na(as.numeric(thermocline_depth)) || (thermocline_depth < 0) || (is.nan(thermocline_depth)) ) {thermocline_depth <- NA} 
if (is.na(as.numeric(do_ppm))) {do_ppm <- NA} 

### Broken buoy fix
#airtemp <- NA
#windspeed <- NA
#windgust <- NA
#winddir <- 0

### Convert and format
airtemp <- round(32+(airtemp*9/5),digits=0)   #C to F
windspeed <- round(windspeed*2.24,digits=0)          #m/s to mph
windgust <- round(windgust*2.24,digits=0)          #m/s to mph
rh <- round(rh,digits=0)
winddir <- round(winddir,digits=0)
do_ppm <- round(do_ppm,digits=1)


### Write out strings to outFile

line1 <- "\"TOA5\",\"Mendota\",\"CR1000\",\"00000\",\"CR1000.Std.31.03\",\"CPU:FillerJunk-2017-07-17.CR1\",\"2294\",\"ME_Current_Table\""
line2 <- "\"TIMESTAMP\",\"RECORD\",\"Air_Temperature\",\"Wind_Dir\",\"Wind_Speed\",\"Wind_Gust\",\"RH\",\"Water_Temp\",\"DO_PPM\""
line3 <- "\"TS\",\"RN\",\"\",\"\",\"\",\"\",\"\",\"\",\"\""
line4 <- "\"\",\"\",\"Smp\",\"Smp\",\"Smp\",\"Smp\",\"Smp\",\"Smp\",\"Smp\""

dataline <- paste0("\"",sampledate,"\",9999,",airtemp,",",winddir,",",windspeed,",",windgust,",",rh,",,",do_ppm)


 
fileConn<-file(outFile,"w")
writeLines(line1, fileConn)
writeLines(line2, fileConn)
writeLines(line3, fileConn)
writeLines(line4, fileConn)
writeLines(dataline, fileConn)

close(fileConn)
