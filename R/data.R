#TODO:
# update rdd rrd with JACUSA2
# standard for JACUSA2 R helper file format

#' Subset of RDDs detected by JACUSA2 in HEK-293 untreated cells
#'
#' @docType data
#' 
#' @usage data(rdd)
#'
#' @references
#' Piechotta, M.; Wyler, E.; Ohler, U.; Landthaler, M. & Dieterich, C.
#' JACUSA: site-specific identification of RNA editing events from replicate sequencing data 
#' BMC Bioinformatics, Springer Nature, 2017 , 18
#'
#' A dataset containing a subset of RNA DNA differences (RDDs) identified by JACUSA2 in untreated HEK-293 cells. 
#' The fields are as follows:
#' @format a tibble with 19 elements:
#' \itemize{
#'		\item contig: Character string representing the contig of the variant
#'		\item start: Numeric position of variant (>=0)
#'		\item end: Numeric corresponds to "start + 1"
#'		\item name: Character string. Currently, name of used method (\emph{call-\{1,2\}}, \emph{pileup}, \emph{rt-arrest}, or \emph{lrt-arrest})
#'		\item score: Numeric value representing the test-statistc. Higher values indicate more divergent pileups
#'		\item strand: Character representing strand information; "+", "-", or "."(no strand information available)
#'		\item info: Character string separated with ";" provding additional data for this specific site. Empty field is equal to "*"
#'		\item filter: ";TODO"-separated character string showing feature filter information. Empty field is equal to "*"
#'		\item ref: Character "A", "C", "G", "T", or "N" representing the reference base for this site - inverted when strand is "-".
#'		\item cond: Numeric value: "1"(here: gDNA) or "2"(here: RNA)
#'		\item repl: Numeric value: "1" for gDNA(no replicates) and "1" or "2" for RNA(1 replicate)
#'		\item bases: Numeric tibble with representing counts for A, C, G, and T base calls.
#'		\item bc: Observed base calls for this site. Combination of: "A", "C", "G", and "T"
#'    \item cov: Numeric value indicating the read coverage for this site
#' }
"rdd"

#' Subset of RRDs detected by JACUSA2 in HEK-293 ADAR KD and untreated cells
#' 
#' Data extrated from:
#' Piechotta, M.; Wyler, E.; Ohler, U.; Landthaler, M. & Dieterich, C.
#' JACUSA: site-specific identification of RNA editing events from replicate sequencing data 
#' BMC Bioinformatics, Springer Nature, 2017 , 18
#' 
#' @docType data
#' 
#' @usage data(rrd)
#'
#' @references
#' Piechotta, M.; Wyler, E.; Ohler, U.; Landthaler, M. & Dieterich, C.
#' JACUSA: site-specific identification of RNA editing events from replicate sequencing data 
#' BMC Bioinformatics, Springer Nature, 2017 , 18
#'
#' A dataset containing a subset of RNA RNA differences (RRDs) identified by JACUSA2 in ADAR KD and untreated HEK-293 cells. 
#' The fields are as follows:
#' @format a tibble with 19 elements:
#' \itemize{
#'		\item contig: Character string representing the contig of the variant
#'		\item start: Numeric position of variant (>=0)
#'		\item end: Numeric corresponds to "start + 1"
#'		\item name: Character string. Currently, name of used method (\emph{call-\{1,2\}}, \emph{pileup}, \emph{rt-arrest}, or \emph{lrt-arrest})
#'		\item score: Numeric value representing the test-statistc. Higher values indicate more divergent pileups
#'		\item strand: Character representing strand information; "+", "-", or "."(no strand information available)
#'		\item info: Character string separated with ";" provding additional data for this specific site. Empty field is equal to "*"
#'		\item filter: "TODO,"-separated character string showing feature filter information. Empty field is equal to "*"
#'		\item ref: Character "A", "C", "G", "T", or "N" representing the reference base for this site - inverted when strand is "-".
#'		\item bases: Numeric tibble representing counts for A, C, G, and T base calls.
#'		\item cond: Numeric value: "1"(here: ADAR KD) or "2"(here: unreated)
#'		\item repl Numeric value: "1" or "2" for all conditions
#'		\item bc: Observed base calls for this site. Combination of: "A", "C", "G", and "T"
#'    \item cov: Numeric value indicating the read coverage for this site
#' }
"rrd"

