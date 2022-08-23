#!/usr/bin/env Rscript
library('data.table')
library('colorout')

dt <- data.table(logic=c(T,T,F),
                 factor=factor(c('one', 'two', 'three')),
                 string=c("ABC", "DEF", "HIJ"),
                 real=c(1.23, -4.56, 0),
                 cien.not=c(1.234e-23, -4.56e+45, 7.89e78),
                 date=as.Date(c("2012-02-21","2013-02-12", "2014-03-04")),
                 stringsAsFactors=F)

print(dt)

