% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/saveDeAsJson.R
\name{saveDeAsJson}
\alias{saveDeAsJson}
\title{Save DE results as JSON tables for viewing in browser}
\usage{
saveDeAsJson(
  de.raw,
  sample.groups = NULL,
  saveprefix = NULL,
  dir.name = "JSON",
  gene.metadata = NULL,
  verbose = TRUE
)
}
\arguments{
\item{de.raw}{List of DE results from e.g. cacoa, conos}

\item{sample.groups}{Sample groups as named list, each element containing a vector of samples. Can be retrieved from e.g. package cacoa (default=NULL)}

\item{saveprefix}{Prefix for created files (default=NULL)}

\item{dir.name}{Name for directory with results. If it doesn't exist, it will be created. To disable, set as NULL (default="JSON")}

\item{gene.metadata}{(default=NULL) # Needs explanation}

\item{verbose}{Show progress (default=TRUE)}
}
\value{
JSON files, table of content, and viewer files for viewing DE results in browser
}
\description{
Save DE results as JSON tables for viewing in browser
}
\examples{
\dontrun{
saveDeAsJson(de.raw, sample.groups)
}
## The results can be viewed in a webbrowser by opening toc.html

}
