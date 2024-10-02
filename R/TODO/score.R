##' Context score around site.
##' 
##' @param gr with region column
##' @param col TODO
##' @return vector of numerics.
#context_score <- function(gr, col) {
#  stopifnot("region" %in% colnames(gr))  
#  
#  score <- paste0("context_", col)
#
#  gr %>% 
#    plyranges::group_by(region) %>% 
#    plyranges::summarise(score = sum(col))
#}
#
##' TODO
##'
##' @param gr TODO
##' @param width TODO
##' @return GRange object
#add_region <- function(gr, width = 5) {
#  # make sure we calculate context score on a site - NOT an interval!
#  stopifnot(all(IRanges::width(gr) == 1))
#
#  unique_extended_sites <- IRanges::resize(GenomicRanges::GRanges(gr), width, fix = "center") %>% unique()
#  hits <- IRanges::findOverlaps(gr, unique_extended_sites)
#  
#  # corresponding overlap in ...
#  region <- unique_extended_sites[S4Vectors::subjectHits(hits)] %>% .parse_overlap()
#
#    # and ...
#  overlap_gr <- gr[S4Vectors::queryHits(hits)]
#  overlap_gr$region <- region
#  
#  # TODO add offset
#  
#  overlap_gr
#}

##' @noRd
#.parse_overlap <- function(region) {
#  paste0(
#    GenomicRanges::seqnames(.), ":",
#    GenomicRanges::start(.), "-", GenomicRanges::end(.), ":",
#    GenomicRanges::strand(.)
#  )
#}
