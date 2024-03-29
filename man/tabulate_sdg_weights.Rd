% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/functions.R
\name{tabulate_sdg_weights}
\alias{tabulate_sdg_weights}
\title{Tabulate SDG keyword weights}
\usage{
tabulate_sdg_weights(
  text,
  goal_num,
  keywords = "elsevier100",
  count_repeats = FALSE
)
}
\arguments{
\item{text}{The target text to check SDG keywords}

\item{goal_num}{The SDG goal we intend to check keywords for}

\item{keywords}{The specific data set from which to draw keywords (ex. "elsevier", "sdsn")}

\item{count_repeats}{Whether or not to count repeats for the keywords}
}
\value{
A vector of weights for keywords representing a particular SDG
}
\description{
Tabulate all SDG keyword weights that exist in a given text
for a given goal.
}
\examples{
tabulate_sdg_weights("Poverty entails more than the lack of income and productive resources
to ensure sustainable livelihoods.", 1)
}
