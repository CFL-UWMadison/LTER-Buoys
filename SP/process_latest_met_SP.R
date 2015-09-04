#Read in LATEST.PRN; Generate CSV for table sensor_sparkling_lake_met_hi_res

latestVaisala <- "SP_LATEST_VAISALA.PRN"
latestLufft <- "SP_LATEST_LUFFT.PRN"
latestDO <- "SP_LATEST_DO.PRN"
latestMisc <- "SP_LATEST_MISC.PRN"

rangeFile <- "range_checks_new.csv"
outputFile <- "sp_latest_met.csv"

### Create a destination data frame for met data
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
                   opt_wtemp=numeric(1),
                   flag_opt_wtemp=character(1),                     
                   opt_dosat_raw=numeric(1),
                   flag_opt_dosat_raw=character(1),                     
                   opt_do_raw=numeric(1),
                   flag_opt_do_raw=character(1),                     
                   wind_dir=numeric(1),
                   flag_wind_dir=character(1),
                   barom_pres_mbar=numeric(1),
                   flag_barom_pres_mbar=character(1),
                   cumulative_precipitation=numeric(1),
                   battery_radio=numeric(1),
                   battery_logger=numeric(1),
                   stringsAsFactors=FALSE)

#Create a single row like df.R for temporary storage
tempX <- df.X  #Permanently empty template.
#Remove the empty row from df.R
df.X <- df.X[-1,]

options(scipen=999) #This disables scientific notation for values

