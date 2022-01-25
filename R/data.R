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
#' @format a tibble with 18 elements:
#' \itemize{
#'    \item id: Character string representing a unique identifier - created from contig, start, [end], and strand.
#'		\item contig: Character string representing the contig of the variant
#'		\item start: Numeric position of variant (>=0)
#'		\item end: Numeric corresponds to "start + 1"
#'		\item name: Character string. Name of used method \emph{call-2}
#'		\item score: Numeric value representing the test-statistc. Higher values indicate more divergent pileups
#'		\item strand: Character representing strand information; "+", "-", or "."(no strand information available)
#'		\item bases: Numeric tibble with representing counts for A, C, G, and T base calls.
#'    \item cov: Numeric value indicating the read coverage for this site
#'    \item backtrack1: Character - indicator if backtracking was used for condition 1.
#'    \item backtrack2: Character - indicator if backtracking was used for condition 2.
#'    \item backtrackP: Character - indicator if backtracking was used for condition pooled condition.
#'    \item reset1: Character - indicator if default estimation was unstable with for condition 1.
#'    \item reset2: Character - indicator if default estimation was unstable with for condition 2.
#'    \item resetP: Character - indicator if default estimation was unstable with for pooled condition.
#'		\item info: Character string separated with ";" provding additional data for this specific site. Empty field is equal to "*"
#'		\item filter: ";"-separated character string showing feature filter information. Empty field is equal to "*"
#'		\item ref: Character "A", "C", "G", "T", or "N" representing the reference base for this site - inverted when strand is "-".
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
#' @format a tibble with 18 elements:
#' \itemize{
#'    \item id: Character string representing a unique identifier - created from contig, start, [end], and strand.
#'		\item contig: Character string representing the contig of the variant
#'		\item start: Numeric position of variant (>=0)
#'		\item end: Numeric corresponds to "start + 1"
#'		\item name: Character string. Name of used method \emph{call-2}
#'		\item score: Numeric value representing the test-statistc. Higher values indicate more divergent pileups
#'		\item strand: Character representing strand information; "+", "-", or "."(no strand information available)
#'		\item bases: Numeric tibble with representing counts for A, C, G, and T base calls.
#'    \item cov: Numeric value indicating the read coverage for this site
#'    \item backtrack1: Character - indicator if backtracking was used for condition 1.
#'    \item backtrack2: Character - indicator if backtracking was used for condition 2.
#'    \item backtrackP: Character - indicator if backtracking was used for condition pooled condition.
#'    \item reset1: Character - indicator if default estimation was unstable with for condition 1.
#'    \item reset2: Character - indicator if default estimation was unstable with for condition 2.
#'    \item resetP: Character - indicator if default estimation was unstable with for pooled condition.
#'		\item info: Character string separated with ";" provding additional data for this specific site. Empty field is equal to "*"
#'		\item filter: ";"-separated character string showing feature filter information. Empty field is equal to "*"
#'		\item ref: Character "A", "C", "G", "T", or "N" representing the reference base for this site - inverted when strand is "-".
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
#' Check Section "Reverse transcriptase arrest events" in 
#' https://github.com/dieterich-lab/JACUSA2/blob/master/manual/manual.pdf
#' for details on pre-processing and mapping primary sequencing data.
#' 
#' @docType data
#' 
#' @usage data(HIVRT_rt_arrest)
#' 
#' @references Zhou, K. I.; Clark, W. C.; Pan, D. W.; Eckwahl, M. J.; Dai, Q. & Pan, T.
#' Pseudouridines have context-dependent mutation and stop rates in high-throughput sequencing 
#' RNA Biology, Informa UK Limited, 2018 , 15 , 892-900
#' 
#' @format a tibble with 22 elements:
#' \itemize{
#'    \item id: Character string representing a unique identifier - created from contig, start, [end], and strand.
#'		\item contig: Character string representing the contig of the variant
#'		\item start: Numeric position of variant (>=0)
#'		\item end: Numeric corresponds to "start + 1"
#'		\item name: Character string. Name of used method \emph{call-2}
#'		\item pvalue: Numeric value representing the pvalue of the test.
#'		\item strand: Character representing strand information; "+", "-", or "."(no strand information available)
#'		\item arrest: Numeric tibble with representing counts for A, C, G, and T base calls from arrest reads.
#'		\item through: Numeric tibble with representing counts for A, C, G, and T base calls from through reads.
#'		\item bases: Numeric tibble with representing counts for A, C, G, and T base calls.
#'    \item cov: Numeric value indicating the read coverage for this site
#'    \item arrest_rate: Numeric tibble representing the arrest rate for each sample.
#'    \item arrest_score: Numeric - test-statistic score.
#'    \item backtrack1: Character - indicator if backtracking was used for condition 1.
#'    \item backtrack2: Character - indicator if backtracking was used for condition 2.
#'    \item backtrackP: Character - indicator if backtracking was used for condition pooled condition.
#'    \item reset1: Character - indicator if default estimation was unstable with for condition 1.
#'    \item reset2: Character - indicator if default estimation was unstable with for condition 2.
#'    \item resetP: Character - indicator if default estimation was unstable with for pooled condition.
#'		\item info: Character string separated with ";" provding additional data for this specific site. Empty field is equal to "*"
#'		\item filter: ";"-separated character string showing feature filter information. Empty field is equal to "*"
#'		\item ref: Character "A", "C", "G", "T", or "N" representing the reference base for this site - inverted when strand is "-".
#' }
"HIVRT_rt_arrest"

