#Read winter buoy data files and insert into a single CSV file.

outputFile <- "winter_hires_test.csv"
options(scipen=999) #This disables scientific notation for values

#Loop through all of the files in the file directory
fileList <- list.files(path="C:/Buoys//Winter Buoys/ToMark", pattern="*.TXT", full.names=TRUE)
numFiles <- length(fileList)

for (f in 1:numFiles) {

  #Create a destination data frame
  df.X <- data.frame(sampledate=character(1),
                     year4=numeric(1),
                     month=numeric(1),
                     daynum=numeric(1),
                     depth=numeric(1),
                     sampletime=character(1),
                     depth=numeric(1),
                     wtemp=numeric(1),
                     flag_wtemp=character(1),
                     data_freq=numeric(1),
                     unk_watertemp=numeric(1),
                     stringsAsFactors=FALSE)
  #Create a single row like df.B for temporary storage
  tempX <- df.X
  #Remove the empty row from df.B
  df.X <- df.X[-1,]    
  
  #Open the file and count the lines
  file <- file(fileList[f],open="r") 
  #print(file)
  content <- readLines(file)
  numLines <- length(content)
  
  #Skip all the header lines and find where the data begins
  i <- 1;
  while( content[i] != "DATA BEGINS") {
    i <- i+1
  }
  #print(content[i])
  
  
  #The next line contains field names, extract those althrough they might not be used
  i <- i+1
  fieldNames <- unlist(strsplit(content[i],","))
  numHeights <- (length(fieldNames)-3)/2
  
  #Skip three lines which contain things other than data;
  i <- i+3
  
  #Get the unknown values that may be related to calibration. We'll keep those.
  line <- unlist(strsplit(content[i],","))
  unkData <- line
  
  i <- i+2
  #Loop line to numLines
  while (i <= numLines) {
    line <- unlist(strsplit(content[i],","))
    value <- as.numeric(line[1])
    
    #Get the date and time stuff. From unix time to a proper code of CDT
    unixTime <- as.numeric(line[1]) #unix time
    cdtTime <- unixTime - (6*3600) #Want -6:00 regardless of daylight savings
    local <- as.POSIXct(cdtTime, tz="UTC", origin="1970-01-01") 
    localstr <- strtrim(local,20)
    year4 <- as.numeric(format(local,"%Y"))
    month <- as.numeric(format(local,"%m"))
    daynum <- as.numeric(format(local,"%j"))
    sampletime <- as.character(format(local,"%T"))
    
  
    #loop the heights
    for (d in 1:numHeights) {
      
        #compute the depth from height
        temp <- as.numeric(line[d*2+2])
        height <- as.numeric(line[d*2+3])
        depth <- 
      
        tempX$sampledate <- localstr
        tempX$year4 <- year4
        tempX$month <- month         
        tempX$daynum <- daynum
        tempX$sampletime <- sampletime
        tempX$depth <- depth
        tempX$wtemp <- temp
        tempX$flag_wtemp <- "W"
        tempX$data_freq <- 1
        df.X <- rbind(df.X,tempX)    
    }#for d

    i <- i+1
  }#while
  
  write.table(df.X,file=outputFile,sep=",",col.names=FALSE,append=TRUE,quote=FALSE,row.names=FALSE) 
  close(file)
}#for f