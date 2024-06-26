% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cuda.R
\name{cuda_synchronize}
\alias{cuda_synchronize}
\title{Waits for all kernels in all streams on a CUDA device to complete.}
\usage{
cuda_synchronize(device = NULL)
}
\arguments{
\item{device}{device for which to synchronize. It uses the current device
given by \code{\link[=cuda_current_device]{cuda_current_device()}} if no device is specified.}
}
\description{
Waits for all kernels in all streams on a CUDA device to complete.
}
