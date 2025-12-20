#!/usr/bin/env Rscript

cc <- function(str) { Filter(nchar, unlist(strsplit(str, "[ \n \t]"))) }

p <- '
	anytime
	argparse
	collapse
	data.table
	descr
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
	RColorBrewer
  anytime
  bit64
  descr
  glue
  stringr
  tidyr
	xts
	zoo
'

#	MASS
# duckdb
if (!require("pak")) install.packages("pak")
pak::pak_install_extra()

pak::pak(cc(p))
pak::pak('remotes')
pak::pak('jalvesaq/colorout')
print(cc(p))

