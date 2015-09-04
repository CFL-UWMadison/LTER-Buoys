#Read in LATEST.PRN; Generate CSV of thermocline estimate for table buoy_current_conditions
library(rLakeAnalyzer)

latestFile <- "SP_LATEST_WTEMP.PRN"
outputFile <- "sp_current_limno.csv"

if (file.exists(latestFile)) {
  
  #  print("File Exists")
  df.A <- read.csv(latestFile,header=F,stringsAsFactors=FALSE)
  #timestamp,record,airtemp,batt
  
  #Create a destination data frame
  df.X <- data.frame(sampledate=character(1),
                     lakeid=character(1),
                     thermocline=numeric(1),
                     stringsAsFactors=FALSE)
  #Create a single row like df.B for temporary storage
  tempX <- df.X
  #Remove the empty row from df.B
  df.X <- df.X[-1,]
  
  options(scipen=999) #This disables scientific notation for values
  
  numRows <- nrow(df.A)
  
  #This is all Trout Lake specific
  #Convert sampledate to local (CDT in summer)
  tmp <- as.POSIXct(df.A[numRows,1],tz="America/Guatemala")
  sampledate <- format(tmp,tz="America/Chicago")
  tempX$sampledate <- sampledate
  tempX$lakeid <- "SP"


  depths <- c(0,0.25,0.5,0.75,1,1.25,1.5,2,2.5,3,3.5,4,4.5,5,6,7,8,9,10,11,12,13,14,16,18)
  numdepths <- 25
  wtemp <- 0
  badDataFlag <- FALSE 
  for (i in 1:numdepths) {
    wt <- df.A[numRows,i+2]
    if (!is.na(wt)) {wtemp[i] <- wt} else {badDataFlag <- TRUE} 
  }
  
  if (badDataFlag == FALSE) {
    tempX$thermocline <- thermo.depth(wtemp, depths, seasonal=FALSE)
  } else {
    tempX$thermocline <- as.character("")
  }
  
  
  #print(depths)
  #print(wtemp)
  
  
  df.X <- rbind(df.X,tempX)
  
  write.table(df.X,file=outputFile,sep=",",col.names=FALSE,append=FALSE,quote=FALSE,row.names=FALSE)
  
} else {
  #print("Input File doesn't exist")
}

