% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/findPersistentEnv.R
\name{findPersistentEnv}
\alias{findPersistentEnv}
\title{Find the persistent environment}
\usage{
findPersistentEnv()
}
\value{
A defunct error message is raised.
}
\description{
Previously used to find a persistent environment inside a \code{\link{basiliskRun}} call, to allow variables to be passed across calls.
This is deprecated in favor of setting \code{persist=TRUE} in \code{\link{basiliskRun}},
which will explicitly pass an environment in which to store persistent variables.
}
\author{
Aaron Lun
}