#' JACUSA2 output for rt-arrest on HIVRT condition in Zhou et. al 2018 data
#' 
#' Zhou2018 et al. 2018 map RNA modification of pseudouridine \eqn{\Psi} by chemically modifying
#' pseudouridines with carbodiimide (+CMC) and detecting arrest events that are induced by reverse
#' transcription stops in high-throughput sequencing under 3 different conditions (HIVRT, SIIIMn, and
#' SIIIMg). 
#' Result are for running JACUSA2 rt-arrest on processed pairwise +CMC and -CMC(control) data in HIVRT condition are presented.
#'
#' Check Section "Reverse transcriptase arrest events" in https://github.com/dieterich-lab/JACUSA2/manual/manual.pdf
#' for details on pre-processing and mapping primary sequencing data.
#' 
#' @docType data
#' 
#' @usage data(HIVRT)
#' 
#' @references Zhou, K. I.; Clark, W. C.; Pan, D. W.; Eckwahl, M. J.; Dai, Q. & Pan, T.
#' Pseudouridines have context-dependent mutation and stop rates in high-throughput sequencing 
#' RNA Biology, Informa UK Limited, 2018 , 15 , 892-900
#' 
#' @format a tibble with 19 elements:
#' \itemize{
##'		\item contig: Character string representing the contig of the variant
#'		\item start: Numeric position of variant (>=0)
#'		\item end: Numeric corresponds to "start + 1"
#'		\item name: Character string. Currently, name of used method (\emph{call-\{1,2\}}, \emph{pileup}, \emph{rt-arrest}, or \emph{lrt-arrest})
#'		\item score: Numeric value representing the test-statistc. Higher values indicate more divergent pileups
#'		\item strand: Character representing strand information; "+", "-", or "."(no strand information available)
#'		\item info: Character string separated with ";" provding additional data for this specific site. Empty field is equal to "*"
#'		\item filter: "TODO,"-separated character string showing feature filter information. Empty field is equal to "*"
#'		\item ref: Character "A", "C", "G", "T", or "N" representing the reference base for this site - inverted when strand is "-".
#'		\item bases: tibble representing counts for A, C, G, and T base calls for all reads (=arrest + through).
#'		\item arrest: tibble representing counts for A, C, G, and T base calls for arrest reads.
#'		\item through: tibble representing counts for A, C, G, and T base calls for through reads.
#'		\item cond: Numeric value: "1"(here: +GMC) or "2"(-GMC)
#'		\item repl: Numeric value: "1" or "2" for all conditions
#'		\item bc: Observed base calls for this site from all reads. Combination of: "A", "C", "G", and "T"
#'		\item bc_arrest: Observed base calls for this site for arrest reads. Combination of: "A", "C", "G", and "T"
#'		\item bc_through: Observed base calls for this site for through reads. Combination of: "A", "C", "G", and "T"
#'    \item cov: Numeric value indicating the read coverage for this site for all reads.
#'    \item cov_arrest: Numeric value indicating the read coverage for this site for arrest reads.
#'    \item cov_through: Numeric value indicating the read coverage for this site for through reads.
#' }
"HIVRT"

