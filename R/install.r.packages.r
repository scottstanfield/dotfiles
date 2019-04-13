#!Rscript --vanilla

r <- getOption('repos')
r["CRAN"] <- "http://cran.cnr.berkeley.edu"
options(repos=r)

cat("§ data.table \n")
install.packages('data.table', repos='https://Rdatatable.github.io/data.table')

# for %>% pipe
cat("§ magrittr \n")
install.packages('magrittr')

# so we can install straight from github
cat("§ remotes \n")
install.packages('remotes')

# color in all console output
cat("§ colorout \n")
remotes::install_github('jalvesaq/colorout')

# adapt R console output to terminal width
cat("§ setwidth \n")
remotes::install_github('cran/setwidth')

# for data.table gzip support
cat("§ R.utils \n")
install.packages('R.utils')


