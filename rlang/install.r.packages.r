#!/usr/bin/env Rscript

cc <- function(str) { Filter(nchar, unlist(strsplit(str, "[ \n \t]"))) }

p <- '
	data.table
	lattice
	latticeExtra
	magrittr
	collapse
	nanotime
	descr
	ggplot2
	RColorBrewer
	xts
	zoo
	anytime
	MASS
	glue
	gsignal
	purrr
'

if (!require("pak")) install.packages("pak")

pak::pak('remotes')
pak::pak('jalvesaq/colorout')
pak::pak('cran/setwidth')
print(cc(p))

pak::pak(cc(p))
