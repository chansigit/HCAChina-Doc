# please modify before using!!!!!!!!!!
# script for discard blacklist region
# run in the current dictionary
# need packages: rtracklayer

Args <- commandArgs()
User_bed_file <- Args[6]  # this is user's peak summit file from bowtie2
blacklist_bed_file <- Args[7]  # this is blacklist file from UCSC or user
output_bed_file <- Args[8]  # this is output file
oberlap_rate <- as.numeric(Args[9])  # this is overlap rate for discard peak

library(rtracklayer)

gr_a <- rtracklayer::import(con = blacklist_bed_file, format = "bed")

gr_b <- rtracklayer::import(con = User_bed_file, format = "bed")
start(gr_b) <- start(gr_b) - 250
end(gr_b) <- end(gr_b) + 250

o <- GenomicRanges::findOverlaps(query = gr_a, subject = gr_b, ignore.strand = TRUE)
o_1 <- gr_a[S4Vectors::queryHits(o)]
o_2 <- gr_b[S4Vectors::subjectHits(o)]
peak_intersect <- IRanges::pintersect(o_1, o_2)
discard_flag <- (IRanges::width(peak_intersect)/pmin(IRanges::width(o_1),IRanges::width(o_2)) >= 0.2)
discard_reads <- IRanges::unique(o_2[discard_flag])
remain_reads <- gr_b[!gr_b %in% discard_reads]

rtracklayer::export(object = remain_reads, con = output_bed_file, format = "BED")

