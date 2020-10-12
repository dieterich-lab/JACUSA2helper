# Guess conditions and replicates from labels
.guess_cond_count <- function(type, header_names) {
  if (type == .UNKNOWN_METHOD) {
    stop("Unknown type: ", type)
  }
  
  cond_count <- 0
  if (type == .CALL_PILEUP) {
    prefix <- .CALL_PILEUP_COL
    cond_repl <- .extract_cond_repl(header_names, prefix)
    cond_count <- .find_cond_count(cond_repl)
  } else if (type %in% c(.RT_ARREST, .LRT_ARREST)) {
    cond_counts <- lapply(c(.ARREST_DATA_COL, .THROUGH_DATA_COL), function(x) {
      cond_repl <- .extract_cond_repl(header_names, x)
      return(.find_cond_count(cond_repl))
    })
    cond_count <- unique(unlist(cond_counts))
    if (length(cond_count) != 1) {
      stop("Error guessing conditions for lrt-arrest: cond1, cond2 = ", cond_count)
    }
  } else {
    stop("Unknown type: ", type)
  }
  
  if (cond_count < 1) {
    stop("Conditions could not be guessed from: ", header_names)
  }
  
  cond_count
}

# find number of conditions 
.find_cond_count <- function(cond_repl) {
  cond_count <- 1
  max_conds <- length(cond_repl)

  while (cond_count <= max_conds) {
    cond_count_nchar <- nchar(cond_count)
    cond <- substring(cond_repl, first = 1, last = cond_count_nchar)
    repl <- substring(cond_repl, first = cond_count_nchar + 1)
    if (all(nchar(cond) > 0 & nchar(repl) > 0) && 
        length(unique(cond)) == cond_count) {
      return(cond_count)
    }
    cond_count <- cond_count + 1
  }
  stop("Number of conditions could not be guessed")
}

# Extract condition-replicate part from header names
.extract_cond_repl <- function(header_names, prefix) {
  prefix_regex <- paste0("^", prefix, "[0-9]+")
  i <- grep(prefix_regex, header_names)
  if (length(i) == 0) {
    stop("Condition replicate part could not be extracted.")
  }
  cond_repl <- header_names[i]
  cond_repl <- gsub(prefix, "", cond_repl)
  
  cond_repl
}

# Determine file type base on header line
.guess_file_type <- function(line) {
  # header line: "#contig\t[...]" is required
  if (length(grep("^#contig", line)) == 0) {
    stop("Invalid header line: ", line)
  }
  
  type <- .UNKNOWN_METHOD
  if (length(grep(.LRT_ARREST_POS_COL, line)) > 0) { # lrt-arrest
    type <- .LRT_ARREST
  } else if(length(grep(paste0("\t", .ARREST_DATA_COL), line)) > 0) { # rt-arrest
    type <- .RT_ARREST
  } else if (length(grep(paste0("\t", .CALL_PILEUP_COL), line)) > 0) { # call-pileup
    type <- .CALL_PILEUP
  } else { 
    stop("Result type could not be guessed from header: ", line)
  }
  
  type
}
