#' TODO
#'
#' \code{add_rt_arrest_stat}
#'
#' @param jacusa List object created by \code{read_jacusa}.
#' @param read_matrix1 read info matrix for condition 1.
#' @param read_matrix2 read info matrix for condition 2.
#' @param aa Logical indicates if missing fields should added automatically.
#' 
#' @return Returns a JACUSA list object with the "stat" field set
#'
#' @examples#'
#' # TODO
#'
#' @export 
add_rt_arrest_stat <- function(jacusa,
                        read_matrix1 = jacusa$read_matrix1,
                        read_matrix2 = jacusa$read_matrix2,
                        aa = FALSE) {
  if (aa) {
    jacusa <- add_read_matrix(jacusa)
    read_matrix1 = jacusa$read_matrix1 
    read_matrix2 = jacusa$read_matrix2
  }
  
  # convert jacusa list to TODO
  sites <- length(jacusa[["contig"]])
  replicates1 <- length(get_read_str4condition(jacusa, 1))
  replicates2 <- length(get_read_str4condition(jacusa, 2))
  
  # init
  jacusa$pvalue <- 1
  for (i in 1:sites) {
    # arrest replicate 1 and 2
    arrest1 <- unname(sapply(jacusa$read_matrix1, '[[', i, "arrest", USE.NAMES = FALSE)) + 1 # add pseudocount
    arrest2 <- unname(sapply(jacusa$read_matrix2, '[[', i, "arrest", USE.NAMES = FALSE)) + 1
    
    # through replicate 1 and 2
    through1 <- unname(sapply(jacusa$read_matrix1, '[[', i, "through", USE.NAMES = FALSE)) + 1
    through2 <- unname(sapply(jacusa$read_matrix2, '[[', i, "through", USE.NAMES = FALSE)) + 1
    
    #
    total <- c(arrest1 + through1, arrest2 + through2)
    
    # data of one site 
    data <- data.frame(condition = c(rep(1, replicates1), rep(2, replicates2)),
                       total = total, 
                       arrest = c(arrest1, arrest2))
  
    # calculate statistic
    fmX <- aod::betabin(cbind(arrest, total - arrest) ~ condition, ~ 1, data = data, method = "BFGS")
    fm0 <- aod::betabin(cbind(arrest, total - arrest) ~ 1, ~ 1, data = data, method = "BFGS")
  
    # store pvalue
    jacusa$pvalue[i] <- aod::anova(fm0, fmX)@anova.table$"P(> Chi2)"[2]
  }

  jacusa
}