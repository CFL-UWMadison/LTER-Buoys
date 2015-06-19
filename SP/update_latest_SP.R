#Update the table sensor_sparkling_lake_met_hi_res for Sparkling Lake
library(RMySQL)

latestFile <- "/triton/BuoyData/sp_latest_met.csv"

if (file.exists(latestFile)) {
  
  df.A <- read.csv(latestFile,header=T,stringsAsFactors=FALSE)
  nrecords <- nrow(df.A)
  #nrecords <- 1
  
  nfields <- 31  
  
  ###Assign field names. These must match the database field names
  fields <- c("sampledate","year4","month","daynum","sampletime","air_temp","flag_air_temp","rel_hum","flag_rel_hum",
              "wind_speed_2m","flag_wind_speed_2m","sat_vapor_pres","flag_sat_vapor_pres","vapor_pres","flag_vapor_pres",
              "par","flag_par","opt_wtemp","flag_opt_wtemp","opt_dosat_raw","flag_opt_dosat_raw","opt_do_raw","flag_opt_do_raw",
              "wind_dir","flag_wind_dir","barom_pres_mbar","flag_barom_pres_mbar","cumulative_precipitation",
              "battery_logger","battery_radio","data_freq")
  ### Assign formatting to each field. Strings (%s) get extra single quotes
  fmt <- c("'%s'","%.0f","%.0f","%.0f","'%s'","%.3f","'%s'","%.1f","'%s'",
           "%.3f","'%s'","%.3f","'%s'","%.3f","'%s'",
           "%.3f","'%s'","%.2f","'%s'","%.2f","'%s'","%.2f","'%s'",
           "%.2f","'%s'","%.0f","'%s'","%.2f","%.3f","%.3f","%.0f")

  
  ###Connect to the database
  conn <- dbConnect(MySQL(),dbname="dbmaker", client.flag=CLIENT_MULTI_RESULTS)   
  
  ### Assign local variables, must use the same name as database field
  for (r in 1:nrecords) {
    sampledate <- df.A[r,1]
    year4 <- df.A[r,2]
    month <- df.A[r,3]
    daynum <- df.A[r,4]
    sampletime <- df.A[r,5]
    air_temp <- df.A[r,6]
    flag_air_temp <- df.A[r,7]
    rel_hum <- df.A[r,8]
    flag_rel_hum <- df.A[r,9]
    wind_speed_2m <- df.A[r,10]
    flag_wind_speed_2m <- df.A[r,11]
    sat_vapor_pres <- df.A[r,12]
    flag_sat_vapor_pres <- df.A[r,13]
    vapor_pres <- df.A[r,14]
    flag_vapor_pres <- df.A[r,15]
    par <- df.A[r,16]
    flag_par <- df.A[r,17]
    opt_wtemp <- df.A[r,18]
    flag_opt_wtemp <- df.A[r,19]
    opt_dosat_raw <- df.A[r,20]
    flag_opt_dosat_raw <- df.A[r,21]
    opt_do_raw <- df.A[r,22]
    flag_opt_do_raw <- df.A[r,23]
    wind_dir <- df.A[r,24]
    flag_wind_dir <- df.A[r,25]
    barom_pres_mbar <- df.A[r,26]
    flag_barom_pres_mbar <- df.A[r,27]
    cumulative_precipitation <- df.A[r,28]
    battery_logger <- df.A[r,29]
    battery_radio <- df.A[r,30]
    data_freq <- 1

    ###Create the mask that says which field have valued entries
    mask<-0  
    for (i in 1:nfields) {
      value <- eval(parse(text=fields[i]))
      if ( is.na(value) || (value=="")) {mask[i]<-0} else {mask[i]<-1}
    }
      
    ###Develop a SQL command
    sql <- "insert ignore into sensor_sparkling_lake_met_hi_res ("
    for (i in 1:nfields) {
      if (mask[i]) { sql <- paste(sql,fields[i],",",sep="") }  #valued fields
    }
    sql <- substr(sql,1,nchar(sql)-1)  #remove last comma and extend
    sql <- paste(sql,") values (",sep="")
    for (i in 1:nfields) {
      if (mask[i]) { sql <- paste(sql,fmt[i],",",sep="") }     #add fmts of valued fields
    }
    sql <- substr(sql,1,nchar(sql)-1) #remove last comma and close
    sql <- paste(sql,")",sep="") 
  
  
    ###Build a string of the sprintf function. This puts values into fields.
    scmd <- "sprintf(sql,"
    for (i in 1:nfields) {
     if (mask[i]) { scmd <- paste(scmd,fields[i],",",sep="") } #field values
    }
    scmd <- substr(scmd,1,nchar(scmd)-1) #remove last comma and clean up
    scmd <- paste(scmd,")",sep="") 
    #print(scmd)
  
    ###Get the SQL command back by parsing
    sql <- eval(parse(text=scmd))
    #sql <- paste(sql,"IGNORE",sep=" ")
    #print(sql)
    result <- dbGetQuery(conn,sql)  
    
  }#for
  
  ###Disconnect from the database
  dbDisconnect(conn) 
}#if
