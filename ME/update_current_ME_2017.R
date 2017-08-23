#Get the current met & limno conditions for Mendota from the AOS web service; update table buoy_current_conditions. 

library(jsonlite)
library(curl)
library(rLakeAnalyzer)
library(RMySQL)
library(jsonlite,warn.conflicts=FALSE)

options(scipen=999) #This disables scientific notation for values

#aos_met <- fromJSON("http://metobs.ssec.wisc.edu/app/mendota/buoy/data/json?symbols=t:spd:dir");
aos_met <- fromJSON("http://metobs.ssec.wisc.edu/app/mendota/buoy/data/json?symbols=t:spd:dir&begin=-00:03:00");
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
airtemp <- aos_met$data[dataSize][1];

#Compute weighted mean of windspeed
wt <- c(1:dataSize) #this is a linear weighting vector
windspeed <- round(weighted.mean(aos_met$data[,2],wt),2)
#unweighted mean
#windspeed <- round(mean(aos_met$data[,2]),2)

#Mean wind direction is too complicated -- take the latest value
winddir <- avgWindDir(aos_met$data[,3])
#winddir <- aos_met$data[dataSize,3] 
#print(class(winddir))
if (winddir < 0) winddir = winddir + 360
if (winddir >= 360) winddir = winddir - 360

# Get the gust
windgust <- max(aos_met$data[,2])
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

### Update buoy_current_conditions in the database  


### Broken buoy fix
#airtemp <- NA
#windspeed <- NA
#windgust <- NA
#winddir <- 0


nfields <- 8 
#Assign field names. These must match the database field names
fields <- c("sampledate","lakeid","airtemp","watertemp","windspeed","windgust","winddir","thermocline_depth")
# Assign formatting to each field. Strings (%s) get extra single quotes
fmt <- c("'%s'","'%s'","%.1f","%.1f","%.1f","%.1f","%3.0f","%.1f")

print("Making the dbconnection");
#Connect to the database and update table
conn <- dbConnect(MySQL(),dbname="dbmaker", client.flag=CLIENT_MULTI_RESULTS) 

#Develop a SQL command; Update all current fields regardless of whether they have valued entries.
#This code differs from the other lakes because I'm only updating NA fields also.
sql <- "update buoy_current_conditions set "
for (i in 1:nfields) {
  field_value <- sprintf(fmt[i],eval(parse(text=fields[i])))
  #message(i," ",field_value)
  #if it's NA, then give it 'NULL' which mysql accepts
  if (is.na(field_value) || (field_value == "NA") ) { field_value <- 'NULL'}   
  sql <- paste0(sql,fields[i],"=",field_value,",")  #valued fields
}
sql <- substr(sql,1,nchar(sql)-1)  #remove last comma
sql <- paste0(sql," where lakeid='ME';")

print(sql)

result <- dbGetQuery(conn,sql)  
dbDisconnect(conn)  

