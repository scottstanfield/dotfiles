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
      suppressMessages({
        library(magrittr)
        library(data.table, verbose=F)
        printf(paste('data.table v', utils::packageDescription('data.table')$Version, '\n', sep=''))
      })
  }

}

# must-have globals
printf <- function(...) { cat(sprintf(...)) }
oneup  <- function() { par(mfrow=c(1,1)) }
twoup  <- function() { par(mfrow=c(2,2)) }
cls    <- function() { cat('') }