#' JACUSA2 output for rt-arrest on SIIIRTMg condition in Zhou et. al 2018 data
#' 
#' Zhou2018 et al. 2018 map RNA modification of pseudouridine \eqn{\Psi} by chemically modifying
#' pseudouridines with carbodiimide (+CMC) and detecting arrest events that are induced by reverse
#' transcription stops in high-throughput sequencing under 3 different conditions (HIVRT, SIIIMn, and
#' SIIIMg). 
#' Result are for running JACUSA2 rt-arrest on processed pairwise +CMC and -CMC(control) data in SIIIRTMg condition are presented.
#'
#' Check Section "Reverse transcriptase arrest events" in 
#' https://github.com/dieterich-lab/JACUSA2/blob/master/manual/manual.pdf
#' for details on pre-processing and mapping primary sequencing data.
#' 
#' @docType data
#' 
#' @usage data(SIIIRTMg_rt_arrest)
#' 
#' @references Zhou, K. I.; Clark, W. C.; Pan, D. W.; Eckwahl, M. J.; Dai, Q. & Pan, T.
#' Pseudouridines have context-dependent mutation and stop rates in high-throughput sequencing 
#' RNA Biology, Informa UK Limited, 2018 , 15 , 892-900
#' 
#' @format a tibble with 22 elements:
#' \itemize{
#'    \item id: Character string representing a unique identifier - created from contig, start, [end], and strand.
#'		\item contig: Character string representing the contig of the variant
#'		\item start: Numeric position of variant (>=0)
#'		\item end: Numeric corresponds to "start + 1"
#'		\item name: Character string. Name of used method \emph{call-2}
#'		\item pvalue: Numeric value representing the pvalue of the test.
#'		\item strand: Character representing strand information; "+", "-", or "."(no strand information available)
#'		\item arrest: Numeric tibble with representing counts for A, C, G, and T base calls from arrest reads.
#'		\item through: Numeric tibble with representing counts for A, C, G, and T base calls from through reads.
#'		\item bases: Numeric tibble with representing counts for A, C, G, and T base calls.
#'    \item cov: Numeric value indicating the read coverage for this site
#'    \item arrest_rate: Numeric tibble representing the arrest rate for each sample.
#'    \item arrest_score: Numeric - test-statistic score.
#'    \item backtrack1: Character - indicator if backtracking was used for condition 1.
#'    \item backtrack2: Character - indicator if backtracking was used for condition 2.
#'    \item backtrackP: Character - indicator if backtracking was used for condition pooled condition.
#'    \item reset1: Character - indicator if default estimation was unstable with for condition 1.
#'    \item reset2: Character - indicator if default estimation was unstable with for condition 2.
#'    \item resetP: Character - indicator if default estimation was unstable with for pooled condition.
#'		\item info: Character string separated with ";" provding additional data for this specific site. Empty field is equal to "*"
#'		\item filter: ";"-separated character string showing feature filter information. Empty field is equal to "*"
#'		\item ref: Character "A", "C", "G", "T", or "N" representing the reference base for this site - inverted when strand is "-".
#' }
"SIIIRTMg_rt_arrest"

