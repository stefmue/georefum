% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cdr_linking_distances.R
\name{cdr_linking_distances}
\alias{cdr_linking_distances}
\title{Link Coordinates to data downloaded from the CDR by calculating minimal 
distances to next specified noise source}
\usage{
cdr_linking_distances(file = "", level = 65, feature.name = "Road_Lden",
  coords.file = "")
}
\arguments{
\item{coords.file}{Path to file with coordinates; must be formatted as
csv text file with a 'X' andheader...}
}
\value{
A \code{data.frame} with minimal geographic distances for each 
coordinate
}
\description{
This function performs spatial linking based on coordinates data
and minimal distances based on environmental noise data from the CDR. By default it uses
simulated coordinates data for demonstration purposes. Own coordinates, however,
can be used as well.
}
