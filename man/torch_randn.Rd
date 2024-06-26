% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/creation-ops.R, R/gen-namespace-docs.R,
%   R/gen-namespace-examples.R
\name{torch_randn}
\alias{torch_randn}
\title{Randn}
\usage{
torch_randn(
  ...,
  names = NULL,
  dtype = NULL,
  layout = NULL,
  device = NULL,
  requires_grad = FALSE
)
}
\arguments{
\item{...}{(int...) a sequence of integers defining the shape of the output tensor.        Can be a variable number of arguments or a collection like a list or tuple.}

\item{names}{optional names for the dimensions}

\item{dtype}{(\code{torch.dtype}, optional) the desired data type of returned tensor.        Default: if \code{NULL}, uses a global default (see \code{torch_set_default_tensor_type}).}

\item{layout}{(\code{torch.layout}, optional) the desired layout of returned Tensor.        Default: \code{torch_strided}.}

\item{device}{(\code{torch.device}, optional) the desired device of returned tensor.        Default: if \code{NULL}, uses the current device for the default tensor type        (see \code{torch_set_default_tensor_type}). \code{device} will be the CPU        for CPU tensor types and the current CUDA device for CUDA tensor types.}

\item{requires_grad}{(bool, optional) If autograd should record operations on the        returned tensor. Default: \code{FALSE}.}
}
\description{
Randn
}
\section{randn(*size, out=NULL, dtype=NULL, layout=torch.strided, device=NULL, requires_grad=False) -> Tensor }{


Returns a tensor filled with random numbers from a normal distribution
with mean \code{0} and variance \code{1} (also called the standard normal
distribution).

\deqn{
    \mbox{out}_{i} \sim \mathcal{N}(0, 1)
}
The shape of the tensor is defined by the variable argument \code{size}.
}

\examples{
if (torch_is_installed()) {

torch_randn(c(4))
torch_randn(c(2, 3))
}
}