#' JACUSA2 output for rt-arrest on SIIIRTMn condition in Zhou et. al 2018 data
#' 
#' Zhou2018 et al. 2018 map RNA modification of pseudouridine \eqn{\Psi} by chemically modifying
#' pseudouridines with carbodiimide (+CMC) and detecting arrest events that are induced by reverse
#' transcription stops in high-throughput sequencing under 3 different conditions (HIVRT, SIIIMn, and
#' SIIIMg). 
#' Result are for running JACUSA2 rt-arrest on processed pairwise +CMC and -CMC(control) data in SIIIRTMn condition are presented.
#'
#' Check Section "Reverse transcriptase arrest events" 
#' https://github.com/dieterich-lab/JACUSA2/blob/master/manual/manual.pdf
#' for details on pre-processing and mapping primary sequencing data.
#' 
#' @docType data
#'
#' @usage data(SIIIRTMn_rt_arrest)
#' 
#' @references Zhou, K. I.; Clark, W. C.; Pan, D. W.; Eckwahl, M. J.; Dai, Q. & Pan, T.
#' Pseudouridines have context-dependent mutation and stop rates in high-throughput sequencing 
#' RNA Biology, Informa UK Limited, 2018 , 15 , 892-900
#' 
#' @format a tibble with 22 elements:
#' \itemize{
#'    \item id: Character string representing a unique identifier - created from contig, start, [end], and strand.
#'		\item contig: Character string representing the contig of the variant
#'		\item start: Numeric position of variant (>=0)
#'		\item end: Numeric corresponds to "start + 1"
#'		\item name: Character string. Name of used method \emph{call-2}
#'		\item pvalue: Numeric value representing the pvalue of the test.
#'		\item strand: Character representing strand information; "+", "-", or "."(no strand information available)
#'		\item arrest: Numeric tibble with representing counts for A, C, G, and T base calls from arrest reads.
#'		\item through: Numeric tibble with representing counts for A, C, G, and T base calls from through reads.
#'		\item bases: Numeric tibble with representing counts for A, C, G, and T base calls.
#'    \item cov: Numeric value indicating the read coverage for this site
#'    \item arrest_rate: Numeric tibble representing the arrest rate for each sample.
#'    \item arrest_score: Numeric - test-statistic score.
#'    \item backtrack1: Character - indicator if backtracking was used for condition 1.
#'    \item backtrack2: Character - indicator if backtracking was used for condition 2.
#'    \item backtrackP: Character - indicator if backtracking was used for condition pooled condition.
#'    \item reset1: Character - indicator if default estimation was unstable with for condition 1.
#'    \item reset2: Character - indicator if default estimation was unstable with for condition 2.
#'    \item resetP: Character - indicator if default estimation was unstable with for pooled condition.
#'		\item info: Character string separated with ";" provding additional data for this specific site. Empty field is equal to "*"
#'		\item filter: ";"-separated character string showing feature filter information. Empty field is equal to "*"
#'		\item ref: Character "A", "C", "G", "T", or "N" representing the reference base for this site - inverted when strand is "-".
#' }
"SIIIRTMn_rt_arrest"

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
#' This dataset exemplifies the usefullness of combining multiple pairwise comparisons and make them distinguishable by
#' "meta" field.
#' 
#' Check Section "Reverse transcriptase arrest events" in 
#' https://github.com/dieterich-lab/JACUSA2/blob/master/manual/manual.pdf
#' for details on pre-processing and mapping primary sequencing data.
#' 
#' @docType data
#' 
#' @usage data(Zhou2018_rt_arrest)
#' 
#' @references Zhou, K. I.; Clark, W. C.; Pan, D. W.; Eckwahl, M. J.; Dai, Q. & Pan, T.
#' Pseudouridines have context-dependent mutation and stop rates in high-throughput sequencing 
#' RNA Biology, Informa UK Limited, 2018 , 15 , 892-900
#' 
#' @format a tibble with 23 elements:
#' \itemize{
#'    \item id: Character string representing a unique identifier - created from contig, start, [end], and strand.
#'		\item contig: Character string representing the contig of the variant
#'		\item start: Numeric position of variant (>=0)
#'		\item end: Numeric corresponds to "start + 1"
#'		\item name: Character string. Name of used method \emph{call-2}
#'		\item pvalue: Numeric value representing the pvalue of the test.
#'		\item strand: Character representing strand information; "+", "-", or "."(no strand information available)
#'		\item arrest: Numeric tibble with representing counts for A, C, G, and T base calls from arrest reads.
#'		\item through: Numeric tibble with representing counts for A, C, G, and T base calls from through reads.
#'		\item bases: Numeric tibble with representing counts for A, C, G, and T base calls.
#'    \item cov: Numeric value indicating the read coverage for this site
#'    \item arrest_rate: Numeric tibble representing the arrest rate for each sample.
#'    \item arrest_score: Numeric - test-statistic score.
#'    \item backtrack1: Character - indicator if backtracking was used for condition 1.
#'    \item backtrack2: Character - indicator if backtracking was used for condition 2.
#'    \item backtrackP: Character - indicator if backtracking was used for condition pooled condition.
#'    \item reset1: Character - indicator if default estimation was unstable with for condition 1.
#'    \item reset2: Character - indicator if default estimation was unstable with for condition 2.
#'    \item resetP: Character - indicator if default estimation was unstable with for pooled condition.
#'		\item info: Character string separated with ";" provding additional data for this specific site. Empty field is equal to "*"
#'		\item filter: ";"-separated character string showing feature filter information. Empty field is equal to "*"
#'		\item ref: Character "A", "C", "G", "T", or "N" representing the reference base for this site - inverted when strand is "-".
#'    \item meta: Character string indicating the dataset. Here: "HIVRT", "SIIIRTMn", or "SIIIRTMn".
#' }
"Zhou2018_rt_arrest"

