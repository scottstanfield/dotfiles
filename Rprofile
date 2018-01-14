# colorout isn't on CRAN so install from source (it's easy)
# % git clone https://github.com/jalvesaq/colorout.git
# % R CMD INSTALL colorout

.First <- function()
{
  options(setwidth.verbose=1)  # startup message
  options(setwidth.verbose=2)  # only on error
  options(setwidth.verbose=3)  # print width value

	if (is.element('colorout', utils::installed.packages()[,1]) == T)
	{
		# Sys.getenv("TERM") %in% c("xterm-256color", "screen-256color"))
		library(colorout)
		# setOutputColors256(string = 0, verbose = F)     # for solarized light
    # setOutputColors256(normal=16, negnum=166, zero=142, number=35, date=97, string=62, const=29, false=161, true=35, infinite=33, stderr=27, verbose = F)
    setOutputColors256(verbose=F)
	}
}

# # Set output width to size of the screen (if possible)
# .set.width.option <- function()
# {
# 	width = as.integer(Sys.getenv('COLUMNS'))
#   if (!is.na(width))
#   {
#     options(width = width)
#   }
# }

if (interactive()) 
{
  library(setwidth)
  library(data.table)
  library(txtplot)
}



