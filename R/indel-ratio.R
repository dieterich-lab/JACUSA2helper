#' Extract indel counts from the JACUSA2 info.
#' 
#' @param s character vector of the JACUSA2 info.
#' @param f character of one of the following fields: e.g. "del11", "del12", "ins21", "ins22"...
#' @return data.frame of the extracted info.
#' @export
extract_info <- function (s, f) 
{
    d = stringr::str_extract(s, paste0(f, "=[\\d\\,]+"))
    d[!is.na(d)] = .eend(d[!is.na(d)], nchar(f) + 2)
    d[is.na(d)] = "0,0"
    .sp_mat(d)
}
#' Extract indel scores from the JACUSA2 info.
#' 
#' @param s character vector of the JACUSA2 info.
#' @param f character of one of the following fields: "insertion_score", "deletion_score".
#' @return vector of the extracted scores
#' @export
extract_score <- function(s,f){ 
f = match.arg(f, c("insertion_score", "deletion_score"))
d = stringr::str_extract(s, paste0(f,'=[\\w-\\.]+'))
d[!is.na(d)] = .eend(d[!is.na(d)], nchar(f)+2)
d[is.na(d)]  = '0'
as.numeric(d)
}

.eend <- function(s,i) substr(s,i,nchar(s))
.sp_mat <- function(d)read.table(textConnection(d), sep=',')
