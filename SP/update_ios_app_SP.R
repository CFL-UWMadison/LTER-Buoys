#Gets data, calculates hourly averages, and updates table ios_app_me 

 library(jsonlite)
# library(curl)
# library(rLakeAnalyzer)
 library(RMySQL)

options(scipen=999) #This disables scientific notation for values
 
###Set up the destination data frames for resultant data
nfields <- 12 
#Assign field names. These must match the database field names
fields <- c("sampledate","year4","month","daynum","hour","air_temp","rel_hum","wind_speed","wind_dir","chlor","phyco","water_temp")
# Assign formatting to each field. Strings (%s) get extra single quotes
fmt <- c("'%s'","%.0f","%.0f","%.0f","%.0f","%.1f","%.1f","%.1f","%3.0f","%6.0f","%4.0f","%.1f") 
 
 
### Get the data
aos <- fromJSON("http://metobs.ssec.wisc.edu/app/mendota/buoy/data/json?symbols=t:rh:spd:dir:chlor:pc:wt_0.5&begin=-00:60:00")

Stamps <- aos[[2]]  #Contains only the timestamps. The length corresponds to the number of samples
nsamps <- length(Stamps) 
df.Data <- data.frame(aos[[3]])  #Converted to a data frame with nsamps rows and 7 columns


 
timestamp <- Stamps[nsamps]   #Use the last sample time
timestamp <- as.POSIXct(timestamp,tz="GMT")  #make it a POSIXct object
attr(timestamp,"tzone") <- "America/Chicago"    #change the timezone
sampledate <- as.character(format(timestamp,"%Y-%m-%d"))
year4 <- as.numeric(format(timestamp,"%Y"))
month <- as.numeric(format(timestamp,"%m"))
daynum <- as.numeric(format(timestamp,"%j"))  #It's 3-digit char because it will be part of the path
hour <- as.numeric(format(timestamp,"%H"))*100

air_temp <- mean(df.Data[,1])
rel_hum <- mean(df.Data[,2])
wind_speed <- mean(df.Data[,3])
wind_dir <- median(df.Data[,4])
chlor <- mean(df.Data[,5])
phyco <- mean(df.Data[,6])
water_temp <- mean(df.Data[,7])
 
### Update ios_app_me in the database  

#Connect to the database and update table
conn <- dbConnect(MySQL(),dbname="dbmaker", client.flag=CLIENT_MULTI_RESULTS) 

#Develop a SQL command; Update all current fields regardless of whether they have valued entries.
#This code differs from the other lakes because I'm only updating NA fields also.

sql <- "INSERT IGNORE INTO ios_app_me ("
for (i in 1:nfields) { sql <- paste0(sql,fields[i],",") }
sql <- substr(sql,1,nchar(sql)-1)  #remove last comma
sql <- paste0(sql,") VALUES (")
for (i in 1:nfields) { 
  field_value <- sprintf(fmt[i],eval(parse(text=fields[i])))  
  if ( is.na(field_value) || (field_value == "'NA'") || (field_value == "NA") ) { field_value <- 'NULL'}   
  #message(i," ",field_value)
  sql <- paste0(sql,field_value,",")  #valued fields
}  
sql <- substr(sql,1,nchar(sql)-1)  #remove last comma
sql <- paste0(sql,");") 
  
#print(sql)

result <- dbGetQuery(conn,sql)  
dbDisconnect(conn)  

