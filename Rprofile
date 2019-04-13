# vim: filetype=r

# Commenting this out now as MRAN 3.5.x correctly sets this up
# local({
#   options(repos = getOption('repos', 'http://cran.cnr.berkeley.edu'))
# })

.First <- function()
{
  if (interactive() && 'setwidth' %in% utils::installed.packages()[,1])
  {
      library(setwidth)
      options(setwidth.verbose=3)  # startup message
  }

  if ('colorout' %in% utils::installed.packages()[,1])
  {
      library(colorout)
      setOutputColors256(verbose=F)         # solarized dark
  }

  if (interactive())
  {
    if ('magrittr' %in% utils::installed.packages()[,1])
    {
        library(magrittr)
    }

    if ('data.table' %in% utils::installed.packages()[,1])
    {
        library(data.table, verbose=F)
        setDTthreads(0)
    }
  }
}

# must-have globals
printf <- function(...) { cat(sprintf(...)) }
oneup  <- function() { par(mfrow=c(1,1)) }
twoup  <- function() { par(mfrow=c(2,2)) }
cls    <- function() { cat('') }