#' JACUSA2 output for rt-arrest on SIIIRTMg condition in Zhou et. al 2018 data
#' 
#' Zhou2018 et al. 2018 map RNA modification of pseudouridine \eqn{\Psi} by chemically modifying
#' pseudouridines with carbodiimide (+CMC) and detecting arrest events that are induced by reverse
#' transcription stops in high-throughput sequencing under 3 different conditions (HIVRT, SIIIMn, and
#' SIIIMg). 
#' Result are for running JACUSA2 rt-arrest on processed pairwise +CMC and -CMC(control) data in SIIIRTMg condition are presented.
#'
#' Check Section "Reverse transcriptase arrest events" in https://github.com/dieterich-lab/JACUSA2/manual/manual.pdf
#' for details on pre-processing and mapping primary sequencing data.
#' 
#' @docType data
#' 
#' @usage data(SIIIRTMg)
#' 
#' @references Zhou, K. I.; Clark, W. C.; Pan, D. W.; Eckwahl, M. J.; Dai, Q. & Pan, T.
#' Pseudouridines have context-dependent mutation and stop rates in high-throughput sequencing 
#' RNA Biology, Informa UK Limited, 2018 , 15 , 892-900
#' 
#' @format a tibble with 19 elements:
#' \itemize{
##'		\item contig: Character string representing the contig of the variant
#'		\item start: Numeric position of variant (>=0)
#'		\item end: Numeric corresponds to "start + 1"
#'		\item name: Character string. Currently, name of used method (\emph{call-\{1,2\}}, \emph{pileup}, \emph{rt-arrest}, or \emph{lrt-arrest})
#'		\item score: Numeric value representing the test-statistc. Higher values indicate more divergent pileups
#'		\item strand: Character representing strand information; "+", "-", or "."(no strand information available)
#'		\item info: Character string separated with ";" provding additional data for this specific site. Empty field is equal to "*"
#'		\item filter: "TODO,"-separated character string showing feature filter information. Empty field is equal to "*"
#'		\item ref: Character "A", "C", "G", "T", or "N" representing the reference base for this site - inverted when strand is "-".
#'		\item bases: tibble representing counts for A, C, G, and T base calls for all reads (=arrest + through).
#'		\item arrest: tibble representing counts for A, C, G, and T base calls for arrest reads.
#'		\item through: tibble representing counts for A, C, G, and T base calls for through reads.
#'		\item cond: Numeric value: "1"(here: +GMC) or "2"(-GMC)
#'		\item repl: Numeric value: "1" or "2" for all conditions
#'		\item bc: Observed base calls for this site from all reads. Combination of: "A", "C", "G", and "T"
#'		\item bc_arrest: Observed base calls for this site for arrest reads. Combination of: "A", "C", "G", and "T"
#'		\item bc_through: Observed base calls for this site for through reads. Combination of: "A", "C", "G", and "T"
#'    \item cov: Numeric value indicating the read coverage for this site for all reads.
#'    \item cov_arrest: Numeric value indicating the read coverage for this site for arrest reads.
#'    \item cov_through: Numeric value indicating the read coverage for this site for through reads.
#' }
"SIIIRTMg"

#' JACUSA2 output for rt-arrest on SIIIRTMn condition in Zhou et. al 2018 data
#' 
#' Zhou2018 et al. 2018 map RNA modification of pseudouridine \eqn{\Psi} by chemically modifying
#' pseudouridines with carbodiimide (+CMC) and detecting arrest events that are induced by reverse
#' transcription stops in high-throughput sequencing under 3 different conditions (HIVRT, SIIIMn, and
#' SIIIMg). 
#' Result are for running JACUSA2 rt-arrest on processed pairwise +CMC and -CMC(control) data in SIIIRTMn condition are presented.
#'
#' Check Section "Reverse transcriptase arrest events" in https://github.com/dieterich-lab/JACUSA2/manual/manual.pdf
#' for details on pre-processing and mapping primary sequencing data.
#' 
#' @docType data
#'
#' @usage data(SIIIRTMn)
#' 
#' @references Zhou, K. I.; Clark, W. C.; Pan, D. W.; Eckwahl, M. J.; Dai, Q. & Pan, T.
#' Pseudouridines have context-dependent mutation and stop rates in high-throughput sequencing 
#' RNA Biology, Informa UK Limited, 2018 , 15 , 892-900
#' 
#' @format a tibble with 19 elements:
#' \itemize{
##'		\item contig: Character string representing the contig of the variant
#'		\item start: Numeric position of variant (>=0)
#'		\item end: Numeric corresponds to "start + 1"
#'		\item name: Character string. Currently, name of used method (\emph{call-\{1,2\}}, \emph{pileup}, \emph{rt-arrest}, or \emph{lrt-arrest})
#'		\item score: Numeric value representing the test-statistc. Higher values indicate more divergent pileups
#'		\item strand: Character representing strand information; "+", "-", or "."(no strand information available)
#'		\item info: Character string separated with ";" provding additional data for this specific site. Empty field is equal to "*"
#'		\item filter: "TODO,"-separated character string showing feature filter information. Empty field is equal to "*"
#'		\item ref: Character "A", "C", "G", "T", or "N" representing the reference base for this site - inverted when strand is "-".
#'		\item bases: tibble representing counts for A, C, G, and T base calls for all reads (=arrest + through).
#'		\item arrest: tibble representing counts for A, C, G, and T base calls for arrest reads.
#'		\item through: tibble representing counts for A, C, G, and T base calls for through reads.
#'		\item cond: Numeric value: "1"(here: +GMC) or "2"(-GMC)
#'		\item repl: Numeric value: "1" or "2" for all conditions
#'		\item bc: Observed base calls for this site from all reads. Combination of: "A", "C", "G", and "T"
#'		\item bc_arrest: Observed base calls for this site for arrest reads. Combination of: "A", "C", "G", and "T"
#'		\item bc_through: Observed base calls for this site for through reads. Combination of: "A", "C", "G", and "T"
#'    \item cov: Numeric value indicating the read coverage for this site for all reads.
#'    \item cov_arrest: Numeric value indicating the read coverage for this site for arrest reads.
#'    \item cov_through: Numeric value indicating the read coverage for this site for through reads.
#' }
"SIIIRTMn"

