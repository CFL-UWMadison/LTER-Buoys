# THIS NEEDS WORK - tighten up the value-checking. Integrate Campbell's 7999 value => should set 'D' flag

library(RMySQL)
options(scipen=999) #This disables scientific notation for values

#Process the ME met dat at the end of each day when buoy data in available from AOS. This should run between
#1930-midnight on the relevant day so the correct directory can be found. This also does range-checking.

#Limno data is recorded once per minute
#Met data is recorded every 5 seconds
#There's also a 20 second data offset at the beginning of the day. Limno starts the day at 00:00:00, while met starts at 00:00:20; 

#Only going to do keep 1 minutes samples, with Limno time leading the way; 

### Get current date. When this script runs, UTC is one day ahead so we can just use our current jday.
date <- Sys.Date()
year <- as.character(format(date,"%Y"))
jday <- as.character(format(date,"%j"))  #It's 3-digit char because it will be part of the path
month <- as.numeric(format(date,"%m"))
datestr <- as.character(format(date,"%Y%m%d"))

message(date())

##For testing and single-day processing
#year <- "2017"
#jday <- "114"
message("Processing Mendota met hires: jday=",jday," year=",year)

### Load the range file
rangeFile <- "/triton/BuoyData/range_checks_new.csv"
df.R <- read.csv(rangeFile,header=T,stringsAsFactors=FALSE) #Read header to index the proper row

# Deal with range checking. Create a 12 element (monthly) vector for each parameter. 
# Note: most of these names come directly from the range check file.

MendotaLimnochlorMaxHRes <- as.numeric(df.R[136,month+1])
MendotaLimnochlorMinHRes <- as.numeric(df.R[137,month+1])
MendotaLimnodoptoppmMaxHRes <- as.numeric(df.R[184,month+1])
MendotaLimnodoptoppmMinHRes <- as.numeric(df.R[185,month+1])
MendotaLimnodoptosatMaxHRes <- as.numeric(df.R[186,month+1])
MendotaLimnodoptosatMinHRes <- as.numeric(df.R[187,month+1])
MendotaLimnodoptotempMaxHRes <- as.numeric(df.R[188,month+1])
MendotaLimnodoptotempMinHRes <- as.numeric(df.R[189,month+1])
MendotaLimnophycoMaxHRes <- as.numeric(df.R[192,month+1])
MendotaLimnophycoMinHRes <- as.numeric(df.R[193,month+1])
me_PARMaxHRes <- as.numeric(df.R[190,month+1])
me_PARMinHRes <- as.numeric(df.R[191,month+1])
windDirMax <- 360
windDirMin <- 0
windSpeedMax <- 20
windSpeedMin <- 0

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
nfields <- 32
#Assign field names. These must match the database field names
fields <- c("sampledate","year4", "month", "daynum", "sample_time", "sampletime", "data_freq","air_temp", "flag_air_temp",
  "rel_hum","flag_rel_hum","wind_speed","flag_wind_speed","wind_dir","flag_wind_dir","chlor","flag_chlor","phycocyanin",
  "flag_phycocyanin","opt_wtemp","flag_opt_wtemp","opt_dosat_raw","flag_opt_dosat_raw","opt_do_raw","flag_opt_do_raw",
  "pco2_ppm","flag_pco2_ppm","par","flag_par","par_below","flag_par_below","hr")
# Assign formatting to each field. Strings (%s) get extra single quotes
fmt <- c("'%s'","%.0f","%.0f","%.0f","%s","'%s'","%.0f","%.1f","'%s'",
         "%.2f","'%s'","%.2f","'%s'","%.1f","'%s'","%.0f","'%s'","%.1f",
         "'%s'","%.2f","'%s'","%.2f","'%s'","%.2f","'%s'",
         "%.1f","'%s'","%.1f","'%s'","%.1f","'%s'","%.1f")

