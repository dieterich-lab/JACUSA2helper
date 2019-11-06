# TODO
#=====

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
# @param txt character string to be added to the JACUSA2 header. If "", nothing will be added.
# @export

#' @noRd
write_result <- function(result, file, txt = "") {
  require_method(result)
  if (META_CONDITION_COLUMN %in% names(result)) {
    stop("result contains meta condition column: ", META_CONDITION_COLUMN, 
         ". Write results individually!")
  }

  packed <- pack(result)

  bed_index <- names(packed) %in% BED_COLUMNS
  packed <- dplyr::select(packed, !!!rlang::syms(c(BED_COLUMNS, names(packed)[! bed_index])))

  append = FALSE
  # restore old header
  jacusa_header <- get_jacusa_header(result)
  # write JACUSA2 header
  if (nchar(txt) > 0) {
    helper_header <- create_helper_headert(xt)
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
  lines <- tidyr::unite(packed, line, sep = "\t") %>%
    dplyr::pull()
  cat(lines, file = file, sep = "\n", append = TRUE)
}

#' @noRd
create_helper_header <- function(txt) {
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
