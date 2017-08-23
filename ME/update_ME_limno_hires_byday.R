# THIS NEEDS WORK - tighten up the value-checking. Integrate Campbell's 7999 value => should set 'D' flag

library(RMySQL)
options(scipen=999) #This disables scientific notation for values

#Process the ME limno dat at the end of each day when buoy data in available from AOS. This should run between
#1930-midnight on the relevant day so the correct directory can be found. This also does range-checking.

#Limno data is recorded once per minute


### Get current date. When this script runs, UTC is one day ahead so we can just use our current jday.
date <- Sys.Date()
year <- as.character(format(date,"%Y"))
jday <- as.character(format(date,"%j"))  #It's 3-digit char because it will be part of the path
month <- as.numeric(format(date,"%m"))
datestr <- as.character(format(date,"%Y%m%d"))
#message(date())

##For testing and single-day processing:
#year <- "2017"
#jday <- "114"
message("Processing Mendota watertemp hires for: jday=",jday," year=",year)

### Load from the range-checking file
#rangeFile <- "../range_checks_new.csv"
rangeFile <- "/triton/BuoyData/range_checks_new.csv"
df.R <- read.csv(rangeFile,header=T,stringsAsFactors=FALSE) #Read header to index the proper row

#Create two matrices to hold min/max range values; rows are thermistor number (depth) and cols are month
minRange <- matrix(nrow=23,ncol=12)
maxRange <- matrix(nrow=23,ncol=12)

for (row in 1:23) {
  for (mo in 1:12) {
     maxRange[row,mo] <- df.R[2*(row-1)+138,mo+1]        
     minRange[row,mo] <- df.R[2*(row-1)+139,mo+1]
  }#mo  
}#row

### Functions
# Check for blank data
is.blank <- function(var) {
  if (  is.na(var)||is.null(var)||is.nan(var)||(var=="NAN")||(var=="")||(var==" ")||(var==7999)) return (TRUE)
  else return (FALSE)
}
# #check val
# check.val <- function(var) {  
#}

### Set up the database connection and sql query parameters
conn <- dbConnect(MySQL(),dbname="dbmaker", client.flag=CLIENT_MULTI_RESULTS) 
#table: sensor_mendota_lake_met_hi_res
nfields <- 11
#Assign field names. These must match the database field names
fields <- c("sampledate","year4", "month", "daynum", "sample_time", "sampletime","data_freq","depth","wtemp","flag_wtemp","hr")
# Assign formatting to each field. Strings (%s) get extra single quotes
fmt <- c("'%s'","%.0f","%.0f","%.0f","'%s'","'%s'","%.0f","%.2f","%.2f","'%s'","%.0f")

### Deal with the input file
#limnofile <- list.files(pattern="MendotaBuoy_limnodata_*.csv")
datapath <- paste0("/opt/data/mendota/",year,"/",jday,"/");
setwd(datapath);
limnofile <- list.files(pattern="*limno*.dat")
message("Running update_ME_limno_hires_byday.R")
message("limno file: ",limnofile)

#Limno data goes into df.B
if (file.exists(limnofile)) {
  df.B <- read.csv(limnofile,header=F,stringsAsFactors=FALSE)
  nrowsB <- nrow(df.B)
}

depthMap <- c(0,0.5,1,1.5,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20)

for (rowB in 5:nrowsB) {
# for (rowB in 5:10) {
  
  utc_limno <- df.B[rowB,1]    
  lt <- as.POSIXct(utc_limno,tz="UTC")
  attributes(lt)$tzone <- "America/Chicago"
    
  sampledate <- substr(as.character(lt),0,10)
  year4 <- as.numeric(format(lt,"%Y"))    
  month <- as.numeric(format(lt,"%m")) 
  daynum <- as.numeric(format(lt,"%j"))
  hr <- 100*as.numeric(format(lt,"%H"))
  sample_time <- as.character(format(lt,"%H%M"))
  sampletime <- as.character(format(lt,"%H:%M:%S"))
  data_freq <- 1
  
  for (therm in 1:23) {
     
    #Temp (index to first temp is 5)    
    wtemp <- as.numeric(df.B[rowB,therm+4])
    if (is.blank(wtemp)||wtemp<0) {
      wtemp <- NA  #Make the value NA, not zero
      flag_wtemp <- 'C'
    } else if ( (wtemp<minRange[therm,month]) || (wtemp>maxRange[therm,month]) ) {
      flag_wtemp <- 'H'
    } else {
      flag_wtemp <- NA 
    }     
    depth <- depthMap[therm]
    
    sql <- "INSERT IGNORE INTO sensor_mendota_lake_watertemp_hi_res ("
    for (i in 1:nfields) { sql <- paste0(sql,fields[i],",") }
    sql <- substr(sql,1,nchar(sql)-1)  #remove last comma
    sql <- paste0(sql,") VALUES (")
    for (i in 1:nfields) { 
      field_value <- sprintf(fmt[i],eval(parse(text=fields[i])))  
      if ( is.na(field_value) || (field_value == "'NA'") || (field_value == "NA") ) { field_value <- 'NULL'}   
      #message(i," ",field_value)
      sql <- paste0(sql,field_value,",")  #valued fields
    }  
    sql <- substr(sql,1,nchar(sql)-1)  #remove last comma
    sql <- paste0(sql,");")
  
  #print(sql) 
    result <- dbGetQuery(conn,sql)
  
  }#for therm
  
}#for rowB

dbDisconnect(conn) 
