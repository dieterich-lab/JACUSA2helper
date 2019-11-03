#' @noRd
get_condition_replicate <- function(type, header_names) {
  if (type == UNKNOWN_METHOD_TYPE) {
    stop("Unknown type: ", type)
  }
  
  cond_rep <- NULL
  if (type == CALL_PILEUP_METHOD_TYPE) {
    prefix <- BASES_COLUMN
    cond_rep <- extract_condition_replicate(header_names, prefix)
  } else if (type %in% c(RT_ARREST_METHOD_TYPE, LRT_ARREST_METHOD_TYPE)) {
    prefix1 <- ARREST_COLUMN
    cond_rep1 <- extract_condition_replicate(header_names, prefix1)
    prefix2 <- THROUGH_COLUMN
    cond_rep2 <- extract_condition_replicate(header_names, prefix2)
    if (! all(cond_rep1 == cond_rep2)) {
      stop("Error guessing conditions for ", type, ":", 
           "cond_rep1 = ", cond_rep1, " and ", 
           "cond_rep2 = ", cond_rep2
      )
    }
    cond_rep <- cond_rep1
  } else {
    stop("Unknown type: ", type)
  }
  
  if (is.null(cond_rep)) {
    stop("cond_rep could not be guessed from: ", header_names)
  }
  
  cond_rep
}

# find number of conditions 
#' @noRd
find_conditions <- function(cond_rep) {
  conditions <- 1
  max_conditions <- length(cond_rep)

  while (conditions <= max_conditions) {
    condition_nchar <- nchar(conditions)
    condition <- substring(cond_rep, first = 1, last = condition_nchar)
    replicate <- substring(cond_rep, first = condition_nchar + 1)
    if (all(nchar(condition) > 0 & nchar(replicate) > 0) && 
        length(unique(condition)) == conditions) {
      return(conditions)
    }
    conditions <- conditions + 1
  }
  stop("Number of conditions could not be guessed")
}

# Extract condition-replicate part from header names
#' @noRd
extract_condition_replicate <- function(header_names, prefix) {
  prefix <- paste0("^", prefix)
  i <- grep(paste0(prefix, ".+[0-9]+$"), header_names)
  
  if (length(i) == 0) {
    stop("Condition replicate part could not be extracted.")
  }
  cond_rep <- header_names[i]
  cond_rep <- gsub(prefix, "", cond_rep)
  
  cond_rep
}

# Determine file type base on header line
#' @noRd
guess_file_type <- function(header_line) {
  # header line: "#contig\t[...]" is required
  if (length(grep("^#contig", header_line)) == 0) {
    stop("Invalid header line: ", header_line)
  }

  type <- UNKNOWN_METHOD_TYPE
  if (length(grep(ARREST_POS_COLUMN, header_line)) > 0) { # lrt-arrest
    type <- LRT_ARREST_METHOD_TYPE
  } else if(length(grep(paste0("\t", ARREST_COLUMN), header_line)) > 0) { # rt-arrest
    type <- RT_ARREST_METHOD_TYPE
  } else if (length(grep(paste0("\t", BASES_COLUMN), header_line)) > 0) { # call-pileup
    type <- CALL_PILEUP_METHOD_TYPE
  } else { 
    stop("Result type could not be guessed from header: ", header_line)
  }

  type
}
