# census_linking_focal.R
#' Link Coordinates to German Census 2011 Data by Using Focal Analyses
#' @description This function performs spatial linking based on coordinates data
#' and the results of focal analyses based on raster grid cell data from the
#' German Census 2011. By default it uses simulated coordinates data for
#' demonstration purposes. Own coordinates, however, can be used as well.
#' @param download Download census data (calls
#' \code{georefum::download.census()})
#' @param own.data Use own already downloaded census data (calls
#' \code{georefum::rasterize.census()}, original filenames must be preserved)
#' @param which Vector of Census attributeses that should be linked to the data
#' @param set.missing Toggle whether to set missings on Census attributes
#' @param data.path Has to be defined when using option \code{download =} or
#' \code{own.data =}
#' @param coords.file Path to file with coordinates; must be formatted as
#' csv text file with a 'X' andheader...
#' @param coords.object An R object ("Rdata" or "rda") containing the coordinates
#' @param focal.matrix Matrix on which upon focal analyses are computed; cells
#' can be weighted as well as set to \code{NA} (for details see function
#' \code{raster::focal()})
#' @param fun Function that is used in the focal analyses
#' @param na.delete logical. If TRUE, NA will be removed from focal computations. The result will only be NA if all focal cells are NA. Except for some special cases (weights of 1, functions like min, max, mean), using na.rm=TRUE is generally not a good idea in this function because it will unbalance the effect of the weights
#' @param suffix Suffix that is appended to variable names
#' @return A \code{data.frame} with census attributes based on focal analyses
#' for each coordinate
#'@export

