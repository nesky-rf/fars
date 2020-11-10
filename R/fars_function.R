#' Functions that read traffic crash from FARS dataset.
#'
#' Available data starts from 1975 (as a reference:\href{https://www.nhtsa.gov/node/97996/251}{avaiable datasets}).
#'
#' Print "fars_map_state"
#'
#' @note This information is provided by FARS (Fatality Analysis Reporting System),
#' which became operational since 1975. Data is based on the 50 states, Puerto Rico
#' and the District of Columbia, containing census of fatal traffic crashes.
#' Trained employees from FARS gather more the 140 data elements per traffic crash,
#' for full details, check \href{https://www.nhtsa.gov/crash-data-systems/fatality-analysis-reporting-system}{FARS data})
#'
#' @description This function plots a map with traffic crashes location based on
#' FARS data, occurred in a specific US state. It will check if no data is available
#' and if location coordinates are valid. To explore traffic crashes,
#' \itemize{
#'  \item Check at \href{https://www.nhtsa.gov/node/97996/251}{avaiable datasets}, data to plot/explore.
#'  \item Download CSV file locally, extract contents , i.e. for National data from 2000
#'  curl::curl_download(url = "https://www.nhtsa.gov/filebrowser/download/152076", destfile = "FARS2000NAtionalCSV.zip");
#'  extract its contents, rename and bzip2 file "accidents.csv" file as "accident_2000.csv.bz2"
#' }
#'
#' @param state.num US state number (represented as numerical alphabetical order,
#' i.e. Alabama=0, Alaska=1, Arizona=3, ... )
#'
#' @param year 4 digit year number/string
#'
#' @return This function returns a message indicating no valid state number \code{satate.num}
#' or unavailable data if no crashes occurred.
#'
#' @details It will present a error if  parameter represents an invalid
#' state number according to the local data base.
#'
#' @examples
#' \dontrun{
#' fars_map_state(1, 2011) # generates a crash location map for Alaska in 2011
#' }
#'
#' @importFrom maps map
#' @importFrom graphics points
#' @export
fars_map_state <- function(state.num, year) {
  STATE <- NULL
  filename <- make_filename(year)
  data <- fars_read(filename)
  state.num <- as.integer(state.num)

  if(!(state.num %in% unique(data$STATE)))
    stop("invalid STATE number: ", state.num)
  data.sub <- dplyr::filter(data, STATE == state.num)
  if(nrow(data.sub) == 0L) {
    message("no accidents to plot")
    return(invisible(NULL))
  }
  # Consider as NA values wrong coordinates values
  is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
  is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
  with(data.sub, {
    maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
              xlim = range(LONGITUD, na.rm = TRUE))
    graphics::points(LONGITUD, LATITUDE, pch = 46)
  })
}

#' Print "fars_summarize_years"
#'
#' @description This function provides a summary of number of traffic crashes
#' occurred by months and years.
#'
#' @param years A vector that contains POSIXlt date time format
#'
#' @return This function returns a data frame with the number of traffic crashes
#' occurred on each input year and month.
#'
#' @examples
#' \dontrun{
#' fars_summarize_years(c(2013:2015))
#' }
#'
#' @importFrom tidyr spread
#' @importFrom magrittr %>%
#' @importFrom dplyr n
#' @export
fars_summarize_years <- function(years) {
  MONTH <- year <- NULL
  dat_list <- fars_read_years(years)
  dplyr::bind_rows(dat_list) %>%
    dplyr::group_by(year, MONTH) %>%
    dplyr::summarize(n = n()) %>%
    tidyr::spread(year, n)
}

#' Print "fars_read"
#'
#' @description This function reads the content of a csv file
#'
#' @param filename CSV file name with naming convention "accident_nnnn.csv.bz2",
#' where "nnnn" is a 4-digit year number
#'
#' @return This function returns a tibble with traffic crash data.
#'
#' @importFrom readr read_csv
fars_read <- function(filename) {
  if(!file.exists(filename))
    stop("file '", filename, "' does not exist")
  data <- suppressMessages({
    readr::read_csv(filename, progress = FALSE)
  })
  dplyr::tbl_df(data)
}

#' Print "make_filename"
#'
#' This function generates file name convention "accident_%d.csv.bz2"
#'
#' @param year A 4-digit year number/string.
#'
#' @return File name for a given year, that satisfies internal naming convention
#'
make_filename <- function(year) {
  year <- as.integer(year)
  sprintf("accident_%d.csv.bz2", year)
}

#' Print "fars_read_years"
#'
#' @description This function reads data content from FARS dataset and summarizes
#' traffic crashes by year and month.
#'
#' @param years A vector that contains POSIXlt date time format
#'
#' @return This function returns a data frame with the traffic crashes occurred on
#' each month as per input year. It generates warning message upon unavailable data.
#'
#' @importFrom magrittr %>%
fars_read_years <- function(years) {
  MONTH <- NULL
  lapply(years, function(year) {
    file <- make_filename(year)
    tryCatch({
      dat <- fars_read(file)
      dplyr::mutate(dat, year = year) %>%
        dplyr::select(MONTH, year)
    }, error = function(e) {
      warning("invalid year: ", year)
      return(NULL)
    })
  })
}
