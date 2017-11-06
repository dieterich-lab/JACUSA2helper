# TODO
# Helper function
# returns the editing frequency of all sites from two gDNA vs. cDNA comparisons: RDDx and RDDy
#GetEditingFreq <- function(RDDx, RDDy, all = FALSE) {
#  RDDx <- AddCoverage(RDDx)
#	RDDx <- AddEditingFreq(RDDx)
#	RDDx$coord <- paste(RDDx$contig, RDDx$start, RDDx$end, RDDx$end, RDDx$strand, sep = "|")
#
#	RDDy <- AddCoverage(RDDy)
#	RDDy <- AddEditingFreq(RDDy)
#	RDDy$coord <- paste(RDDy$contig, RDDy$start, RDDy$end, RDDy$end, RDDy$strand, sep = "|")
#
#	data <- merge(
#								as.data.frame(
#															RDDx[c("coord", "cov2", "baseChange", "editingFreq")], stringsAsFactors = FALSE, check.names = FALSE
#															),
#								as.data.frame(
#															RDDy[c("coord", "cov2", "baseChange", "editingFreq")], stringsAsFactors = FALSE, check.names = FALSE
#															),
#								by = "coord",
#								suffixes = c("_x", "_y"),
#								all = all
#								)
#
#	repx <- data[["editingFreq_x"]]
#	repx[is.na(repx)] <- 0
#	covx <- data[["cov2_x"]]
#	covx[is.na(covx)] <- 0
#	base_change_x <- data[["baseChange_x"]]
#
#	repy <- data[["editingFreq_y"]]
#	repy[is.na(repy)] <- 0
#	covy <- data[["cov2_y"]]
#	covy[is.na(covy)] <- 0
#	base_change_y <- data[["baseChange_y"]]
#
#	base_change <- cbind(data[["baseChange_x"]], data[["baseChange_y"]])
#	base_change <- apply(base_change, 1, function(x) {
#											 if (any(is.na(x))) {
#												 x[! is.na(x)]
#											 } else if(any(x %in% "no change")) {
#												 i <- x %in% "no change"
#												 if (all(i)) {
#													 "no change"
#												 } else {
#													 x[! i]
#												 }
#											 } else if (x[1] != x[2]) {
#												 "multiple"
#											 } else {
#												 x[1]
#											 }
#								})
#
#	df <- data.frame(
#									editingFreq_x = repx, 
#									cov_x = covx, 
#									editingFreq_y = repy, 
#									cov_y = covy,
#									baseChange = base_change,
#									baseChange_x = base_change_x, 
#									baseChange_y = base_change_y, 
#									stringsAsFactors = FALSE, check.names = FALSE)
#}