#' Combined JACUSA2 output for rt-arrest on all conditions in Zhou et. al 2018 data
#' 
#' Zhou2018 et al. 2018 map RNA modification of pseudouridine \eqn{\Psi} by chemically modifying
#' pseudouridines with carbodiimide (+CMC) and detecting arrest events that are induced by reverse
#' transcription stops in high-throughput sequencing under 3 different conditions (HIVRT, SIIIMn, and
#' SIIIMg). 
#' A combined version of all conditions and their pairwise +CMC and -CMC(control) comparisons is presented.
#' The data structure contains an additional field "meta_condition" that corresponds and identifies the 
#' condition from Zhou 2018: 
#' \itemize{
#'   \item HIVRT, 
#'   \item SIIIMn, and
#'   \item SIIIMg.
#' }
#' This dataset exemplifies the usefullness of combinding multiple pairwise comparisons and make them distinguishable by
#' "meta" field.
#' 
#' Check Section "Reverse transcriptase arrest events" in https://github.com/dieterich-lab/JACUSA2/manual/manual.pdf
#' for details on pre-processing and mapping primary sequencing data.
#' 
#' @docType data
#' 
#' @usage data(Zhou2018)
#' 
#' @references Zhou, K. I.; Clark, W. C.; Pan, D. W.; Eckwahl, M. J.; Dai, Q. & Pan, T.
#' Pseudouridines have context-dependent mutation and stop rates in high-throughput sequencing 
#' RNA Biology, Informa UK Limited, 2018 , 15 , 892-900
#' 
#' @format a tibble with 20 elements:
#' \itemize{
#'		\item contig: Character string representing the contig of the variant
#'		\item start: Numeric position of variant (>=0)
#'		\item end: Numeric corresponds to "start + 1"
#'		\item name: Character string. Currently, name of used method (\emph{call-\{1,2\}}, \emph{pileup}, \emph{rt-arrest}, or \emph{lrt-arrest})
#'		\item score: Numeric value representing the test-statistc. Higher values indicate more divergent pileups
#'		\item strand: Character representing strand information; "+", "-", or "."(no strand information available)
#'		\item info: Character string separated with ";" provding additional data for this specific site. Empty field is equal to "*"
#'		\item filter: ","-separated character string showing feature filter information. Empty field is equal to "*"
#'		\item ref: Character "A", "C", "G", "T", or "N" representing the reference base for this site - inverted when strand is "-".
#'		\item bases: tibble representing counts for A, C, G, and T base calls for all reads (=arrest + through).
#'		\item arrest: tibble representing counts for A, C, G, and T base calls for arrest reads.
#'		\item through: tibble representing counts for A, C, G, and T base calls for through reads.
#'		\item cond: Numeric value: "1"(here: +GMC) or "2"(-GMC)
#'		\item repl: Numeric value: "1" or "2" for all conditions
#'		\item bc: Observed base calls for this site from all reads. Combination of: "A", "C", "G", and "T"
#'		\item bc_arrest: Observed base calls for this site for arrest reads. Combination of: "A", "C", "G", and "T"
#'		\item bc_through: Observed base calls for this site for through reads. Combination of: "A", "C", "G", and "T"
#'    \item cov: Numeric value indicating the read coverage for this site for all reads.
#'    \item cov_arrest: Numeric value indicating the read coverage for this site for arrest reads.
#'    \item cov_through: Numeric value indicating the read coverage for this site for through reads.
#'    \item meta: Character string indicating the dataset. Here: "HIVRT", "SIIIRTMn", or "SIIIRTMn".
#' }
"Zhou2018"