#' JACUSA2 output for call-2 on HIVRT condition in Zhou et. al 2018 data
#' 
#' Zhou2018 et al. 2018 map RNA modification of pseudouridine \eqn{\Psi} by chemically modifying
#' pseudouridines with carbodiimide (+CMC) and detecting arrest events that are induced by reverse
#' transcription stops in high-throughput sequencing under 3 different conditions (HIVRT, SIIIMn, and
#' SIIIMg). 
#' Result are for running JACUSA2 call-2 on processed pairwise +CMC and -CMC(control) data in HIVRT condition are presented.
#'
#' Check Section "Reverse transcriptase arrest events" in 
#' https://github.com/dieterich-lab/JACUSA2/blob/master/manual/manual.pdf
#' for details on pre-processing and mapping primary sequencing data.
#' 
#' @docType data
#' 
#' @usage data(HIVRT_call2)
#' 
#' @references Zhou, K. I.; Clark, W. C.; Pan, D. W.; Eckwahl, M. J.; Dai, Q. & Pan, T.
#' Pseudouridines have context-dependent mutation and stop rates in high-throughput sequencing 
#' RNA Biology, Informa UK Limited, 2018 , 15 , 892-900
#' 
#' @format a tibble with 18 elements:
#' \itemize{
#'    \item id: Character string representing a unique identifier - created from contig, start, [end], and strand.
#'		\item contig: Character string representing the contig of the variant
#'		\item start: Numeric position of variant (>=0)
#'		\item end: Numeric corresponds to "start + 1"
#'		\item name: Character string. Name of used method \emph{call-2}
#'		\item score: Numeric value representing the test-statistc. Higher values indicate more divergent pileups
#'		\item strand: Character representing strand information; "+", "-", or "."(no strand information available)
#'		\item bases: Numeric tibble with representing counts for A, C, G, and T base calls.
#'    \item cov: Numeric value indicating the read coverage for this site
#'    \item backtrack1: Character - indicator if backtracking was used for condition 1.
#'    \item backtrack2: Character - indicator if backtracking was used for condition 2.
#'    \item backtrackP: Character - indicator if backtracking was used for condition pooled condition.
#'    \item reset1: Character - indicator if default estimation was unstable with for condition 1.
#'    \item reset2: Character - indicator if default estimation was unstable with for condition 2.
#'    \item resetP: Character - indicator if default estimation was unstable with for pooled condition.
#'		\item info: Character string separated with ";" provding additional data for this specific site. Empty field is equal to "*"
#'		\item filter: ";"-separated character string showing feature filter information. Empty field is equal to "*"
#'		\item ref: Character "A", "C", "G", "T", or "N" representing the reference base for this site - inverted when strand is "-".
#' }
"HIVRT_call2"

