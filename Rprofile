# vim: filetype=r

# Specify this CRAN repo if one not baked-in (as is with MRAN)
local({
  options(repos = getOption('repos', 'http://cran.cnr.berkeley.edu'))
})

.First <- function()
{
  if (interactive() && 'setwidth' %in% utils::installed.packages()[,1])
  {
      library(setwidth)
      options(setwidth.verbose=3)  # startup message
  }

  if ('colorout' %in% utils::installed.packages()[,1])
  {
    if (Sys.getenv("TERM") %in% c("xterm-256color", "screen-256color")) 
    {
      library(colorout)
      setOutputColors256(verbose=F)         # solarized dark
      #setOutputColors256(string = 0, verbose = F)     # for solarized light
    }
  }
}

if (interactive() && FALSE)
{
    library(magrittr)
    library(data.table)
}

# printf <- function(...) { cat(sprintf(...)) }
# oneup  <- function() { par(mfrow=c(1,1)) }
# twoup  <- function() { par(mfrow=c(2,2)) }
# cls    <- function() { cat('') }


