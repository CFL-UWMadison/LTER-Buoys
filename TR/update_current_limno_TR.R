#Update the table buoy_current_conditions for Trout Lake for one field - thermocline_depth
library(RMySQL)

currentFile <- "/triton/BuoyData/tr_current_limno.csv"

if (file.exists(currentFile)) {
  
  df.A <- read.csv(currentFile,header=F,stringsAsFactors=FALSE)
  #timestamp,lakeid,airtemp,watertemp,windspeed,winddir
  
  nfields <- 3  
  
  ###Assign field names. These must match the database field names
  fields <- c("sampledate","lakeid","thermocline_depth")
  ### Assign formatting to each field. Strings (%s) get extra single quotes
  fmt <- c("'%s'","'%s'","%.2f")

  ### Assign local variables, must use the same name as database field
  sampledate <- df.A[1,1]
  lakeid <- df.A[1,2]
  thermocline_depth <- df.A[1,3]

  if ( is.numeric(thermocline_depth) && !is.na(thermocline_depth) ) {
  
    ###Update the current record, run this after met is added. 
    conn <- dbConnect(MySQL(),dbname="dbmaker", client.flag=CLIENT_MULTI_RESULTS) 
    
    ###Develop the SQL command
    sql <- "update buoy_current_conditions set thermocline_depth="
    tdstr <- sprintf("%.2f",thermocline_depth);
    sql <- paste0(sql,tdstr," where lakeid='",lakeid,"';")
    #print(sql)

    result <- dbGetQuery(conn,sql)  
    dbDisconnect(conn)  
  }#if

}
