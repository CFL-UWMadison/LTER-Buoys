#Read in LATEST.PRN; Generate CSV for table buoy_current_conditions

latestFile <- "SP_LATEST.PRN"
outputFile <- "sp_current.csv"

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
  
  sampledate <- df.A[numRows,1]
  airtemp <- df.A[numRows,3]
  watertemp <- df.A[numRows,5]
  windspeed <- df.A[numRows,36]
  winddir <- df.A[numRows,37]
  
  tempX$sampledate <- sampledate
  tempX$lakeid <- "SP"
  if (!is.nan(as.numeric(airtemp))) {tempX$airtemp <- airtemp} else {tempX$airtemp = as.character("")} 
  if (!is.nan(as.numeric(watertemp))) {tempX$watertemp <- watertemp} else {tempX$watertemp = as.character("")}
  if (!is.nan(as.numeric(windspeed))) {tempX$windspeed <- windspeed} else {tempX$windspeed = as.character("")}
  if (!is.nan(as.numeric(winddir))) {tempX$winddir <- winddir} else {tempX$winddir = as.character("")}
  
  df.X <- rbind(df.X,tempX)
  
  write.table(df.X,file=outputFile,sep=",",col.names=FALSE,append=FALSE,quote=FALSE,row.names=FALSE)

} else {
  #print("Input File doesn't exist")
}
