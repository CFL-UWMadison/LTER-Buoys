#Read in LATEST.PRN; Generate CSV for table sensor_trout_lake_met_hi_res

latestLufft <- "TR_LATEST_LUFFT.PRN"
latestVaisala <- "TR_LATEST_VAISALA.PRN"
latestVaporPres <- "TR_LATEST_VAPORPRES.PRN"
latestYSI <- "TR_LATEST_YSI.PRN"
latestProMini <- "TR_LATEST_PROMINI.PRN"
latesteosGP <- "TR_LATEST_EOSGP.PRN"

rangeFile <- "range_checks_new.csv"
outputFile <- "tr_latest_met.csv"


## Below is a dummy process that allows the write.table functions at the bottom of the script
## to operate. I don't know why it works that way.
dumfile <- "aaa.csv"
df.A <- read.csv(latestProMini,header=F,stringsAsFactors=FALSE)
write.table(df.A,file=dumfile,sep=",",col.names=FALSE,append=FALSE,quote=FALSE,row.names=FALSE)


if (file.exists(latestLufft)) {
  
  
  df.L <- read.csv(latestLufft,header=F,stringsAsFactors=FALSE)
  df.VS <- read.csv(latestVaisala,header=F,stringsAsFactors=FALSE)
  df.VP <- read.csv(latestVaporPres,header=F,stringsAsFactors=FALSE)
  df.Y <- read.csv(latestYSI,header=F,stringsAsFactors=FALSE)
  df.PM <- read.csv(latestProMini,header=F,stringsAsFactors=FALSE)
  df.GP <- read.csv(latesteosGP,header=F,stringsAsFactors=FALSE)
 
  
  #  
  df.R <- read.csv(rangeFile,header=T,stringsAsFactors=FALSE)
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
 
                     ysi_temp=numeric(1),
                     flag_ysi_temp=character(1),
                     ysi_spcond=numeric(1),
                     flag_ysi_spcond=character(1),                                        
                     ysi_dosat=numeric(1),
                     flag_ysi_dosat=character(1),                     
                     ysi_do=numeric(1),
                     flag_ysi_do=character(1),
                     
                     sat_vapor_pres=numeric(1),
                     flag_sat_vapor_pres=character(1),
                     vapor_pres=numeric(1),
                     flag_vapor_pres=character(1),
                     
                     promini_co2_corr=numeric(1),
                     flag_promini_co2_corr=character(1), 
                     promini_co2_bptemp=numeric(1),
                     flag_promini_co2_bptemp=character(1),  
                     promini_co2_bp=numeric(1),
                     flag_promini_co2_bp=character(1),                     
                     
                     gp_co2_conc=numeric(1),
                     flag_gp_co2_conc=character(1), 
                     gp_co2_temp=numeric(1),
                     flag_gp_co2_temp=character(1),
                     
                     
                     cumulative_precipitation=numeric(1),
                     stringsAsFactors=FALSE)
  
  #Create a single row like df.R for temporary storage
  tempX <- df.X  #Permanently empty template.
  #Remove the empty row from df.R
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
  
  
  ###Loop through the records in the PRN file
  numRows <- nrow(df.L)
  for (a in 1:numRows) {    
  #for (a in 1:10) {  
    
    #Re-initialize sensor &flag columns of tempX as null. Values are filled in below only if not null
    for (c in 6:ncol(tempX)) { tempX[1,c] <- as.character("") }
           
    #Enter date and time info
    timeStamp <- df.L[a,1]
    tempX$sampledate <- timeStamp
    lt <- strptime(timeStamp, tz="America/Chicago", format="%Y-%m-%d %H:%M:%S")  
    tempX$month <- as.numeric(format(lt,"%m"))
    tempX$year4 <- as.numeric(format(lt,"%Y"))
    tempX$daynum <- as.numeric(format(lt,"%j"))
    tempX$sampletime <- as.character(format(lt,"%T"))
    tempX$data_freq <- 1
    
    #air_temp (L2)
    val <- as.numeric(df.L[a,2])
    if (!is.na(val)) { tempX$air_temp <- val }  

    #relHum (L3)
    val <- as.numeric(df.L[a,3])
    if (!is.na(val)) { tempX$rel_hum <- val }
    
    #airPress (L4)
    val <- as.numeric(df.L[a,4])
    if (!is.na(val)) {
      tempX$barom_pres_mbar <- val
      if ( (val<airPressMin) || (val>airPressMax) ) { tempX$flag_barom_pres_mbar <- "H" }
    }       
    
    #windSpeed (L5)
    val <- as.numeric(df.L[a,5])   
    if (!is.na(val)) {
      tempX$wind_speed <- val
      if ( (val<windSpeedMin) || (val>windSpeedMax) ) { tempX$flag_wind_speed <- "H" } 
    }    
    
    #windDir (L7)
    val <- as.numeric(df.L[a,7])
    if (!is.na(val)) {
      tempX$wind_dir <- val
      if ( (val<windDirMin) || (val>windDirMax) ) { tempX$flag_wind_dir <- "H" }
    }          
    
    #satVapPress (VP2)
    val <- as.numeric(df.VP[a,2])
    if (!is.na(val)) {
      tempX$sat_vapor_pres <- val
      if ( (val<satVapPressMin) || (val>satVapPressMax) ) { tempX$flag_sat_vapor_pres <- "H"}
    }      
    
    #vapPress (VP3)
    val <- as.numeric(df.VP[a,3])
    if (!is.na(val))  tempX$vapor_pres <- val 
    #message(tempX$vapor_pres)
                         
    #ysi_temp (Y2)
    val <- as.numeric(df.Y[a,2])
    if (!is.na(val)) {
       tempX$ysi_temp <- val
       if ( (val<dOptoTempMin) || (val>dOptoTempMax) ) { tempX$flag_ysi_temp <- "H" }
    }

    #ysi_spcond (Y3)
    val <- as.numeric(df.Y[a,3])  
    if (!is.na(val)) tempX$ysi_spcond <- val
   
    #ysi_dosat (Y5)
    val <- as.numeric(df.Y[a,5])
    if (!is.na(val)) {
      tempX$ysi_dosat <- val
      if ( (val<dOptoSatMin) || (val>dOptoSatMax) ) { tempX$flag_ysi_dosat <- "H" }
    }
  
    #ysi_do (Y6)
    val <- as.numeric(df.Y[a,6])
    if (!is.na(val)) {
      tempX$ysi_do <- val
      if ( (val<dOptoPPMMin) || (val>dOptoPPMMax) ) { tempX$flag_ysi_do <- "H" }
    }          
  
    #PAR (L8)
    val <- as.numeric(df.L[a,8])
    if (!is.na(val)) { tempX$par <- val }
    
    #promini_co2_corr (PM 2)
    val <- as.numeric(df.PM[a,2])
    if (!is.na(val)) { tempX$promini_co2_corr <- val }
    flag_promini_co2_corr <- ""
    
    #promini_co2_bptemp (PM 3)
    val <- as.numeric(df.PM[a,3])
    if (!is.na(val)) { tempX$promini_co2_bptemp <- val }
    flag_promini_co2_bptemp <- ""

    #promini_co2_bp (PM 4)
    val <- as.numeric(df.PM[a,4])
    if (!is.na(val)) { tempX$promini_co2_bp <- val }
    flag_promini_co2_bp <- ""

    
    #gp_co2_conc (GP 2)
    val <- as.numeric(df.GP[a,2])
    if (!is.na(val)) { tempX$gp_co2_conc <- val }
    flag_gp_co2_conc <- ""
    
    #gp_co2_temp (GP 3)
    val <- as.numeric(df.GP[a,3])
    if (!is.na(val)) { tempX$gp_co2_temp <- val }
    flag_gp_co2_temp <- ""
    
    #precipVaisala (VS9)
    val <- as.numeric(df.VS[a,9])
    if (!is.na(val)&&(val<7999)) { tempX$cumulative_precipitation <- val }
       
    df.X <- rbind(df.X,tempX)
  }#for a
   
  
  if (file.exists(outputFile)) {
    write.table(df.X,file=outputFile,sep=",",col.names=FALSE,append=TRUE,quote=FALSE,row.names=FALSE) 
  }
  else {
    write.table(df.X,file=outputFile,sep=",",col.names=TRUE,append=FALSE,quote=FALSE,row.names=FALSE)
  }
  
  file.remove(latestLufft)
  file.remove(latestVaisala)
  file.remove(latestVaporPres)
  file.remove(latestYSI)
  file.remove(latestProMini)
  file.remove(latesteosGP) 

}#if file exists
