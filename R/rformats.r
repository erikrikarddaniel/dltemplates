#!/usr/bin/env Rscript

# __TITLE__
#
# Author: __AUTHOR_EMAIL__

suppressPackageStartupMessages(library(optparse))
suppressPackageStartupMessages(library(readr))
suppressPackageStartupMessages(library(feather))
suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(dtplyr))
suppressPackageStartupMessages(library(dplyr, warn.conflicts = FALSE))
suppressPackageStartupMessages(library(tidyr))
suppressPackageStartupMessages(library(purrr))
suppressPackageStartupMessages(library(stringr))

SCRIPT_VERSION = "N.N"

# Constants for names of different formats
FORMAT_ONE        = 'one'
FORMAT_TWO        = 'two'
FORMAT_DEFAULT    = FORMAT_ONE
FORMATS           = c(FORMAT_ONE, FORMAT_TWO)

# Get arguments
option_list = list(
    make_option(
        c('--inputfile'), type='character',
        help='Name of input file'
    ),
    make_option(
        c('--format'), type='character', default=FORMAT_DEFAULT,
        help='Output format, default: [default]. See --formats for a list of supported formats.'
    ),
    make_option(
        c('--formats'), action='store_true', default=FALSE,
        help='Lists supported formats'
    ),
    make_option(
        c("-v", "--verbose"), action="store_true", default=FALSE, 
        help="Print progress messages"
    ),
    make_option(
        c("-V", "--version"), action="store_true", default=FALSE, 
        help="Print program version and exit"
    )
)
opt = parse_args(
    OptionParser(
        usage = "%prog [options] file0 .. filen", 
        option_list = option_list
    ), 
    positional_arguments = TRUE
)

if ( opt$options$version ) {
    write(SCRIPT_VERSION, stdout())
    quit('no')
}

if ( opt$options$formats ) {
    write(cat("Supported formats:", FORMATS, "\n"))
    quit('no')
}

logmsg = function(msg, llevel='INFO') {
    if ( opt$options$verbose ) {
        write(
            sprintf("%s: %s: %s", llevel, format(Sys.time(), "%Y-%m-%d %H:%M:%S"), msg),
            stderr()
        )
    }
}
logmsg(sprintf("Reading %s", opt$options$inputfile))

logmsg("Done")

# vim: sw=2
