% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cdr_check_lines.R
\name{cdr_check_lines}
\alias{cdr_check_lines}
\title{Check for line data in shape files}
\usage{
cdr_check_lines(data.path, out.file, threads = 1)
}
\arguments{
\item{data.path}{Directory to check for shapefiles with lines only}

\item{out.file}{Location and name of output text file}

\item{threads}{Number of threads used for scanning the files. Use with caution as
the more threads are used the more system RAM is used as well. In addition,
only works on Windows or GNU/Linux operating systems (I don't know about MAC, to be 
honest...)}
}
\description{
Check for line data in shape files
}