#' JACUSA2 output for call-22 on SIIIRTMg condition in Zhou et. al 2018 data
#' 
#' Zhou2018 et al. 2018 map RNA modification of pseudouridine \eqn{\Psi} by chemically modifying
#' pseudouridines with carbodiimide (+CMC) and detecting arrest events that are induced by reverse
#' transcription stops in high-throughput sequencing under 3 different conditions (HIVRT, SIIIMn, and
#' SIIIMg). 
#' Result are for running JACUSA2 call-2 on processed pairwise +CMC and -CMC(control) data in SIIIRTMg condition are presented.
#'
#' Check Section "Reverse transcriptase arrest events" 
#' https://github.com/dieterich-lab/JACUSA2/blob/master/manual/manual.pdf
#' for details on pre-processing and mapping primary sequencing data.
#' 
#' @docType data
#' 
#' @usage data(SIIIRTMg_call2)
#' 
#' @references Zhou, K. I.; Clark, W. C.; Pan, D. W.; Eckwahl, M. J.; Dai, Q. & Pan, T.
#' Pseudouridines have context-dependent mutation and stop rates in high-throughput sequencing 
#' RNA Biology, Informa UK Limited, 2018 , 15 , 892-900
#' 
#' @format a tibble with 18 elements:
#' \itemize{
#'    \item id: Character string representing a unique identifier - created from contig, start, [end], and strand.
#'		\item contig: Character string representing the contig of the variant
#'		\item start: Numeric position of variant (>=0)
#'		\item end: Numeric corresponds to "start + 1"
#'		\item name: Character string. Name of used method \emph{call-2}
#'		\item score: Numeric value representing the test-statistc. Higher values indicate more divergent pileups
#'		\item strand: Character representing strand information; "+", "-", or "."(no strand information available)
#'		\item bases: Numeric tibble with representing counts for A, C, G, and T base calls.
#'    \item cov: Numeric value indicating the read coverage for this site
#'    \item backtrack1: Character - indicator if backtracking was used for condition 1.
#'    \item backtrack2: Character - indicator if backtracking was used for condition 2.
#'    \item backtrackP: Character - indicator if backtracking was used for condition pooled condition.
#'    \item reset1: Character - indicator if default estimation was unstable with for condition 1.
#'    \item reset2: Character - indicator if default estimation was unstable with for condition 2.
#'    \item resetP: Character - indicator if default estimation was unstable with for pooled condition.
#'		\item info: Character string separated with ";" provding additional data for this specific site. Empty field is equal to "*"
#'		\item filter: ";"-separated character string showing feature filter information. Empty field is equal to "*"
#'		\item ref: Character "A", "C", "G", "T", or "N" representing the reference base for this site - inverted when strand is "-".
#' }
"SIIIRTMg_call2"

