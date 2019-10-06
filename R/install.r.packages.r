#!Rscript

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

# Can't get these two packages to work consistently, so comment out for now

# cd /tmp
# git clone https://github.com/jalvesaq/colorout
# R CMD INSTALL colorout

# git clone https://github.com/cran/setwidth
# R CMD INSTALL setwidth

# adapt R console output to terminal width
cat("§ setwidth \n")
remotes::install_github('cran/setwidth')

# for data.table gzip support
cat("§ R.utils \n")
install.packages('R.utils')


