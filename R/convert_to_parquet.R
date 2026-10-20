#!/usr/bin/env Rscript

# convert_to_parquet.R
#
# Converts a single TSV (optionally gzipped) file to Parquet, for pipeline output that
# doesn't already include Parquet copies. Intended to be called once per file from a
# Makefile pattern rule, e.g.:
#
#   %.parquet: %.tsv.gz
#   	Rscript ../scripts/convert_to_parquet.R $< $@
#
# Usage: convert_to_parquet.R infile.tsv[.gz] outfile.parquet

suppressPackageStartupMessages(library(DBI))
suppressPackageStartupMessages(library(duckdb))

args = commandArgs(trailingOnly = TRUE)
if ( length(args) != 2 ) {
    write("Usage: convert_to_parquet.R infile.tsv[.gz] outfile.parquet", stderr())
    quit(status = 1)
}
infile  = args[1]
outfile = args[2]

# DuckDB, not arrow/readr: it streams the file, so tables larger than memory convert fine,
# and the analysis side (duckplyr) already depends on it, so nothing extra to install.
# sample_size = -1 scans the whole file for column types; the default sample guesses wrong
# on columns that are mostly NA.
con = dbConnect(duckdb())
src = sprintf("read_csv(%s, delim = '\t', header = true, nullstr = 'NA', sample_size = -1%%s)", dbQuoteString(con, infile))

# Numeric-looking sample names (e.g. "001") stay text so they match the sample table.
cols = names(dbGetQuery(con, sprintf("SELECT * FROM %s LIMIT 0", sprintf(src, ""))))
types = if ( "sample" %in% cols ) ", types = {'sample': 'VARCHAR'}" else ""

dbExecute(con, sprintf("COPY (SELECT * FROM %s) TO %s (FORMAT parquet)", sprintf(src, types), dbQuoteString(con, outfile)))
dbDisconnect(con, shutdown = TRUE)

# vim: sw=2
