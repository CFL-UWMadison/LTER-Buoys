#Update the table buoy_current_conditions for Trout Lake 

library(RMySQL)

currentMet <- "/triton/BuoyData/TR/tr_current_met.csv"
currentLimno <- "/triton/BuoyData/TR/tr_current_limno.csv"

if ( file.exists(currentMet) && file.exists(currentLimno) ) {
  
  message(date()," Trout current met & limno exist and will now be processed")
  
  df.A <- read.csv(currentMet,header=F,stringsAsFactors=FALSE)
  #timestamp,lakeid,airtemp,watertemp,windspeed,winddir
  df.B <- read.csv(currentLimno,header=F,stringsAsFactors=FALSE)
  #timestamp,lakeid,thermocline_depth
  
  nfields <- 9  
  
  ###Assign field names. These must match the database field names
  fields <- c("sampledate","lakeid","airtemp","watertemp","windspeed","windgust","winddir","lakename","thermocline_depth")
  ### Assign formatting to each field. Strings (%s) get extra single quotes
  fmt <- c("'%s'","'%s'","%.1f","%.1f","%.1f","%.1f","%.1f","'%s'","%.1f")

  ### Assign local variables, must use the same name as database field
  sampledate <- df.A[1,1]
  lakeid <- df.A[1,2]
  airtemp <- df.A[1,3]
  windspeed <- df.A[1,4]
  windgust <- df.A[1,5]
  winddir <- df.A[1,6]
  lakename = "Trout Lake"
  watertemp <- df.B[1,3]
  thermocline_depth <- df.B[1,4]

  ###Create the mask that says which fields have valued entries
  mask<-0  
  for (i in 1:nfields) {
    if (is.na(eval(parse(text=fields[i])))) {mask[i]<-0} else {mask[i]<-1}
  }
 
  ###Delete the old record
  conn <- dbConnect(MySQL(),dbname="dbmaker", client.flag=CLIENT_MULTI_RESULTS) 
  sql <- sprintf("delete from buoy_current_conditions where lakeid='%s'",lakeid)
  result <- dbGetQuery(conn,sql)

  ###Develop a SQL command
  sql <- "insert into buoy_current_conditions ("
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
  #print(sql)
  result <- dbGetQuery(conn,sql)  
  dbDisconnect(conn)  
  message("Updating current_TR completed ",date()," ",sampledate," ",airtemp)

} else {
  message(date()," Error running update_current_TR.R : Trout current met and/or limno DO NOT exist")
}

