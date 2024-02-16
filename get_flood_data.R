library(dplyr)

get_file_and_format <- function(station_id, is_river=TRUE) {

  base_url <- "https://check-for-flooding.service.gov.uk/"
  if(is_river)
    base_url <- paste0(base_url, "station-csv/")
  else
    base_url <- paste0(base_url, "rainfall-station-csv/")

  full_url <- paste0(base_url, station_id)
  df <- read.csv(full_url)

  if(is_river)
    colnames(df) <- c("date", "height")
  else
    colnames(df) <- c("date", "rainfall")

  df <- df %>%
    mutate(date=as.POSIXct(date, format = "%Y-%m-%dT%H:%M:%SZ", tz = "UTC"))

  filename_base <- "data/"
  filename <- paste0(filename_base, station_id, "_", Sys.Date(), ".csv")
  write.csv(df, filename, row.names = FALSE)
}


# getting river heights

river_stations <- c(7076, 9120, 7057, 7075, 7074, 9119, 7027,
              7405, 7402, 7003, 7073, 7081, 7071, 7072,
              7056, 7055, 7054, 7048, 7047, 9082, 7066,
              7064, 7052, 7063, 7070, 7062, 7061, 7060,
              7059, 7043, 7058, 2080, 7068, 7067, 7095, 7094,
              7092, 7046, 9569, 7038, 7037, 7036, 7035,
              7034, 7024, 7014, 7011, 7010, 7406, 7026,
              7025, 7040, 2079, 2043, 7015, 7021, 7013,
              7012)
n_distinct(river_stations)

for(station in river_stations) {
  get_file_and_format(station)
  Sys.sleep(1)
}

# getting rainfall amounts

rainfall_stations <- c("256230TP", "254336TP", "261021TP",
                       "253861TP", "263541TP", "254829TP",
                       "253340TP", "E24703", "257039TP",
                       "1087", "259110TP", "E21335",
                       "1165", "1082", "256345TP", "E7050",
                       "E2527", "1775", "E2476", "E7045",
                       "251530TP", "248332TP", "251556TP",
                       "248965TP", "1141")
n_distinct(rainfall_stations)
for(station in rainfall_stations) {
  get_file_and_format(station, is_river = FALSE)
  Sys.sleep(1)
}
