# TODO finish

# Writes a JACUSA2 result object to a file.
# 
# Writes a JACUSA2 result object to a file. 
# The optional character \code{txt} will be added to the JACUSA2 header 
# along with the version of this package.
#
# @importFrom magrittr %>%
# @importFrom rlang syms
# @param result object create by \code{read_result}.
# @param file character string naming a file for writing 
# @param txt character string to be added to the JACUSA2 header.
# @export
#' @noRd
write_result <- function(result, file, txt = "") {
  if (.META_COND_COL %in% names(result)) {
    stop("result contains meta condition column: ", .META_COND_COL, 
         ". Write results individually!")
  }

  # requires type
  type <- attr(result, .ATTR_TYPE)
  if (type == .CALL_PILEUP) {
    packed <- .pack_call_pileup(result)
  } else if (type == .RT_ARREST) {
    packed <- .pack_rt_arrest(result)
  } else if (type == .LRT_ARREST) {
    packed <- .pack_lrt_arrest(result)
  } else {
    stop("Unknown type or missing attribute")
  }
  
  # type
  # default columns
  # pack the rest
  # optional header

  append = FALSE
  # restore old header
  jacusa_header <- attr(result, .ATTR_HEADER)

  # write JACUSA2 header
  if (nchar(txt) > 0) {
    helper_header <- .create_header(txt)
    jacusa_header <- c(jacusa_header, helper_header)
  }
  # write JACUSA2 header
  if (length(jacusa_header) > 0) {
    jacusa_header <- paste0("## ", jacusa_header)
    cat(jacusa_header, file = file, sep = "\n", append = append)
    append <- ! append
  }

  # write data header
  # add # to contig
  names(packed)[1] <- paste0("#", names(packed)[1])
  cat(names(packed), file = file, sep = "\t", append = append)
  cat("\n", file = file, sep = "", append = TRUE)

  # write data
  line <- NULL
  lines <- tidyr::unite(packed, line, sep = "\t") %>%
    dplyr::pull()
  cat(lines, file = file, sep = "\n", append = TRUE)
}


.bed6 <- function(name, score) {
  c("contig", "start", "end", "name", score, "strand")
}

.pack_bases <- function(df) {
  bases <- NULL
  
  tidyr::unite(df, bases, sep = ",")[["bases"]]
}

.pack_call_pileup <- function(result, name) {
  result[[.CALL_PILEUP_COL]]

  data_cols <- NULL # TODO
  cols <- c(.bed6("score"), data_cols, .INFO_COL, .FILTER_INFO_COL, .REF_BASE_COL)
  result[["name"]] <- name

  result[, cols]
}

.pack_rt_arrest <- function(result) {
  # TODO
}

.pack_lrt_arrest <- function(result) {
  # TODO
}

#
.create_header <- function(txt) {
  name <- methods::getPackageName()
  version <- utils::packageVersion(name)

  header <- paste(
    paste0("PN:", name), 
    paste0("VN:", version),
    paste0("DS:", txt),
    sep = "\t"
  )

  header
}
