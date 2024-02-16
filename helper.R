
retrieve_station_data <- function(station_id, date) {

  filename_base <- "data/"
  filename <- paste0(filename_base, station_id, "_", date, ".csv")
  read.csv(filename)
}

extract_date_from_file <- function(filename, base_length) {
  substr(filename, base_length + 2, base_length + 11)
}

find_all_dates <- function(base_station_id) {
  files <- list.files("data/", base_station_id)
  extract_date_from_file(files, nchar(base_station_id))
}

retrieve_all_data_station <- function(station_id) {

  dates <- find_all_dates(as.character(station_id))

  for(i in seq_along(dates)) {

    df <- retrieve_station_data(station_id, dates[i])

    if(i == 1)
      big_df <- df
    else
      big_df <- big_df %>% bind_rows(df)
  }

  big_df %>%
    unique() %>%
    mutate(datetime=as.POSIXct(date, format = "%Y-%m-%d %H:%M:%S")) %>%
    mutate(date=if_else(is.na(datetime), make_datetime(year(date), month(date), day(date),
                                                       0, 0, 0), datetime)) %>%
    arrange(desc(date)) %>%
    select(-datetime) %>%
    mutate(station_id=station_id)
}
