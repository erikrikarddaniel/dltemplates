#!/usr/bin/env Rscript

# __TITLE__
#
# Author: __AUTHOR_EMAIL__

suppressPackageStartupMessages(library(optparse))
suppressPackageStartupMessages(library(readr))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(tidyr))

# Get arguments
option_list = list(
  make_option(
    c("-v", "--verbose"), action="store_true", default=FALSE, 
    help="Print progress messages"
  )
)
opt = parse_args(OptionParser(option_list=option_list))

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
