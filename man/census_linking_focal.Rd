% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/census_linking_focal.R
\name{census_linking_focal}
\alias{census_linking_focal}
\title{Link Coordinates to German Census 2011 Data by Using Focal Analyses}
\usage{
census_linking_focal(download = FALSE, own.data = FALSE,
  which = c("Einwohner", "Frauen_A", "Alter_D", "unter18_A", "ab65_A",
  "Auslaender_A", "HHGroesse_D", "Leerstandsquote", "Wohnfl_Bew_D",
  "Wohnfl_Whg_D"), categorical = FALSE, set.missings = TRUE,
  data.path = ".", coords.file = "", coords.object = "",
  focal.matrix = matrix(c(1, 1, 1, 1, 1, 1, 1, 1, 1), nr = 3, nc = 3),
  fun = "mean", suffix = "mean")
}
\arguments{
\item{download}{Download census data (calls
\code{georefum::download.census()})}

\item{own.data}{Use own already downloaded census data (calls
\code{georefum::rasterize.census()}, original filenames must be preserved)}

\item{which}{Vector of Census attributeses that should be linked to the data}

\item{data.path}{Has to be defined when using option \code{download =} or
\code{own.data =}}

\item{coords.file}{Path to file with coordinates; must be formatted as
csv text file with a 'X' andheader...}

\item{coords.object}{An R object ("Rdata" or "rda") containing the coordinates}

\item{focal.matrix}{Matrix on which upon focal analyses are computed; cells
can be weighted as well as set to \code{NA} (for details see function
\code{raster::focal()})}

\item{fun}{Function that is used in the focal analyses}

\item{suffix}{Suffix that is appended to variable names}

\item{set.missing}{Toggle whether to set missings on Census attributes}

\item{na.delete}{logical. If TRUE, NA will be removed from focal computations. The result will only be NA if all focal cells are NA. Except for some special cases (weights of 1, functions like min, max, mean), using na.rm=TRUE is generally not a good idea in this function because it will unbalance the effect of the weights}
}
\value{
A \code{data.frame} with census attributes based on focal analyses
for each coordinate
}
\description{
This function performs spatial linking based on coordinates data
and the results of focal analyses based on raster grid cell data from the
German Census 2011. By default it uses simulated coordinates data for
demonstration purposes. Own coordinates, however, can be used as well.
}
