#Get the current met & limno conditions from Mendota; Write to a CSV files to be used to update buoy_current_conditions
library(jsonlite)
library(curl)
library(rLakeAnalyzer)

### TEMP STRING IS OFFLINE - Limno values are commented out.

outputFile <- "/triton/BuoyData/me_current.csv"

aos_met <- fromJSON("http://metobs.ssec.wisc.edu/app/mendota/buoy/data/json?symbols=t:spd:dir");
#aos_limno <- fromJSON("http://metobs.ssec.wisc.edu/app/mendota/buoy/data/json?symbols=wt_0.0:wt_1.0:wt_2.0:wt_3.0:wt_4.0:wt_5.0:wt_6.0:wt_7.0:wt_8.0:wt_9.0:wt_10.0:wt_11.0:wt_12.0:wt_13.0:wt_14.0:wt_15.0:wt_16.0:wt_17.0:wt_18.0:wt_19.0:wt_20.0");

#Create a destination data frame
df.X <- data.frame(sampledate=character(1),
                   lakeid=character(1),
                   airtemp=numeric(1), 
                   watertemp=numeric(1),
                   windspeed=numeric(1),
                   winddir=numeric(1),
                   thermocline_depth=numeric(1),
                   stringsAsFactors=FALSE)
#Create a single row like df.B for temporary storage (this is redundant for single row outputs)
tempX <- df.X
#Remove the empty row from df.B
df.X <- df.X[-1,]

options(scipen=999) #This disables scientific notation for values

timestamp <- aos_met$stamps[1]
#print(timestamp)
tmp <- as.POSIXct(timestamp,tz="GMT")
tempX$sampledate <- format(tmp,tz="America/Chicago") #Convert from GMT to Central Time

airtemp <- aos_met$data[1][1];
windspeed <- aos_met$data[1,2];
winddir <- aos_met$data[1,3];

##Temp String is offline
#watertemp <- aos_limno$data[1,2]; #1m depth
watertemp <- ""

depth <- 0
wt <- 0
for (i in 1:21) {
    depth[i] <- i-1
    wt[i] <- aos_limno$data[1,i]
}

##Temp string is offline
#thermocline_depth <- thermo.depth(wt, depth, seasonal=FALSE)
thermocline_depth <- ""

tempX$lakeid <- "ME"
if (!is.na(as.numeric(airtemp))) {tempX$airtemp <- airtemp} else {tempX$airtemp <- as.character("")} 
if (!is.na(as.numeric(windspeed))) {tempX$windspeed <- windspeed} else {tempX$windspeed <- as.character("")}
if (!is.na(as.numeric(winddir))) {tempX$winddir <- winddir} else {tempX$winddir <- as.character("")}
if (!is.na(as.numeric(watertemp))) {tempX$watertemp <- watertemp} else {tempX$watertemp <- as.character("")}
if (!is.na(as.numeric(thermocline_depth))) {tempX$thermocline_depth <- thermocline_depth} else {tempX$thermocline_depth <- as.character("")}  
df.X <- rbind(df.X,tempX)
  
write.table(df.X,file=outputFile,sep=",",col.names=FALSE,append=FALSE,quote=FALSE,row.names=FALSE)


