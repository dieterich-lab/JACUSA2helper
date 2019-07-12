#' Formats JACUSA2 result object as in JACUSA2 result output.
#' 
#' Allows to peak at a result object and provides a user friendly format.
#' Converts data from long to wide format. @seealso \code{pack()}
#' 
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @return object structured as in JACUSA2 result format
#' 
#' @export
peak <- function(result) {
  pack(result)
}
