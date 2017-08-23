#Read in LATEST.PRN; Generate CSV for table sensor_trout_lake_russ_watertemp_hi_res

latestFile <- "TR_LATEST.PRN"
outputFile <- "tr_latest_limno.csv"

if (file.exists(latestFile)) {
  
  df.A <- read.csv(latestFile,header=F,stringsAsFactors=FALSE)
  
  #Create a destination data frame for met data. The variable names match those in the destination database.
  df.X <- data.frame(sampledate=character(1),
                     year4=numeric(1),
                     month=numeric(1),
                     daynum=numeric(1),
                     sampletime=character(1),
                     depth=numeric(1),
                     wtemp=numeric(1),
                     flag_wtemp=character(1),                    
                     stringsAsFactors=FALSE)
  
  #Create a single row like df.B for temporary storage
  tempX <- df.X  #Permanently empty template.
  #Remove the empty row from df.B
  df.X <- df.X[-1,]
  
  options(scipen=999) #This disables scientific notation for values
  
  ###Simplifying range checks
  waterTempMax <- 50
  waterTempMin <- 0
  
  numDepths <- 25
  ###Loop through the records in the PRN file
  numRows <- 1
  numRows <- nrow(df.A)
  for (a in 1:numRows) {  

    #Enter date and time info
    timeStamp <- df.A[a,1]
    tempX$sampledate <- timeStamp
    lt <- strptime(timeStamp, tz="America/Chicago", format="%Y-%m-%d %H:%M:%S")  
    tempX$month <- as.numeric(format(lt,"%m"))
    tempX$year4 <- as.numeric(format(lt,"%Y"))
    tempX$daynum <- as.numeric(format(lt,"%j"))
    tempX$sampletime <- as.character(format(lt,"%T"))    
    
    #Loop the depths, which are all contained in one record
    for (d in 1:numDepths) {
      
      tempX$depth <- switch(d,0,0.25,0.5,0.75,1,1.5,2,2.5,3,3.5,4,5,6,7,8,9,10,11,12,13,14,16,20,25,30)
    
      #Re-initialize sensor & flag columns of tempX as null. Values are filled in below only if not null
      tempX$wtemp <- as.character("")
      tempX$flag_wtemp <- as.character("")
      
      val <- as.numeric(df.A[a,d+4])

      if (!is.na(val)) {
        tempX$wtemp <- val
        if ( (val<waterTempMin) || (val>waterTempMax) ) { tempX$flag_wtemp <- "H"}
      } else {
        tempX$flag_wtemp <- "C"
      }
      df.X <- rbind(df.X,tempX)
      
    }#for d    
  }#for a
  
  if (file.exists(outputFile)) {
    write.table(df.X,file=outputFile,sep=",",col.names=FALSE,append=TRUE,quote=FALSE,row.names=FALSE)
  }
  else {
    write.table(df.X,file=outputFile,sep=",",col.names=TRUE,append=FALSE,quote=FALSE,row.names=FALSE)
  }
  file.remove(latestFile)
}#if file exists
