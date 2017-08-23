#Read in LATEST.PRN; Generate CSV of thermocline estimate for table buoy_current_conditions
library(rLakeAnalyzer)

latestFile <- "TR_LATEST_WTEMP.PRN"
outputFile <- "tr_current_limno.csv"

if (file.exists(latestFile)) {
  
  #  print("File Exists")
  df.A <- read.csv(latestFile,header=F,stringsAsFactors=FALSE)
  #timestamp,record,airtemp,batt
  
  #Create a destination data frame
  df.X <- data.frame(sampledate=character(1),
                     lakeid=character(1),
                     wtemp=numeric(1),
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
  sampledate <- format(tmp,tz="America/Chicago") #use in summer
  #sampledate <- format(tmp,tz="America/New_York") #use in fall
  #sampledate <- df.A[numRows,1]
  tempX$sampledate <- sampledate
  tempX$lakeid <- "TR"

  depths <- c(0,0.25,0.5,0.75,1,1.5,2,2.5,3,3.5,4,5,6,7,8,9,10,11,12,13,14,16,20,25,30)
  numdepths <- 25
  wtemp <- 0
  badDataFlag <- FALSE 
  for (i in 1:numdepths) {
    wt <- df.A[numRows,i+1]
    if (!is.na(wt)) {wtemp[i] <- wt} else {badDataFlag <- TRUE} 
  }
  tempX$wtemp <- wtemp[3] #0.5 meter depth 
  
  
  if (badDataFlag == FALSE) {
    tempX$thermocline <- round(thermo.depth(wtemp, depths, seasonal=TRUE),digits=1)
  } else {
    tempX$thermocline <- as.character("")
  }
    
  df.X <- rbind(df.X,tempX)
  
  write.table(df.X,file=outputFile,sep=",",col.names=FALSE,append=FALSE,quote=FALSE,row.names=FALSE)
  
} else {
  #print("Input File doesn't exist")
}

