#' Add reference base to base call change ratio (e.g.: editing frequency) to a JACUSA2 object.
#' 
#' Adds base call change ratio (e.g.: editing frequency).
#' Adds key "ref_base2bc" key to JACUSA2 object.
#' 
#' @importFrom magrittr %>%
#' @param result object created by \code{read_result()}.
#' @param ref_field String ("ref_base" for 1 condition experiment) or integer of DNA condition 
#' @return result object with base change and base change ratio added
#' 
#' @export 
add_ref_base2bc_ratio <- function(result, ref_field) {
  # auto add missing fields
  if (is.null(result[["ref_base2bc"]])) {
    result <- add_ref_base2bc(result, ref_field)
  }

  ref_base <- c()
  if (ref_field != "ref_base") {
    # TODO condition 1 
  } else {
    ref_base <- result$ref_base
  }
   
  result$ref_base2bc_ratio <- get_bc_change_ratio(
    result[[ref_field]],
    result[, paste0("bc_", .BASES)]
  )

  result
}
