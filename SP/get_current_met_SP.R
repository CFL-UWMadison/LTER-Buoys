#Read in LATEST.PRN; Generate CSV for table buoy_current_conditions

latestMet <- "SP_LATEST_VAISALA.PRN"
latestWtemp <- "SP_LATEST_WTEMP.PRN"
outputFile <- "sp_current_met.csv"

options(scipen=999) #This disables scientific notation for values

###Create a destination data frame
df.X <- data.frame(sampledate=character(1),
                   lakeid=character(1),
                   airtemp=numeric(1), 
                   watertemp=numeric(1),
                   windspeed=numeric(1),
                   winddir=numeric(1),
                   stringsAsFactors=FALSE)
 #Create a single row like df.B for temporary storage
tempX <- df.X
 #Remove the empty row from df.B
df.X <- df.X[-1,]

### Initially set everything to null
tempX$sampledate <- as.character("")
tempX$airtemp <- as.character("")
tempX$watertemp <- as.character("")
tempX$windspeed <- as.character("")
tempX$winddir <- as.character("")

### Read Inputs
if (file.exists(latestMet) ) {
  
  df.A <- read.csv(latestMet,header=F,stringsAsFactors=FALSE)  
  numRows <- nrow(df.A)
  
  #Convert sampledate to localtime (CDT in summer)
  tmp <- as.POSIXct(df.A[numRows,1],tz="America/Guatemala")
  sampledate <- format(tmp,tz="America/Chicago")
  #sampledate <- df.A[numRows,1]  #timestamp comes in CST (-6)
  airtemp <- df.A[numRows,7]
  windspeed <- df.A[numRows,5]
  winddir <- df.A[numRows,3]
  tempX$sampledate <- sampledate
  tempX$lakeid <- "SP"
  if (!is.na(as.numeric(airtemp))) {tempX$airtemp <- airtemp}
  if (!is.na(as.numeric(windspeed))) {tempX$windspeed <- windspeed}
  if (!is.na(as.numeric(winddir))) {tempX$winddir <- winddir}
}#df.A
if (file.exists(latestWtemp) ) {
  
  df.B <- read.csv(latestWtemp,header=F,stringsAsFactors=FALSE)  
  numRows <- nrow(df.B)
  watertemp <- df.B[numRows,4]  #RBRTempProfile(1)
  if (!is.na(as.numeric(watertemp))) {tempX$watertemp <- watertemp}

}#df

df.X <- rbind(df.X,tempX)
write.table(df.X,file=outputFile,sep=",",col.names=FALSE,append=FALSE,quote=FALSE,row.names=FALSE)