#' JACUSA2 output for call-2 on SIIIRTMn condition in Zhou et. al 2018 data
#' 
#' Zhou2018 et al. 2018 map RNA modification of pseudouridine \eqn{\Psi} by chemically modifying
#' pseudouridines with carbodiimide (+CMC) and detecting arrest events that are induced by reverse
#' transcription stops in high-throughput sequencing under 3 different conditions (HIVRT, SIIIMn, and
#' SIIIMg). 
#' Result are for running JACUSA2 call-2 on processed pairwise +CMC and -CMC(control) data in SIIIRTMn condition are presented.
#'
#' Check Section "Reverse transcriptase arrest events" in 
#' https://github.com/dieterich-lab/JACUSA2/blob/master/manual/manual.pdf
#' for details on pre-processing and mapping primary sequencing data.
#' 
#' @docType data
#'
#' @usage data(SIIIRTMn_call2)
#' 
#' @references Zhou, K. I.; Clark, W. C.; Pan, D. W.; Eckwahl, M. J.; Dai, Q. & Pan, T.
#' Pseudouridines have context-dependent mutation and stop rates in high-throughput sequencing 
#' RNA Biology, Informa UK Limited, 2018 , 15 , 892-900
#' 
#' @format a tibble with 18 elements:
#' \itemize{
#'    \item id: Character string representing a unique identifier - created from contig, start, [end], and strand.
#'		\item contig: Character string representing the contig of the variant
#'		\item start: Numeric position of variant (>=0)
#'		\item end: Numeric corresponds to "start + 1"
#'		\item name: Character string. Name of used method \emph{call-2}
#'		\item score: Numeric value representing the test-statistc. Higher values indicate more divergent pileups
#'		\item strand: Character representing strand information; "+", "-", or "."(no strand information available)
#'		\item bases: Numeric tibble with representing counts for A, C, G, and T base calls.
#'    \item cov: Numeric value indicating the read coverage for this site
#'    \item backtrack1: Character - indicator if backtracking was used for condition 1.
#'    \item backtrack2: Character - indicator if backtracking was used for condition 2.
#'    \item backtrackP: Character - indicator if backtracking was used for condition pooled condition.
#'    \item reset1: Character - indicator if default estimation was unstable with for condition 1.
#'    \item reset2: Character - indicator if default estimation was unstable with for condition 2.
#'    \item resetP: Character - indicator if default estimation was unstable with for pooled condition.
#'		\item info: Character string separated with ";" provding additional data for this specific site. Empty field is equal to "*"
#'		\item filter: ";"-separated character string showing feature filter information. Empty field is equal to "*"
#'		\item ref: Character "A", "C", "G", "T", or "N" representing the reference base for this site - inverted when strand is "-".
#' }
"SIIIRTMn_call2"

