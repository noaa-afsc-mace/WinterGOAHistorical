#get the interval data for a given ship, survey, data_Set_id, and then assign each interval to a report number to get the region names

get_event_and_interval_data_function_winterhistorical = function(ship, survey, data_set_id, analysis_id, report_num = NULL){

  ####
  #start by getting the intervals and the report numbers
  #added a clause for old data - 'AND a.transect is not null AND a.interval is not null ',

  #get the interval locations query; also return the report_number and interval_width associated with
  #each interval
  interval_query = paste0('SELECT a.ship, a.survey, a.transect, a.interval, a.start_time, a.end_time,  ', 
                          'a.start_latitude, a.start_longitude, a.end_latitude, a.end_longitude, ',
                          'a.end_vessel_log, a.length, a.mean_bottom_depth, b.report_number, b.interval_width, c.description ',
                          'FROM macebase2.intervals a LEFT JOIN macebase2.interval_analysis_map b ',
                          'ON (a.ship = b.ship) and (a.survey = b.survey) and (a.data_set_id = b.data_set_id) ',
                          'AND (a.interval = b.interval) ',
                          'LEFT JOIN macebase2.report_definitions c ',
                          'ON (b.ship = c.ship) AND (b.survey = c.survey) AND (b.data_set_id = c.data_set_id) ',
                          'AND (b.analysis_id = c.analysis_id) AND (b.report_number = c.report_number) ',
                          'WHERE a.ship = ', ship, " ",
                          'AND a.survey = ', survey, " ",
                          'AND a.data_set_id = ', data_set_id, " ",
                          'AND a.transect is not null and b.report_number is not null ',
                          paste('AND b.analysis_id IN (',paste(analysis_id, collapse = ','), ') '),
                          'ORDER BY a.interval ')
  
  #and fetch from database
  intervals_data = dbGetQuery(db, interval_query)

  # make sure the time is formatted as UTC
  intervals_data$START_TIME = force_tz(intervals_data$START_TIME, tzone = 'UTC')
  intervals_data$END_TIME = force_tz(intervals_data$END_TIME, tzone = 'UTC')
  
  #get rid of lats/longs that are '999.00' for start AND end positions
  intervals_data = intervals_data%>%
    filter(START_LATITUDE != 999)
  
  #If we included report number in the function call, filter for it. This is for the historical EBS data 
  
  if (is.null(c(report_num)) == FALSE){
    print("testing2!")
    
    if (!(is.numeric(report_num))) {
    report_num= scan(text = report_num, sep = ",")
    intervals_data = intervals_data%>%
      filter(REPORT_NUMBER %in% c(report_num))
    }else{
      intervals_data = intervals_data%>%
        filter(REPORT_NUMBER %in% c(report_num))
    }
  }
  

  
  #add an index for year- this is based on survey naming conventions having the year in first 4 numbers of survey
  intervals_data$year = as.numeric(substr(intervals_data$SURVEY, 1,4))
  
  #define interval locations as the center of the interval when possible; 
  #there are cases where we only have a start or end position; in these cases take whatever is available
  
  #in old surveys- there may not be an end latitude; in this case set as 999 so we know not to use this in calculating midpoints
  intervals_data$END_LATITUDE = replace_na(intervals_data$END_LATITUDE, 999)
  intervals_data$END_LONGITUDE = replace_na(intervals_data$END_LONGITUDE, 999)
  
  intervals_data$lat = ifelse(!(intervals_data$START_LATITUDE == 999) & !(intervals_data$END_LATITUDE == 999),
                              (intervals_data$START_LATITUDE + intervals_data$END_LATITUDE)/2,
                                ifelse(intervals_data$START_LATITUDE == 999, intervals_data$END_LATITUDE, intervals_data$START_LATITUDE))
  
  intervals_data$lon = ifelse(!(intervals_data$START_LONGITUDE == 999) & !(intervals_data$END_LONGITUDE == 999),
                              (intervals_data$START_LONGITUDE + intervals_data$END_LONGITUDE)/2,
                              ifelse(intervals_data$START_LONGITUDE == 999, intervals_data$END_LONGITUDE, intervals_data$START_LONGITUDE))
  
  intervals_data = intervals_data[!(intervals_data$START_LATITUDE == 90.00000 & intervals_data$START_LONGITUDE == -180.0000),]
  
  intervals_data = intervals_data[!(intervals_data$SURVEY == 200301 & intervals_data$TRANSECT == 2 & intervals_data$INTERVAL %in% c(852, 853)),]
  
  #make the intervals into sf objects; this uses WGS1984 as that's the standard for GPS data (and we're using GPS data here)
  intervals_data = st_as_sf(intervals_data, coords = c('lon', 'lat'), crs = 4326, remove = FALSE)
  
  #project them as with the base map layers
  intervals_data = st_transform(intervals_data, crs = st_crs(ak_land))
  

  #start here- commenting for testing
# 
#   #also add an index to identify which management region the interval is located in; use a spatial join to get the
#   #information from the management regions polygons, and then from the SCA.
  intervals_data = intervals_data%>%
    st_join(management_regions, join = st_within)%>%
    st_join(winterpolygons, join = st_within)%>%
    #rename REP_AREA to something more descriptive
    rename(management_area = NMFS_AREA)
# 
  

#   #this just applies the 'get_nice_region_names' file to each description- if you need other areas to
#   #map to a nice name, edit function to have more terms- it is commented within function.
   intervals_data$region = map_chr(intervals_data$Name, get_nice_region_names)
   
   #
   # intervals_data = intervals_data[!(intervals_data$SURVEY == 200004 & intervals_data$DESCRIPTION != "Shelikof Strait primary survey"),]
   # intervals_data = intervals_data[!(intervals_data$SURVEY == 199703 & intervals_data$DESCRIPTION != "Pass 1"),]
   # intervals_data = intervals_data[!(intervals_data$SURVEY == 200102 & intervals_data$DESCRIPTION != "primary"),]
   # 
   
   
  #  # if (length(intervals_data$SURVEY == 200004)> 1) {
  #  #   intervals_data= intervals_data[(intervals_data$DESCRIPTION == "Shelikof Strait primary survey" ),]
  #  # }
  #  
  #  if (length(intervals_data$SURVEY == 199703)> 1){
  #    intervals_data= intervals_data[(intervals_data$DESCRIPTION == "Pass 1" ),]
  #  }
  #  
  # if (length(intervals_data$SURVEY == 200102)> 1){
  #    intervals_data= intervals_data[(intervals_data$DESCRIPTION == "primary" ),]
  #  }
  #  #else {}
   
   
   
   
   
   #intervals_data= map_chr(intervals_data, weirdhistoricalfix_function)
   
   # 
   # if (intervals_data$survey  == 200102 & str_detect(regex("none", ignore_case = TRUE))){
   #   region <- "Unimak Pass" }
   
   # intervals_data= intervals_data%>%
   #   mutate(region = case_when(survey  == 200102 & region == "none" ~ "Unimak Pass"))
     
# 
   #intervals_data = intervals_data[!(intervals_data$SURVEY == 200102 & intervals_data$region == 'none'),]
   
  
  #end here
  
  # intervals_data= intervals_data%>%
  #   select(!c(Region, Lat, Lon))
  
  # intervals_data = intervals_data%>%
  #   mutate(region = case_when(year == 2001 & region == "Marmot Region") ~ "other")
  
  # %>%
  #   #rename REP_AREA to something more descriptive
  #   rename(management_area = NMFS_AREA)
  # 
  #intervals_data$region[intervals_data$region == 'SCA']<- 'East of 170 - SCA'
  #I know there's a way to do this in pipes, but I don't know how....
  # intervals_data$region[intervals_data$region == 'Eastern Bering Sea' & intervals_data$START_LONGITUDE <= -170]= 'West of 170'
  # intervals_data$region[intervals_data$region == 'Eastern Bering Sea' & intervals_data$START_LONGITUDE > -170]= 'East of 170'
 
  
  #return the dataframe
  # return(list(intervals_data, event_data))
  return(intervals_data)
  #return(list(intervals_data, event_data))
  

}