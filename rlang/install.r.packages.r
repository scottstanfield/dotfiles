#!/usr/bin/env Rscript

cc <- function(str) { Filter(nchar, unlist(strsplit(str, "[ \n \t]"))) }

p <- '
	MASS
	RColorBrewer
	anytime
	argparse
	collapse
	data.table
	descr
	duckdb
	dygraphs
	ggplot2
	glue
	gsignal
	janitor
	lattice
	latticeExtra
	magrittr
	nanotime
	purrr
	xts
	xts
	zoo
'

if (!require("pak")) install.packages("pak")

pak::pak('remotes')
pak::pak('jalvesaq/colorout')
print(cc(p))

pak::pak(cc(p))
