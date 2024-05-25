# create consistent naming conventions to group for plotting

# this function will only do this for the shumagins and shelikof surveys and would need to be modified for future reports!
# just add more 'else if' statements as needed
# It assumes that all the things we've called regions over the years will at least have some things in common, i.e. 'Shelikof, 'shelikof_strait, etc..,
# all have 'shel' in the name.

get_nice_region_names <- function(area_name) {
  # don't include the occasional strange entry without a description
  if (is.na(area_name)) {
    region <- "none"
  } # assume any shelikof has 'sheli' in it, (don't accept just 'shel' as it could get 'shelf')
  else if (str_detect(area_name, regex("sheli", ignore_case = TRUE))) {
    region <- "Shelikof Strait"
  } # assume any marmot has 'mar'
  else if (str_detect(area_name, regex("mar", ignore_case = TRUE))) {
    region <- "Marmot Region"
  } # Assume any GOA Shelf has 'shelf' (to avoid matching Shelikof it should have full shelf);
  # also make sure there's no 'chir' to avoid Chirikof shelfbreak getting included
  else if (str_detect(area_name, regex("shelf", ignore_case = TRUE)) &
    !str_detect(area_name, regex("chir", ignore_case = TRUE))) {
    region <- "GOA Shelf"
  } # assume any chirikof has 'chir'
  else if (str_detect(area_name, regex("chir", ignore_case = TRUE))) {
    region <- "Chirikof Shelfbreak"
  } # assume any shumagins has 'shum'
  else if (str_detect(area_name, regex("shum", ignore_case = TRUE))) {
    region <- "Shumagin Islands"
  } # assume any sanak has 'san'
  else if (str_detect(area_name, regex("san", ignore_case = TRUE))) {
    region <- "Sanak Trough"
  } # assume any morzhovoi has 'mor'
  else if (str_detect(area_name, regex("mor", ignore_case = TRUE))) {
    region <- "Morzhovoi Bay"
  } # assume any pavlof has 'pav'
  else if (str_detect(area_name, regex("pav", ignore_case = TRUE))) {
    region <- "Pavlof Bay"
  } # assume any bogoslof has 'bog'
  else if (str_detect(area_name, regex("bog", ignore_case = TRUE))) {
    region <- "Bogoslof"
  } # Assume any Chiniak has 'chin'
  else if (str_detect(area_name, regex("chin", ignore_case = TRUE))) {
    region <- "Chiniak"
  } # Assume and Resurrection Bay has 'ress'
  else if (str_detect(area_name, regex("res", ignore_case = TRUE))) {
    region <- "Resurrection Bay"
  } # Assume any Prince William Sound has 'Prince' or PWS
  else if (str_detect(area_name, regex("prince", ignore_case = TRUE)) |
    str_detect(area_name, regex("pws", ignore_case = TRUE))) {
    region <- "Prince William Sound"
  } # Assume any Barnabas has 'bar'
  else if (str_detect(area_name, regex("barn", ignore_case = TRUE))) {
    region <- "Barnabas Trough"
  } # Assume any Mitrofania has'mit'
  else if (str_detect(area_name, regex("mit", ignore_case = TRUE))) {
    region <- "Mitrofania"
  } # Assume any Alitak has 'ali'
  else if (str_detect(area_name, regex("ali", ignore_case = TRUE))) {
    region <- "Alitak"
  } # Assume middleton Alitak has 'middleton'
  else if (str_detect(area_name, regex("middle", ignore_case = TRUE))) {
    region <- "Middleton Island"
  } # Assume any Kenai has 'ken', assume knight passage as 'kni', group these with Kenai
  else if (str_detect(area_name, regex("kena", ignore_case = TRUE)) |
    str_detect(area_name, regex("knig", ignore_case = TRUE))) {
    region <- "Kenai Peninsula"
  } # assume any Yakutat has 'yaku'
  else if (str_detect(area_name, regex("yaku", ignore_case = TRUE))) {
    region <- "Yakutat Trough"
  } # assume any Kayak trought has 'kayak'
  else if (str_detect(area_name, regex("kayak", ignore_case = TRUE))) {
    region <- "Kayak Island Trough"
  } # Assume any EBS has 'EBS' or 'bering' but NOT northern or russia
  else if (str_detect(area_name, regex("bering", ignore_case = TRUE)) |
    str_detect(area_name, regex("ebs", ignore_case = TRUE)) &
      !str_detect(area_name, regex("russia", ignore_case = TRUE)) &
      !str_detect(area_name, regex("russia", ignore_case = TRUE))) {
    region <- "Eastern Bering Sea"
  } # put any other areas in an 'other' category - hopefully, none go here, so add as needed!
  else {
    region <- "other"
  }

  return(region)
}
