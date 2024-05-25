# #ALM 5/2024- A function that bundles the pre-selectivity winter GOA data fetching
# # functions
GetUpdateWinterGOA_function  <- function(surface_historical) {


#load shapefiles-bathymetery, land, some place labels and survey regions
ak_land = st_read('shapefiles/alaska_land_NAD1983_HARN/alaska_land_NAD1983_HARN.shp')
ak_labels = st_read('shapefiles/ak_area_labels_albers_alaska/ak_area_labels_albers_alaska.shp')
management_regions = st_read('shapefiles/NMFS_management_areas_albers_alaska/NMFS_management_areas_albers_alaska.shp')
wintersurveyregions = st_read('shapefiles/winter_survey_regions_BarnabasChiniak_NAD1983/winter_survey_regions_BarnabasChiniak_NAD1983.shp')

#project shapefiles
management_regions = st_transform(management_regions, crs = 3338)
ak_land = st_transform(ak_land, crs = 3338)
winterpolygons = st_transform(wintersurveyregions, crs = 3338)


#query MB2 for *pollock* biomass and numbers at length by interval for surveys from 2000- present
#we are going back *just* to 2000 because spatial data for 1994-1999 are a little shifty. 93-97 have weird monthly schedules
#and 99 has a horseshoe survey that makes everything tricky.

#NOTE THAT WE ARE USING ZONE 1 FOR THE REPORT.

#historical bottom-and surface-referenced dataset info for shelikof surveys:
#
# surface_historical_path = 'raw_data/parameters_shelikof_length_age_time_series_1995_2007.csv'
#
# surface_historical = read.csv( surface_historical_path, header= TRUE, as.is = TRUE)
#
# surface_historical_shelikof = surface_historical

#open the database
#db = dbConnect(odbc::odbc(), dsn = db_name, uid = user_name, pwd = pword)



#get all the historical values, as well as the current value, for surface-referenced datasets
pre_selectivity_winter_GOA = pmap_dfr(list(ship = surface_historical$ships,
                                        survey = surface_historical$surveys,
                                        data_set_id = surface_historical$data_sets,
                                        analysis_id = surface_historical$analyses),
                                   get_historical_biomass_data_winter)


pre_selectivity_winter_GOA$year = as.numeric(substr(pre_selectivity_winter_GOA$SURVEY, 1,4))
############################
# get a timestamp for the run time so the user can know when data was queried
query_run_time <- Sys.time()


#get_historical_AGE_biomass_data_winter
just_shelikof = surface_historical%>%
  filter(generalarea == 2)

surf_ref_biomass_nums_ages_h  = pmap_dfr(list(ship = just_shelikof$ships,
                                             survey = just_shelikof$surveys,
                                             data_set_id = just_shelikof$data_sets,
                                             analysis_id = just_shelikof$analyses,
                                             report_num = just_shelikof$report_num),
                                        get_historical_AGE_biomass_data_winter)


surf_ref_biomass_nums_ages_h$year = as.numeric(substr(surf_ref_biomass_nums_ages_h$SURVEY, 1,4))


# shelikof_95_07L = surf_ref_biomass_nums_h%>%
#   rename(Ship = SHIP, Survey = SURVEY, Year= year, Interval = INTERVAL, Length = LENGTH, Transect = TRANSECT, DataSetID = DATA_SET_ID,
#          AnalysisId = ANALYSIS_ID, ReportNumber = REPORT_NUMBER, Description = DESCRIPTION,  Region = region, Numbers = NUMBERS, Biomasskg = BIOMASS,
#          Latitude = lat, Longitude = lon)


shelikof_95_07A = surf_ref_biomass_nums_ages_h%>%
  rename(Ship = SHIP, Survey = SURVEY, Year= year, Interval = INTERVAL, Age = AGE, Transect = TRANSECT, DataSetID = DATA_SET_ID,
         AnalysisId = ANALYSIS_ID, ReportNumber = REPORT_NUMBER, Description = DESCRIPTION,  Region = region, Numbers = NUMBERS, Biomasskg = BIOMASS,
         Latitude = lat, Longitude = lon)



pre_selectivity_winter_GOA = pre_selectivity_winter_GOA%>%
  select(!c(END_TIME, START_LATITUDE, END_LATITUDE))

pre_selectivity_winter_Shelikof_ages = shelikof_95_07A%>%
  select(!c(END_TIME, START_LATITUDE, END_LATITUDE))

#save(pre_selectivity_winter_GOA, pre_selectivity_winter_Shelikof_ages, file = 'D:/R/work/Winter_GOA_historical_old/data/historical/PreSelectivityWinterGOA.RData')
#E:/R/work/summer_ebs_cruise_report/data/historical
save(pre_selectivity_winter_GOA, pre_selectivity_winter_Shelikof_ages, file = 'data/PreSelectivityWinterGOA.RData')
#save(shumagins_01_08, file= 'D:/R/work/Winter_GOA_historical/historical_data/shumagins_historical_2001_2008.RData' )

return(list(pre_selectivity_winter_GOA, pre_selectivity_winter_Shelikof_ages))
#return(biomass_nums_data)

}









