#Read in LATEST.PRN; Generate CSV for table sensor_sparkling_lake_met_hi_res

latestFile <- "SP_LATEST_0.PRN"
rangeFile <- "range_checks_new.csv"
outputFile <- "sp_met_latest_0.csv"

if (file.exists(latestFile)) {
  
  df.A <- read.csv(latestFile,header=F,stringsAsFactors=FALSE)
  #
  
  df.B <- read.csv(rangeFile,header=T,stringsAsFactors=FALSE)
  #

  #Create a destination data frame for met data
  df.X <- data.frame(sampledate=character(1),
                     year4=numeric(1),
                     month=numeric(1),
                     daynum=numeric(1),
                     sampletime=character(1),
                     air_temp=numeric(1),
                     flag_air_temp=character(1),
                     rel_hum=numeric(1),
                     flag_rel_hum=character(1),
                     wind_speed_2m=numeric(1),
                     flag_wind_speed_2m=character(1),
                     sat_vapor_pres=numeric(1),
                     flag_sat_vapor_pres=character(1),
                     vapor_pres=numeric(1),
                     flag_vapor_pres=character(1),
                     par=numeric(1),
                     flag_par=character(1),
                     tot_precip=numeric(1),
                     flag_tot_precip=character(1),                                     
                     opt_wtemp=numeric(1),
                     opt_dosat_raw=numeric(1),
                     opt_do_raw=numeric(1),
                     flag_opt_wtemp=character(1),
                     flag_opt_dosat_raw=character(1),
                     flag_opt_do_raw=character(1),                     
                     wind_dir=numeric(1),
                     flag_wind_dir=character(1),
                     barom_pres=numeric(1),
                     flag_barom_pres=character(1),
                     cumulative_precipitation=numeric(1),
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
  
  numRows <- nrow(df.A)
  #numRows <- 2
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
    
    #airTemp (3)
    val <- as.numeric(df.A[a,3])
    if (!is.nan(val)) { tempX$air_temp <- df.A[a,3] }  

    #relHum (4)
    val <- as.numeric(df.A[a,4])
    if (!is.nan(val)) { tempX$rel_hum <- df.A[a,4] }
     
    #dOptoTemp (33)
    val <- as.numeric(df.A[a,33])
    if (!is.nan(val)) {
       tempX$opt_wtemp <- val
       if ( (val<dOptoTempMin) || (val>dOptoTempMax) ) { tempX$flag_opt_wtemp <- "H" }
    }

    #dOptoSat (34)
    val <- as.numeric(df.A[a,34])  
    if (!is.nan(val)) {
      tempX$opt_dosat_raw <- val
      if ( (val<dOptoSatMin) || (val>dOptoSatMax) ) { tempX$flag_opt_dosat_raw <- "H" }
    }    

    #dOptoPPM (35)
    val <- as.numeric(df.A[a,35])
    if (!is.nan(val)) {
      tempX$opt_do_raw <- val
      if ( (val<dOptoPPMMin) || (val>dOptoPPMMax) ) { tempX$flag_opt_do_raw <- "H" }
    }    
        
    #windSpeed (36)
    val <- as.numeric(df.A[a,36])   
    if (!is.nan(val)) {
      tempX$wind_speed_2m <- val
      if ( (val<windSpeedMin) || (val>windSpeedMax) ) { tempX$flag_wind_speed_2m <- "H" } 
    }    
    

    #windDir (37)
    val <- as.numeric(df.A[a,37])
    if (!is.nan(val)) {
      tempX$wind_dir <- val
      if ( (val<windDirMin) || (val>windDirMax) ) { tempX$flag_wind_dir <- "H" }
    }      
        
    #airPress (38)
    val <- as.numeric(df.A[a,38])
    if (!is.nan(val)) {
      tempX$barom_pres <- val
      if ( (val<airPressMin) || (val>airPressMax) ) { tempX$flag_barom_pres <- "H" }
    }      
        
    #PAR (39)
    val <- as.numeric(df.A[a,39])
    if (!is.nan(val)) { tempX$par <- df.A[a,39] }


    #satVapPress (40)
    val <- as.numeric(df.A[a,40])
    if (!is.nan(val)) {
      tempX$sat_vapor_pres <- val
      if ( (val<satVapPressMin) || (val>satVapPressMax) ) { tempX$flag_sat_vapor_pres <- "H"}
    }      
       
    #vapPress (41)
    val <- as.numeric(df.A[a,41])
    if (!is.nan(val)) { tempX$vapor_pres <- df.A[a,41] }
        
    #cumP (42)
    val <- as.numeric(df.A[a,42])
    if (!is.nan(val)&&(val<7999)) { 
       tempX$cumulative_precipitation <- df.A[a,42] }
    
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