### Deal with the input file
#limnofile <- list.files(pattern="MendotaBuoy_limnodata_*.csv")
datapath <- paste0("/opt/data/mendota/",year,"/",jday,"/");
setwd(datapath);
limnofile <- list.files(pattern="*limno*.dat")
metfile <- list.files(pattern="*met*.dat")
message("Running update_ME_met_hires_byday.R")
message("limno file: ",limnofile)
message("met file: ",metfile)

#Met data goes into df.A
#Limno data goes into df.B
nrowsA <- 0
nrowsB <- 0

if (file.exists(metfile)) {
  df.A <- read.csv(metfile,header=F,stringsAsFactors=FALSE)
  nrowsA <- nrow(df.A)
}
if (file.exists(limnofile)) {
  df.B <- read.csv(limnofile,header=F,stringsAsFactors=FALSE)
  nrowsB <- nrow(df.B)
}

#print(nrowsA)
#print(nrowsB)

#A (metdata) and B (limnodata) have different samplerates.
#Will grab a time off the limnodata; Find the first matching hr:mm pair in the metdata. Except for the initial
#minute of data in the file, they should be synced

rowA <- 5  # Will while-loop rowA to find the desired time.  
for (rowB in 5:nrowsB) {
#for (rowB in 5:10) {
  
  utc_limno <- df.B[rowB,1]    
  lt <- as.POSIXct(utc_limno,tz="UTC")
  attributes(lt)$tzone <- "America/Chicago"
  limnoMin <- as.character(format(lt,"%H%M"))
  metMin <- "-1"
  #Now find the first met sample with identical
  while ( (metMin!=limnoMin) && (rowA<=nrowsA) ) {
    utc_met <- df.A[rowA,1]
    mt <- as.POSIXct(utc_met,tz="UTC")
    attributes(mt)$tzone <- "America/Chicago"   
    metMin <- as.character(format(mt,"%H%M"))
    rowA <- rowA+1
  }
  rowA <- rowA-1 #need to backup one.
  
  if (metMin == limnoMin) {
    
    sampledate <- substr(as.character(lt),0,10)
    year4 <- as.numeric(format(lt,"%Y"))    
    month <- as.numeric(format(lt,"%m")) 
    daynum <- as.numeric(format(lt,"%j"))
    hr <- 100*as.numeric(format(lt,"%H"))
    #message("hour ",hr)
    sample_time <- limnoMin
    sampletime <- as.character(format(lt,"%H:%M:%S"))
    data_freq <- 1
        
    #print(sampletime)
    
    #Air Temp
    air_temp <- as.numeric(df.A[rowA,7])
    if (is.blank(air_temp)) {
      air_temp <- NA
      flag_air_temp <- 'C'
    } else {
      flag_air_temp <- NA  #no bound test
    }      
    #Rel Hum
    rel_hum <- as.numeric(df.A[rowA,8])
    if (is.blank(rel_hum)) {
      rel_hum <- NA
      flag_rel_hum <- 'C'
    } else {
      flag_rel_hum <- NA  #no bound test
    }
    #Wind Speed
    wind_speed <- as.numeric(df.A[rowA,5])
    if (is.blank(wind_speed)) {
      wind_speed <- NA
      flag_wind_speed <- 'C'
    } else if ( (wind_speed<windSpeedMin) || (wind_speed>windSpeedMax) ) {
      flag_wind_speed <- 'H'
    } else {
      flag_wind_speed <- NA 
    }    
    #Wind Dir
    wind_dir <- as.numeric(df.A[rowA,6])
    if (is.blank(wind_dir)) {
      wind_dir <- NA
      flag_wind_dir <- 'C'
    } else if ( (wind_dir<windDirMin) || (wind_dir>windDirMax) ) {
      flag_wind_dir <- 'H'
    } else {
      flag_wind_dir <- NA 
    }    
    #Chlor
    chlor <- as.numeric(df.B[rowB,31])
    if (is.blank(chlor)||chlor==0) {
      chlor <- NA  #Make the value NA, not zero
      flag_chlor <- 'C'
    } else if ( (chlor<MendotaLimnochlorMinHRes) || (chlor>MendotaLimnochlorMaxHRes) ) {
      flag_chlor <- 'H'
    } else {
      flag_chlor <- NA 
    }      
    #Phycocyanin
    phycocyanin <- as.numeric(df.B[rowB,32])
    if (is.blank(phycocyanin)) {
      phycocyanin <- NA
      flag_phycocyanin <- 'C'
    } else if ( (phycocyanin<MendotaLimnophycoMinHRes) || (phycocyanin>MendotaLimnophycoMaxHRes) ) {
      flag_phycocyanin <- 'H'
    } else {
      flag_phycocyanin <- NA 
    } 
    #Opto Temp
    opt_wtemp <- as.numeric(df.B[rowB,28])
    if (is.blank(opt_wtemp)) {
      opt_wtemp <- NA
      flag_opt_wtemp <- 'C'
    } else if ( (opt_wtemp<MendotaLimnodoptotempMinHRes) || (opt_wtemp>MendotaLimnodoptotempMaxHRes) ) {
      flag_opt_wtemp <- 'H'
    } else {
      flag_opt_wtemp <- NA 
    } 
    #Opto Sat
    opt_dosat_raw <- as.numeric(df.B[rowB,29])
    if (is.blank(opt_dosat_raw)||opt_dosat_raw<0) {   #2014 data has this as zero when the sensor is inoper.
      opt_dosat_raw <- NA  #Make the value NA, not zero
      flag_opt_dosat_raw <- 'C'
    } else if ( (opt_dosat_raw<MendotaLimnodoptosatMinHRes) || (opt_dosat_raw>MendotaLimnodoptosatMaxHRes) ) {
      flag_opt_dosat_raw <- 'H'
    } else {
      flag_opt_dosat_raw <- NA 
    } 
    #Opto Raw PPM
    opt_do_raw <- as.numeric(df.B[rowB,30])
    if (is.blank(opt_do_raw)||opt_do_raw<0) {  #2014 data has this as zero when the sensor is inoper.
      opt_do_raw <- NA  #Make the value NA, not zero        
      flag_opt_do_raw <- 'C'
    } else if ( (opt_do_raw<MendotaLimnodoptoppmMinHRes) || (opt_do_raw>MendotaLimnodoptoppmMaxHRes) ) {
      flag_opt_do_raw <- 'H'
    } else {
      flag_opt_do_raw <- NA 
    }
    
    #CO2
    pco2_ppm <- as.numeric(df.B[rowB,38])
    if (is.blank(pco2_ppm)||pco2_ppm<0) {  #average
      pco2_ppm <- NA  #Make the value NA, not zero        
      flag_pco2_ppm <- 'C'
    } else {
      flag_pco2_ppm <- NA 
    }
    
    #PAR (above sfc)
    par <- as.numeric(df.B[rowB,39])
    if (is.blank(par)||par<0) {  #1 minute average
      par <- NA  #Make the value NA, not zero        
      flag_par <- 'C'
    } else if ( (par<me_PARMinHRes) || (par>me_PARMaxHRes) ) {
      flag_par <- 'H'
    } else {
      flag_par <- NA 
    }
    
    #PAR (subsurface)
    par_below <- as.numeric(df.B[rowB,40])
    if (is.blank(par_below)||par_below<0) {  #1 minute avg
      par_below <- NA  #Make the value NA, not zero        
      flag_par_below <- 'C'
    } else if ( (par_below<me_PARMinHRes) || (par_below>me_PARMaxHRes) ) {
      flag_par_below <- 'H'
    } else {
      flag_par_below <- NA
    }
        
  } else {
    message("Non-matching Limno ",limnoMin," & Met ",metMin) 
  } 
  
  #message(air_temp," ",flag_air_temp," ",opt_wtemp," ",flag_opt_wtemp)
  
  #INSERT IGNORE is used because often there's a few minutes overlap between days which would otherwise cause
  #primary key overwrite error
  sql <- "INSERT IGNORE INTO sensor_mendota_lake_met_hi_res ("
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
 
  
}#for rowB

dbDisconnect(conn) 
