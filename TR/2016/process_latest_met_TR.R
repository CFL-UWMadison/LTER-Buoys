#Read in LATEST.PRN; Generate CSV for table sensor_trout_lake_met_hi_res

latestFile <- "TR_LATEST.PRN"
rangeFile <- "range_checks_new.csv"
outputFile <- "tr_latest_met.csv"

if (file.exists(latestFile)) {
  
  df.A <- read.csv(latestFile,header=F,stringsAsFactors=FALSE)
  #  
  df.B <- read.csv(rangeFile,header=T,stringsAsFactors=FALSE)
  #
  #Create a destination data frame for met data. The variable names match those in the destination database.
  df.X <- data.frame(sampledate=character(1),
                     year4=numeric(1),
                     month=numeric(1),
                     daynum=numeric(1),
                     sampletime=character(1),
                     data_freq=numeric(1),
                     air_temp=numeric(1),
                     flag_air_temp=character(1),
                     rel_hum=numeric(1),
                     flag_rel_hum=character(1),
                     wind_speed=numeric(1),
                     flag_wind_speed=character(1),
                     wind_dir=numeric(1),
                     flag_wind_dir=character(1),
                     barom_pres_mbar=numeric(1),
                     flag_barom_pres_mbar=character(1),
                     par=numeric(1),
                     flag_par=character(1),
                     opt_wtemp=numeric(1),
                     flag_opt_wtemp=character(1),                     
                     opt_dosat_raw=numeric(1),
                     flag_opt_dosat_raw=character(1),                     
                     opt_do_raw=numeric(1),
                     flag_opt_do_raw=character(1),                                   
                     sat_vapor_pres=numeric(1),
                     flag_sat_vapor_pres=character(1),
                     vapor_pres=numeric(1),
                     flag_vapor_pres=character(1),
                     cumulative_precipitation=numeric(1),
                     cr10_battery=numeric(1),
                     stringsAsFactors=FALSE)
  
  #Create a single row like df.B for temporary storage
  tempX <- df.X  #Permanently empty template.
  #Remove the empty row from df.B
  df.X <- df.X[-1,]
  
  options(scipen=999) #This disables scientific notation for values
  
  ###Load range check values
  #Get month of first sample (not accounting for date crossover in data)
  lt <- df.A[1,1]
  sampledate <- as.Date(lt)
  month <- as.numeric(format(sampledate,"%m")) 
  monthStr <- paste("month_",as.character(month),sep="")
  
  #There really aren't good Trout Lake one. Using SP numbers.
  airPressMax <- 1000
  airPressMin <- 900
  windDirMax <- 360
  windDirMin <- 0
  windSpeedMax <- 20.0
  windSpeedMin <- 0
  dOptoPPMMax <- df.B[250,month+1]
  dOptoPPMMin <- df.B[251,month+1]
  dOptoSatMax <- df.B[252,month+1]
  dOptoSatMin <- df.B[253,month+1]
  dOptoTempMax <- df.B[256,month+1]
  dOptoTempMin <- df.B[257,month+1]
  satVapPressMax <- df.B[258,month+1]
  satVapPressMin <- df.B[259,month+1]
  PrecipMax <- df.B[262,month+1]  #not used
  PrecipMin <- df.B[263,month+1]  #not used
  
  ###Loop through the records in the PRN file
  numRows <- nrow(df.A)
  for (a in 1:numRows) {    
    
    #Re-initialize sensor &flag columns of tempX as null. Values are filled in below only if not null
    for (c in 6:ncol(tempX)) { tempX[1,c] <- as.character("") }
           
    #Enter date and time info
    timeStamp <- df.A[a,1]
    tempX$sampledate <- timeStamp
    lt <- strptime(timeStamp, tz="America/Chicago", format="%Y-%m-%d %H:%M:%S")  
    tempX$month <- as.numeric(format(lt,"%m"))
    tempX$year4 <- as.numeric(format(lt,"%Y"))
    tempX$daynum <- as.numeric(format(lt,"%j"))
    tempX$sampletime <- as.character(format(lt,"%T"))
    tempX$data_freq <- 1
    
    #airTemp (3)
    val <- as.numeric(df.A[a,3])
    if (!is.na(val)) { tempX$air_temp <- val }  

    #relHum (4)
    val <- as.numeric(df.A[a,4])
    if (!is.na(val)) { tempX$rel_hum <- val }
     
    #dOptoTemp (30)
    val <- as.numeric(df.A[a,30])
    if (!is.na(val)) {
       tempX$opt_wtemp <- val
       if ( (val<dOptoTempMin) || (val>dOptoTempMax) ) { tempX$flag_opt_wtemp <- "H" }
    }

    #dOptoSat (31)
    val <- as.numeric(df.A[a,31])  
    if (!is.na(val)) {
      tempX$opt_dosat_raw <- val
      if ( (val<dOptoSatMin) || (val>dOptoSatMax) ) { tempX$flag_opt_dosat_raw <- "H" }
    }    

    #dOptoPPM (32)
    val <- as.numeric(df.A[a,32])
    if (!is.na(val)) {
      tempX$opt_do_raw <- val
      if ( (val<dOptoPPMMin) || (val>dOptoPPMMax) ) { tempX$flag_opt_do_raw <- "H" }
    }    
        
    #windSpeed (33)
    val <- as.numeric(df.A[a,33])   
    if (!is.na(val)) {
      tempX$wind_speed <- val
      if ( (val<windSpeedMin) || (val>windSpeedMax) ) { tempX$flag_wind_speed <- "H" } 
    }    
    
    #windDir (34)
    val <- as.numeric(df.A[a,34])
    if (!is.na(val)) {
      tempX$wind_dir <- val
      if ( (val<windDirMin) || (val>windDirMax) ) { tempX$flag_wind_dir <- "H" }
    }      
        
    #airPress (35)
    val <- as.numeric(df.A[a,35])
    if (!is.na(val)) {
      tempX$barom_pres_mbar <- val
      if ( (val<airPressMin) || (val>airPressMax) ) { tempX$flag_barom_pres_mbar <- "H" }
    }      
        
    #PAR (36)
    val <- as.numeric(df.A[a,36])
    if (!is.na(val)) { tempX$par <- val }

    #satVapPress (37)
    val <- as.numeric(df.A[a,37])
    if (!is.na(val)) {
      tempX$sat_vapor_pres <- val
      if ( (val<satVapPressMin) || (val>satVapPressMax) ) { tempX$flag_sat_vapor_pres <- "H"}
    }      
       
    #vapPress (38)
    val <- as.numeric(df.A[a,38])
    if (!is.na(val)) { tempX$vapor_pres <- val }
        
    #precipVaisala (39)
    val <- as.numeric(df.A[a,39])
    if (!is.na(val)&&(val<7999)) { tempX$cumulative_precipitation <- val }

    #loggerBatt (40)
    val <- as.numeric(df.A[a,40])
    if (!is.na(val)) { tempX$cr10_battery <- val }    
       
    df.X <- rbind(df.X,tempX)
  }#for a
  
  if (file.exists(outputFile)) {
    write.table(df.X,file=outputFile,sep=",",col.names=FALSE,append=TRUE,quote=FALSE,row.names=FALSE)
  }
  else {
    write.table(df.X,file=outputFile,sep=",",col.names=TRUE,append=FALSE,quote=FALSE,row.names=FALSE)
  }
  #file.remove(latestFile)
}#if file exists
