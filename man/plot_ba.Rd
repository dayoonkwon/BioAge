% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_ba.R
\name{plot_ba}
\alias{plot_ba}
\title{plot_ba}
\usage{
plot_ba(data, agevar, label)
}
\arguments{
\item{data}{A dataset with projected biological aging measures for analysis.}

\item{agevar}{A character vector indicating the names of the biological aging measures.}

\item{label}{A character vector indicating the labels of the biological aging measures.}
}
\description{
Plot association of biological aging measures with chronological age.
}
\details{
Plot association of biological aging measures with chronological age.
}
\note{
Chronological age and gender variables need to be named "age" and "gender".
}
\examples{
#Plot age vs bioage
f1 = plot_ba(data = data, agevar = c("kdm", "phenoage", "hd"),
             label = c("Modified-KDM\nBiological\nAge",
                       "Modified-Levine\nPhenotypic\nAge",
                       "Homeostatic\nDysregulation"))

f1

}
