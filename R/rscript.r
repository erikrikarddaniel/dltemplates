#!/usr/bin/env Rscript

# __TITLE__
#
# Author: __AUTHOR_EMAIL__

suppressPackageStartupMessages(library(optparse))
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(dtplyr))

FORMAT_ONE        = 'one'
FORMAT_TWO        = 'two'
FORMAT_DEFAULT    = FORMAT_ONE
FORMATS           = c(FORMAT_ONE, FORMAT_TWO)

# Get arguments
option_list = list(
  make_option(
    c('--inputfile'), type='character',
    help='Name of file BLAST tabular file (-m 8); LAST\'s output also works'
  ),
  make_option(
    c('--format'), type='character', default=FORMAT_DEFAULT,
    help='Output format, default: [default]'
  ),
  make_option(
    c('--formats'), action='store_true', default=FALSE,
    help='Lists supported formats'
  ),
  make_option(
    c("-v", "--verbose"), action="store_true", default=FALSE, 
    help="Print progress messages"
  )
)
opt = parse_args(OptionParser(option_list=option_list))

if ( opt$formats ) {
  write(cat("Supported formats:", FORMATS, "\n"))
  quit('no')
}

logmsg = function(msg, llevel='INFO') {
  if ( opt$verbose ) {
    write(
      sprintf("%s: %s: %s", llevel, format(Sys.time(), "%Y-%m-%d %H:%M:%S"), msg),
      stderr()
    )
  }
}
logmsg(sprintf("Reading %s", opt$inputfile))

logmsg("Done")