census_linking_focal <- function(download = FALSE,
                                 own.data = FALSE,
                                 which = c("Einwohner", "Frauen_A", "Alter_D",
                                           "unter18_A", "ab65_A",
                                           "Auslaender_A","HHGroesse_D",
                                           "Leerstandsquote", "Wohnfl_Bew_D",
                                           "Wohnfl_Whg_D"),
                                 categorical = FALSE,
                                 set.missings = TRUE,
                                 data.path = ".",
                                 coords.file = "",
                                 coords.object = "",
                                 focal.matrix = matrix(c(1, 1, 1,
                                                         1, 1, 1,
                                                         1, 1, 1),
                                                       nr = 3, nc = 3),
                                 fun = "mean",
                                 suffix = "mean"){

  # workaround for internal raster function in SDMTools::extract.data ----------
  require(raster)

  # case: census data should be downloaded -------------------------------------
  if(download == TRUE){
    message("Downloading and rasterizing census data... ")
    download.census.1km()
    #download.census.100m()

    # rasterize downloaded data ------------------------------------------------
    rasterize.census(data.path)
    message("done.\n")
  }

  # case: own, already downloaded census data should be used -------------------
  if(own.data == TRUE){
    rasterize.census(data.path)
  }

  # case: internal, already downloaded census data should be used --------------
  if(download == FALSE & own.data == FALSE){
    data(census.attr)
    census.data <- census.attr
  }
  if (download == FALSE & own.data == FALSE & categorical == TRUE) {
    data(census.attr.cat)
    census.data <- census.attr.cat
  }

  # delete Frauen_A from list if regular census attributes are used
  if (categorical == FALSE) {
    which <- which[!which == "Frauen_A"]
  }

  # set missing values in census data ------------------------------------------
  if (set.missings == TRUE) {
    message("Preparing data (set missings, etc.)... ")
    for (i in which) {
      eval(
        parse(
          text = paste("census.data$", i, "[census.data$", i, " <= -1] <- NA",
                       sep = "")))
    }
  }
  message("done.\n")

  # case: use random example coordinates ---------------------------------------
  if (coords.file == "" && coords.object == "") {
    data(random.coords)
  }

  # case: use own coordinates as csv -------------------------------------------
  if (coords.file != "" && coords.object == "") {
    coords <- read.table(coords.file, sep = ";", dec = ",", header = TRUE)
        coords <- SpatialPointsDataFrame(coords[, c("x", "y" )], coords,
                                     proj4string = CRS("+init=epsg:3035"))
  }

  # case: use own coordinates as object ----------------------------------------
  if (coords.file == "" && coords.object != "") {
    coords <- coords.object

    # case: coords.object is no SpatialPointsDataFrame
    if (class(coords) != "SpatialPointsDataFrame") {
      coords <- SpatialPointsDataFrame(coords[, c("x", "y" )], coords,
                                       proj4string = CRS("+init=epsg:3035"))
    }
  }

  # focal analyses -------------------------------------------------------------
  message("Running focal analyses and merging to one data collection:\n")

  # case: no own coordinates file was provided ---------------------------------
  if (coords.file == "" && coords.object == "") {

    # run focal analyses on all census attributes ------------------------------
    for(i in which){

      # case: object does not exist yet ----------------------------------------
      if(!exists("dat")){
        message(paste(i, "... ", sep = ""))
        eval(
          parse(
            text = paste("dat <- data.frame(", i,
                         ".", suffix, " = ",
                         "SDMTools::extract.data(random.coords@coords, ",
                         "raster::focal(census.data$", i,
                         ", w = focal.matrix, ",
                         "fun = ",
                         "function(x){", fun, "(x[-which(is.na(x))], na.rm = TRUE)})))",
                         sep = "")))
        message("done.\n")
      }

      # case: object already exists --------------------------------------------
      else{
        message(paste(i, "... ", sep = ""))
        eval(
          parse(
            text = paste("dat <- data.frame(cbind(dat, ", i,
                         ".", suffix, " = ",
                         "SDMTools::extract.data(random.coords@coords, ",
                         "raster::focal(census.data$", i,
                         ", w = focal.matrix, ",
                         "fun = ",
                         "function(x){", fun, "(x[-which(is.na(x))], na.rm = TRUE)})))",
                         sep = "")))
        message("done.\n")
      }
    }
  }

  # case: own coordinates were provided ----------------------------------------
  if (coords.file != "" && coords.object == "") {

    # run focal analyses on all census attributes ------------------------------
    for(i in which){

      # case: object does not exist yet ----------------------------------------
      if(!exists("dat")){
        message(paste(i, "... ", sep = ""))
        eval(
          parse(
            text = paste("dat <- data.frame(", i,
                         ".", suffix, " = ",
                         "SDMTools::extract.data(coords@coords, ",
                         "raster::focal(census.data$", i,
                         ", w = focal.matrix, ",
                         "fun = ",
                         "function(x){", fun, "(x[-which(is.na(x))], na.rm = TRUE)})))",
                         sep = "")))
        message("done.\n")
      }

      # case: object does not exist yet ----------------------------------------
      else{
        message(paste(i, "... ", sep = ""))
        eval(
          parse(
            text = paste("dat <- data.frame(cbind(dat, ", i,
                         ".", suffix, " = ",
                         "SDMTools::extract.data(coords@coords, ",
                         "raster::focal(census.data$", i,
                         ", w = focal.matrix, ",
                         "fun = ",
                         "function(x){", fun, "(x[-which(is.na(x))], na.rm = TRUE)})))",
                         sep = "")))
        message("done.\n")
      }
    }
  }

  # case: own coordinates were provided ----------------------------------------
  if (coords.file == "" && coords.object != "") {

    # run focal analyses on all census attributes ------------------------------
    for(i in which){

      # case: object does not exist yet ----------------------------------------
      if(!exists("dat")){
        message(paste(i, "... ", sep = ""))
        eval(
          parse(
            text = paste("dat <- data.frame(", i,
                         ".", suffix, " = ",
                         "SDMTools::extract.data(coords@coords, ",
                         "raster::focal(census.data$", i,
                         ", w = focal.matrix, ",
                         "fun = ",
                         "function(x){", fun, "(x[-which(is.na(x))], na.rm = TRUE)})))",
                         sep = "")))
        message("done.\n")
      }

      # case: object does not exist yet ----------------------------------------
      else{
        message(paste(i, "... ", sep = ""))
        eval(
          parse(
            text = paste("dat <- data.frame(cbind(dat, ", i,
                         ".", suffix, " = ",
                         "SDMTools::extract.data(coords@coords, ",
                         "raster::focal(census.data$", i,
                         ", w = focal.matrix, ",
                         "fun = ",
                         "function(x){", fun, "(x[-which(is.na(x))], na.rm = TRUE)})))",
                         sep = "")))
        message("done.\n")
      }
    }
  }

  # remove no longer needed internal datasets ----------------------------------
  if(exists("census.attr")){
    rm("census.attr", envir = globalenv())
  }
  if(exists("random.coords")){
    rm("random.coords", envir = globalenv())
  }

  # write to object in global environment --------------------------------------
  return(dat)
}

