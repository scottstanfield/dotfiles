#!Rscript --vanilla

r <- getOption('repos')
r["CRAN"] <- "http://cran.cnr.berkeley.edu"
options(repos=r)

# install.packages('data.table', repos='https://Rdatatable.github.io/data.table')
install.packages('magrittr')

# install.packages('remotes')		# a lighter-weight devtools package
# remotes::install_github('jalvesaq/colorout')
# remotes::install_github('cran/setwidth')

# install.packages('R.utils')   # for data.table gzip support


