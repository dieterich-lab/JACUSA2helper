# Guess paritioning of conditions and replicates from labels
.guess_conditions <- function(type, header_names) {
  if (type == .UNKNOWN_METHOD_TYPE) {
    stop("Unknown type: ", type)
  }
  
  conditions <- 0
  if (type == .CALL_PILEUP_METHOD_TYPE) {
    prefix <- .CALL_PILEUP_COLUMN
    cond_rep <- .extract_condition_replicate(header_names, prefix)
    conditions <- .find_conditions(cond_rep)
  } else if (type == .LRT_ARREST_METHOD_TYPE) {
    prefix1 <- .LRT_ARREST_COLUMN
    cond_rep1 <- .extract_condition_replicate(header_names, prefix1)
    conditions1 <- .find_conditions(cond_rep1)
    prefix2 <- .LRT_THROUGH_COLUMN
    cond_rep2 <- .extract_condition_replicate(header_names, prefix2)
    conditions2 <- .find_conditions(cond_rep2)
    if (conditions1 != conditions2) {
      stop("Error guessing conditions for lrt-arrest: cond1, cond2 = ", 
           conditions1, conditions2)
    }
    conditions <- conditions1
  } else if (type == .RT_ARREST_METHOD_TYPE) {
    prefix1 <- .RT_ARREST_COLUMN
    cond_rep1 <- .extract_condition_replicate(header_names, prefix1)
    conditions1 <- .find_conditions(cond_rep1)
    prefix2 <- .RT_THROUGH_COLUMN
    cond_rep2 <- .extract_condition_replicate(header_names, prefix2)
    conditions2 <- .find_conditions(cond_rep2)
    if (conditions1 != conditions2) {
      stop("Error guessing conditions for rt-arrest: cond1, cond2 = ", 
           conditions1, conditions2)
    }
    conditions <- conditions1
  } else {
    stop("Unknown type: ", type)
  }
  
  if (conditions < 1) {
    stop("Conditions could not be guessed from: ", header_names)
  }
  
  conditions
}

# find number of conditions 
.find_conditions <- function(cond_rep) {
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
.extract_condition_replicate <- function(header_names, prefix) {
  prefix <- paste0("^", prefix)
  i <- grep(prefix, header_names)
  if (length(i) == 0) {
    stop("Condition replicate part could not be extracted.")
  }
  cond_rep <- header_names[i]
  cond_rep <- gsub(prefix, "", cond_rep)
  
  cond_rep
}

# Determine file type base on header line
.guess_file_type <- function(line) {
  # header line: "#contig\t[...]" is required
  if (length(grep("^#contig", line)) == 0) {
    stop("Invalid header line: ", line)
  }
  
  type <- .UNKNOWN_METHOD_TYPE
  if (length(grep(.LRT_ARREST_POS_COLUMN, line)) > 0) { # lrt-arrest
    type <- .LRT_ARREST_METHOD_TYPE
  } else if(length(grep(paste0("\t", .RT_ARREST_COLUMN), line)) > 0) { # rt-arrest
    type <- .RT_ARREST_METHOD_TYPE
  } else if (length(grep(paste0("\t", .CALL_PILEUP_COLUMN), line)) > 0) { # call-pileup
    type <- .CALL_PILEUP_METHOD_TYPE
  } else { 
    stop("Result type could not be guessed from header: ", line)
  }
  
  type
}
