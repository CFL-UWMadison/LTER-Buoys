#Read in LATEST.PRN; Generate CSV for table buoy_current_conditions

latestFile <- "TR_LATEST.PRN"
outputFile <- "tr_current_met.csv"

if (file.exists(latestFile)) {
  
#  print("File Exists")
  df.A <- read.csv(latestFile,header=F,stringsAsFactors=FALSE)
  #timestamp,record,airtemp,batt
  
  #Create a destination data frame
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
  
  options(scipen=999) #This disables scientific notation for values
  
  numRows <- nrow(df.A)
  
  #Trout Lake specific
  #Convert sampledate to local (CDT in summer)
  tmp <- as.POSIXct(df.A[numRows,1],tz="America/Guatemala")
  #sampledate <- format(tmp,tz="America/Chicago") #Use this in summer
  #Add an extra hour in fall since the datalogger subracts an hour
  sampledate <- format(tmp,tz="America/New_YorK") #Use this in fall
  #sampledate <- df.A[numRows,1]  #timestamp comes in CST (-6)
  
  watertemp <- df.A[numRows,42]
  #Vaisala
  #airtemp <- df.A[numRows,3]
  #windspeed <- df.A[numRows,33]
  #winddir <- df.A[numRows,34]
  #Lufft
  airtemp <- df.A[numRows,3]
  windspeed <- df.A[numRows,33]
  winddir <- df.A[numRows,34]  
  
  tempX$sampledate <- sampledate
  tempX$lakeid <- "TR"
  if (!is.na(as.numeric(airtemp))) {tempX$airtemp <- airtemp} else {tempX$airtemp <- as.character("")} 
  if (!is.na(as.numeric(watertemp))) {tempX$watertemp <- watertemp} else {tempX$watertemp <- as.character("")}
  if (!is.na(as.numeric(windspeed))) {tempX$windspeed <- windspeed} else {tempX$windspeed <- as.character("")}
  if (!is.na(as.numeric(winddir))) {tempX$winddir <- winddir} else {tempX$winddir <- as.character("")}
  
  df.X <- rbind(df.X,tempX)
  
  write.table(df.X,file=outputFile,sep=",",col.names=FALSE,append=FALSE,quote=FALSE,row.names=FALSE)

} else {
  #print("Input File doesn't exist")
}
