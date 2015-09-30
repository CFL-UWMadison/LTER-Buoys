#Update the table buoy_current_conditions for Sparkling Lake
library(RMySQL)

currentFile <- "/triton/BuoyData/me_current.csv"
#currentFile <- "me_current.csv"

if (file.exists(currentFile)) {
  

  df.A <- read.csv(currentFile,header=F,stringsAsFactors=FALSE)
  #timestamp,lakeid,airtemp,watertemp,windspeed,winddir
  
  nfields <- 7 
  
  ###Assign field names. These must match the database field names
  fields <- c("sampledate","lakeid","airtemp","watertemp","windspeed","winddir","thermocline_depth")
  ### Assign formatting to each field. Strings (%s) get extra single quotes
  fmt <- c("'%s'","'%s'","%.1f","%.1f","%.1f","%3.0f","%.1f")

  ### Assign local variables, must use the same name as database field
  sampledate <- df.A[1,1]
  lakeid <- df.A[1,2]
  airtemp <- df.A[1,3]
  watertemp <- df.A[1,4]
  windspeed <- df.A[1,5]
  winddir <- df.A[1,6]
  thermocline_depth <- df.A[1,7]


  ###Connect to the database
  conn <- dbConnect(MySQL(),dbname="dbmaker", client.flag=CLIENT_MULTI_RESULTS) 

  ###Develop a SQL command; Update all current fields regardless of whether they have valued entries.
  sql <- "update buoy_current_conditions set "
  for (i in 1:nfields) {
    sql <- paste0(sql,fields[i],"=",sprintf(fmt[i],eval(parse(text=fields[i]))),",")  #valued fields
  }
  sql <- substr(sql,1,nchar(sql)-1)  #remove last comma
  sql <- paste0(sql," where lakeid='ME';")
  
  #print(sql)

  result <- dbGetQuery(conn,sql)  
  dbDisconnect(conn)  

}
