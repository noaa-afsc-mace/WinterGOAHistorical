#' @title Pre-selectivity corrected dataset consisting of pollock biomass & numbers at age on a per-interval basis. Winter GOA.
#' @format A data frame with 236399 rows and 16 columns:
#' \describe{
#'   \item{Ship}{ship number; 21 is MF, 157 is DY (numeric)}
#'   \item{Survey}{survey number (numeric)}
#'   \item{DataSetID}{Duh (numeric)}
#'   \item{AnalysisId}{Duh (numeric)}
#'   \item{ReportNumber}{The report number associated with the ages (numeric)}
#'   \item{Interval}{Original interval number, not unique in older surveys (numeric)}
#'   \item{Age}{Age of fish (years), determined by age & growth}
#'   \item{Transect}{Original transect designation; NULL transects were removed from these data}
#'   \item{Description}{The original descriptor in old MB}
#'   \item{Numbers}{Numbers of fish in that edsu}
#'   \item{Biomasskg}{Biomass (kg) of fish in that edsu}
#'   \item{Width}{Width (nm) of transect in that edsu}
#'   \item{START_TIME}{Date and Time (UTC) at the start of the interval}
#'   \item{Region}{Region in which the survey was performed, used st_join(st_within) from the sf library and updated geographic regions stored in:
#'  'G://ARCVIEW//exported_shapefiles//winter_survey_regions_BarnabasChiniak_NAD1983' to determine survey area}
#'   \item{Latitude}{ Latitude at start of edsu; older surveys don't have an end lat/long}
#'   \item{Longitude}{Longitude at start of edsu; older surveys don't have an end lat/long}
#'   \item{Year}{Year of Survey}
#' }
#'
#' #' @source Historic MACE reported values
"PreSelectivityWinterGOAages"
