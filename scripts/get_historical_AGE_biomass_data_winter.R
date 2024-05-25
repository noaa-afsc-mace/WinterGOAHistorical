# get the numbers- and biomass- at length for each set dataset/analyses; this will gather the totals by length for each ship/survey/dataset/analysis
# this summarizes data as needed for biomass comparison figures

get_historical_AGE_biomass_data_winter  <- function(ship, survey, data_set_id, analysis_id, report_num) {



  age_biomass_nums_query <- paste0('SELECT a.ship, a.survey, a.data_set_id, a.analysis_id, a.report_number,  a.interval, a.age, a.transect, b.description, ',
                            'SUM(a.numbers) as numbers, SUM(a.biomass) as biomass ',
                            'FROM macebase2.analysis_results_by_age a LEFT JOIN macebase2.report_definitions b ',
                            'ON (a.ship = b.ship) AND (a.survey = b.survey) AND (a.data_set_id = b.data_set_id) AND (a.analysis_id = b.analysis_id) ',
                            'AND (a.report_number = b.report_number)',
                             ' WHERE a.ship = ', ship, " ",
                            'AND a.survey = ', survey, " ",
                             'AND a.data_set_id = ', data_set_id, " ",
                             ' AND a.analysis_id  = ', analysis_id, " ",
                            'AND a.report_number = ', report_num, " ",
                            ' AND a.transect is not null AND b.report_number is not null ',
                              'AND a.species_code = 21740 ',
                               'GROUP BY a.ship, a.survey, a.data_set_id, a.analysis_id, a.report_number, a.interval, a.age, a.transect, b.description ',
                            'ORDER BY a.report_number ')

  biomass_nums_age_data <- dbGetQuery(db, age_biomass_nums_query)


  intervals_data = get_event_and_interval_data_function_winterhistorical(ship, survey, data_set_id, analysis_id)
  #first, get a smaller version of the interval data to speed things up a bit

  # intervals_data_to_join= intervals_data%>%
  #   st_drop_geometry()%>%
  #   select(SHIP, SURVEY, INTERVAL, TRANSECT, REPORT_NUMBER, region )

  intervals_data_h= intervals_data%>%
    st_drop_geometry()%>%
    select(SHIP, SURVEY, TRANSECT, INTERVAL, START_TIME, END_TIME, START_LATITUDE, END_LATITUDE, REPORT_NUMBER, region, lat, lon)

  #get the biomass for each interval/layer
  biomass_nums_age_data = left_join(biomass_nums_age_data, intervals_data_h,
                                by = c('SHIP', 'SURVEY',  'INTERVAL', 'TRANSECT', 'REPORT_NUMBER'))
  biomass_nums_age_data = biomass_nums_age_data[!(biomass_nums_age_data$SURVEY == 200004 & biomass_nums_age_data$DESCRIPTION != "Shelikof Strait primary survey"),]
  biomass_nums_age_data = biomass_nums_age_data[!(biomass_nums_age_data$SURVEY == 199703 & biomass_nums_age_data$DESCRIPTION != "Pass 1"),]
  # get nicer names for the survey regions
  # biomass_nums_age_data$region = map_chr(biomass_nums_age_data$DESCRIPTION, get_nice_region_names)

  # return this dataframe
  return(biomass_nums_age_data)
}
