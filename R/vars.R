# convenience: All possible bases
BASES <- c("A", "C", "G", "T")
EMPTY <- "*"
# convenience: DNA "->" RNA 
BC_CHANGE_SEP <- "->"
BC_CHANGE_NO_CHANGE <- "no change"

DATA_DESC <- "data_desc"

# Helpers defining supported types by JACUSA2.x
UNKNOWN_METHOD_TYPE <- "unknown"
# call and pileup cannot be distiguished by output
CALL_PILEUP_METHOD_TYPE <- "call-pileup"
RT_ARREST_METHOD_TYPE <- "rt-arrest"
LRT_ARREST_METHOD_TYPE <- "lrt-arrest"

# convenience: description data fields
CALL_PILEUP_COLUMN <- "bases"
RT_ARREST_COLUMN <- "arrest_bases"
RT_THROUGH_COLUMN <- "through_bases"
LRT_ARREST_COLUMN <- "arrest_bases"
LRT_THROUGH_COLUMN <- "through_bases"
LRT_ARREST_POS_COLUMN <- "arrest_pos"

# convenience: description info fields
INFO_COLUMN <- "info"
FILTER_INFO_COLUMN <- "filter_info"
REF_BASE_COLUMN <- "ref_base"