### Load up data files. If Vaisala exists, assume they all exist
if (file.exists(latestVaisala)) {
  
  df.Vaisala <- read.csv(latestVaisala,header=F,stringsAsFactors=FALSE)
  #  
  df.DO <- read.csv(latestDO,header=F,stringsAsFactors=FALSE)
  #
  df.Misc <- read.csv(latestMisc,header=F,stringsAsFactors=FALSE)
  #
  df.Lufft <- read.csv(latestLufft,header=F,stringsAsFactors=FALSE)
  

  ### Load the range file and range check values
  df.R <- read.csv(rangeFile,header=T,stringsAsFactors=FALSE)

  #Get month of first sample (I'm not accounting for date crossover in data)
  lt <- df.Vaisala[1,1]
  sampledate <- as.Date(lt)
  month <- as.numeric(format(sampledate,"%m")) 
  monthStr <- paste("month_",as.character(month),sep="")

  airPressMax <- 1000
  airPressMin <- 900
  windDirMax <- 360
  windDirMin <- 0
  windSpeedMax <- 20.0
  windSpeedMin <- 0
  dOptoPPMMax <- df.R[250,month+1]
  dOptoPPMMin <- df.R[251,month+1]
  dOptoSatMax <- df.R[252,month+1]
  dOptoSatMin <- df.R[253,month+1]
  dOptoTempMax <- df.R[256,month+1]
  dOptoTempMin <- df.R[257,month+1]
  satVapPressMax <- df.R[258,month+1]
  satVapPressMin <- df.R[259,month+1]
  PrecipMax <- df.R[262,month+1]  #not used
  PrecipMin <- df.R[263,month+1]  #not used
  
  
  ###Loop through the records in the PRN file (assume all PRN files have the same length)
  numRows <- nrow(df.Vaisala)
  for (a in 1:numRows) {    
    
    #Re-initialize sensor & flag columns of tempX as null. Values are filled in below only if not null
    for (c in 6:ncol(tempX)) { tempX[1,c] <- as.character("") }
           
    #Enter date and time info
    timeStamp <- df.Vaisala[a,1]
    tempX$sampledate <- timeStamp
    lt <- strptime(timeStamp, tz="America/Chicago", format="%Y-%m-%d %H:%M:%S")  
    tempX$month <- as.numeric(format(lt,"%m"))
    tempX$year4 <- as.numeric(format(lt,"%Y"))
    tempX$daynum <- as.numeric(format(lt,"%j"))
    tempX$sampletime <- as.character(format(lt,"%T"))

  ##Vaisala Table   
    
    #airTemp (7)
    val <- as.numeric(df.Vaisala[a,7])
    if (!is.na(val)) { tempX$air_temp <- val }  

    #relHum (8)
    val <- as.numeric(df.Vaisala[a,8])
    if (!is.na(val)) { tempX$rel_hum <- val }

    #windSpeed (5)
    val <- as.numeric(df.Vaisala[a,5])   
    if (!is.na(val)) {
      tempX$wind_speed_2m <- val
      if ( (val<windSpeedMin) || (val>windSpeedMax) ) { tempX$flag_wind_speed_2m <- "H" } 
    }    
    
    #windDir (3)
    val <- as.numeric(df.Vaisala[a,3])
    if (!is.na(val)) {
      tempX$wind_dir <- val
      if ( (val<windDirMin) || (val>windDirMax) ) { tempX$flag_wind_dir <- "H" }
    }      
    
    #airPress (9)
    val <- as.numeric(df.Vaisala[a,9])
    if (!is.na(val)) {
      tempX$barom_pres_mbar <- val
      if ( (val<airPressMin) || (val>airPressMax) ) { tempX$flag_barom_pres_mbar <- "H" }
    }      
    
    #Precip (10)
    val <- as.numeric(df.Vaisala[a,10])
    if (!is.na(val)&&(val<7999)) { tempX$cumulative_precipitation <- val }

  ## Lufft Table 
  
    #PAR  (9)
    val <- as.numeric(df.Lufft[a,9])
    if (!is.na(val)) { tempX$par <- val }  
  
  ## DO Table    
    
    #dOptoTemp (3)
    val <- as.numeric(df.DO[a,3])
    if (!is.na(val)) {
       tempX$opt_wtemp <- val
       if ( (val<dOptoTempMin) || (val>dOptoTempMax) ) { tempX$flag_opt_wtemp <- "H" }
    }

    #dOptoSat (4)
    val <- as.numeric(df.DO[a,4])  
    if (!is.na(val)) {
      tempX$opt_dosat_raw <- val
      if ( (val<dOptoSatMin) || (val>dOptoSatMax) ) { tempX$flag_opt_dosat_raw <- "H" }
    }    

    #dOptoPPM (5)
    val <- as.numeric(df.DO[a,5])
    if (!is.na(val)) {
      tempX$opt_do_raw <- val
      if ( (val<dOptoPPMMin) || (val>dOptoPPMMax) ) { tempX$flag_opt_do_raw <- "H" }
    }    
        
  ## Misc Table       

    #satVapPress (5)
    val <- as.numeric(df.Misc[a,5])
    if (!is.na(val)) {
      tempX$sat_vapor_pres <- val
      if ( (val<satVapPressMin) || (val>satVapPressMax) ) { tempX$flag_sat_vapor_pres <- "H"}
    }      
       
    #vapPress (6)
    val <- as.numeric(df.Misc[a,6])
    if (!is.na(val)) { tempX$vapor_pres <- val }

    #loggerBatt (3)
    val <- as.numeric(df.Misc[a,3])
    if (!is.na(val)) { tempX$battery_logger <- val }    
    
    #radioBatt (4)
    val <- as.numeric(df.Misc[a,4])
    if (!is.na(val)) { tempX$battery_radio <- val }    
    
    df.X <- rbind(df.X,tempX)
  
  
    #print(a)
  }#for a
  
  if (file.exists(outputFile)) {
    write.table(df.X,file=outputFile,sep=",",col.names=FALSE,append=TRUE,quote=FALSE,row.names=FALSE)
  }
  else {
    write.table(df.X,file=outputFile,sep=",",col.names=TRUE,append=FALSE,quote=FALSE,row.names=FALSE)
  }
  file.remove(latestVaisala)
  file.remove(latestLufft)
  file.remove(latestDO)
  file.remove(latestMisc)
  
  
}#if file exists