#' Combined JACUSA2 output for call-2 on all conditions in Zhou et. al 2018 data
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
#' This dataset exemplifies the usefullness of combining multiple pairwise comparisons and make them distinguishable by
#' "meta" field.
#' 
#' @docType data
#' 
#' @usage data(Zhou2018_call2)
#' 
#' @references Zhou, K. I.; Clark, W. C.; Pan, D. W.; Eckwahl, M. J.; Dai, Q. & Pan, T.
#' Pseudouridines have context-dependent mutation and stop rates in high-throughput sequencing 
#' RNA Biology, Informa UK Limited, 2018 , 15 , 892-900
#' 
#' @format a tibble with 19 elements:
#' \itemize{
#'    \item id: Character string representing a unique identifier - created from contig, start, [end], and strand.
#'		\item contig: Character string representing the contig of the variant
#'		\item start: Numeric position of variant (>=0)
#'		\item end: Numeric corresponds to "start + 1"
#'		\item name: Character string. Name of used method \emph{call-2}
#'		\item score: Numeric value representing the test-statistc. Higher values indicate more divergent pileups
#'		\item strand: Character representing strand information; "+", "-", or "."(no strand information available)
#'		\item bases: Numeric tibble with representing counts for A, C, G, and T base calls.
#'    \item cov: Numeric value indicating the read coverage for this site
#'    \item backtrack1: Character - indicator if backtracking was used for condition 1.
#'    \item backtrack2: Character - indicator if backtracking was used for condition 2.
#'    \item backtrackP: Character - indicator if backtracking was used for condition pooled condition.
#'    \item reset1: Character - indicator if default estimation was unstable with for condition 1.
#'    \item reset2: Character - indicator if default estimation was unstable with for condition 2.
#'    \item resetP: Character - indicator if default estimation was unstable with for pooled condition.
#'		\item info: Character string separated with ";" provding additional data for this specific site. Empty field is equal to "*"
#'		\item filter: ";"-separated character string showing feature filter information. Empty field is equal to "*"
#'		\item ref: Character "A", "C", "G", "T", or "N" representing the reference base for this site - inverted when strand is "-".
#'    \item meta: Character string indicating the dataset. Here: "HIVRT", "SIIIRTMn", or "SIIIRTMn".
#' }
"Zhou2018_call2"

#' rRNA modification map of rRNAs according to Taika et al.
#' 
#' Data (18S, 28S, and 5.8S) has been extracted from retrieved from PMID: 30202881.
#'
#' @docType data
#' 
#' @usage data(rnam)
#' 
#' @references Landscape of the complete RNA chemical modifications in the human 80S ribosome
#'             Masato Taoka, Yuko Nobe, Yuka Yamaki, Ko Sato, Hideaki Ishikawa, 
#'             Keiichi Izumikawa, Yoshio Yamauchi, Kouji Hirota, Hiroshi Nakayama, 
#'             Nobuhiro Takahashi et al. 
#'             Nucleic Acids Research, Volume 46, Issue 18, 12 October 2018, Pages 9289–9298, 
#'             https://doi.org/10.1093/nar/gky811
#' 
#' @format a data.frame with 3 elements:
#' \itemize{
#'   \item rrna: String, either "18S", "28S", or "5.8S"
#'   \item pos: Numeric 1-index position.
#'   \item base: String, reference base(A, C, G, T) or modification(ac4C, AM, Cm, 
#'         Gm, m1A, m1acp3pusU, m3U, m5C, m62A, m6A, m7G, ND, psU, psUm, Um)
#' }
"rnam"

#' DART-seq from Meyer 2019
#' 
#' A complementary genetic approach is an extension of the TRIBE technique called DART-seq Meyer 2019.
#' Beyer applied DART-seq on HEK293 cells where the APOBEC domain was fused to the YTH domain from human YTHDF2 (WT and mutated).
#' In essence, new C-to-U editing events that are significantly enriched in the YTHDF2-WT, 
#' but not in the binding domain mutant are bona fide candidates for m6A RNA modification
#' 
#' @docType data
#' 
#' @usage data(DARTseq)
#' 
#' @references Meyer, Kate D., Nature methods, December 19, 2019
#' 
#' @format a tibble with 18 elements:
#' \itemize{
#'    \item id: Character string representing a unique identifier - created from contig, start, [end], and strand.
#'		\item contig: Character string representing the contig of the variant
#'		\item start: Numeric position of variant (>=0)
#'		\item end: Numeric corresponds to "start + 1"
#'		\item name: Character string. Name of used method \emph{call-2}
#'		\item score: Numeric value representing the test-statistc. Higher values indicate more divergent pileups
#'		\item strand: Character representing strand information; "+", "-", or "."(no strand information available)
#'		\item bases: Numeric tibble with representing counts for A, C, G, and T base calls.
#'    \item cov: Numeric value indicating the read coverage for this site
#'    \item backtrack1: Character - indicator if backtracking was used for condition 1.
#'    \item backtrack2: Character - indicator if backtracking was used for condition 2.
#'    \item backtrackP: Character - indicator if backtracking was used for condition pooled condition.
#'    \item reset1: Character - indicator if default estimation was unstable with for condition 1.
#'    \item reset2: Character - indicator if default estimation was unstable with for condition 2.
#'    \item resetP: Character - indicator if default estimation was unstable with for pooled condition.
#'		\item info: Character string separated with ";" provding additional data for this specific site. Empty field is equal to "*"
#'		\item filter: ";"-separated character string showing feature filter information. Empty field is equal to "*"
#'		\item ref: Character "A", "C", "G", "T", or "N" representing the reference base for this site - inverted when strand is "-".
#' }
"DARTseq"

#' MazF_FTO from Zhang et al. 2019
#' 
#' In the following, the use of of the rt-arrest function will be applied to a MazF digestion assay from Zhang et al. 2019.
#' Herein, 3 replicates of HEK293 mRNA were treated with FTO or mock treated and then subjected to a MazF digestion assay.
#' 
#' @docType data
#' 
#' @usage data(MazF_FTO)
#' 
#' @references Zhang, Zhang and Chen, Li-Qian and Zhao, Yu-Li and Yang, 
#'             Cai-Guang and Roundtree, Ian A. and Zhang, Zijie and Ren, Jian and 
#'             Xie, Wei and He, Chuan and Luo, Guan-Zheng
#'             Science advances, July 5, 2019
#'             
#' 
#' @format a tibble with 22 elements:
#' \itemize{
#'    \item id: Character string representing a unique identifier - created from contig, start, [end], and strand.
#'		\item contig: Character string representing the contig of the variant
#'		\item start: Numeric position of variant (>=0)
#'		\item end: Numeric corresponds to "start + 1"
#'		\item name: Character string. Name of used method \emph{call-2}
#'		\item pvalue: Numeric value representing the pvalue of the test.
#'		\item strand: Character representing strand information; "+", "-", or "."(no strand information available)
#'		\item arrest: Numeric tibble with representing counts for A, C, G, and T base calls from arrest reads.
#'		\item through: Numeric tibble with representing counts for A, C, G, and T base calls from through reads.
#'		\item bases: Numeric tibble with representing counts for A, C, G, and T base calls.
#'    \item cov: Numeric value indicating the read coverage for this site
#'    \item arrest_rate: Numeric tibble representing the arrest rate for each sample.
#'    \item arrest_score: Numeric - test-statistic score.
#'    \item backtrack1: Character - indicator if backtracking was used for condition 1.
#'    \item backtrack2: Character - indicator if backtracking was used for condition 2.
#'    \item backtrackP: Character - indicator if backtracking was used for condition pooled condition.
#'    \item reset1: Character - indicator if default estimation was unstable with for condition 1.
#'    \item reset2: Character - indicator if default estimation was unstable with for condition 2.
#'    \item resetP: Character - indicator if default estimation was unstable with for pooled condition.
#'		\item info: Character string separated with ";" provding additional data for this specific site. Empty field is equal to "*"
#'		\item filter: ";"-separated character string showing feature filter information. Empty field is equal to "*"
#'		\item ref: Character "A", "C", "G", "T", or "N" representing the reference base for this site - inverted when strand is "-".
#' }
"MazF_FTO"