context(".guess_file_type")

test_that(".guess_file_type works for call-1 as expected", {
  header_names <- c("#contig",
                    "start", "end",
                    "name",
                    "stat",
                    "strand",
                    "bases11",
                    "bases12")
  line <- paste0(header_names, collapse = "\t")
  expect_equal(.guess_file_type(line), .METHOD_TYPE_CALL_PILEUP)
})

test_that(".guess_file_type works for call-2 as expected", {
  header_names <- c("#contig",
                    "start", "end",
                    "name",
                    "stat",
                    "strand",
                    "bases11",
                    "bases21")
  line <- paste0(header_names, collapse = "\t")
  expect_equal(.guess_file_type(line), .METHOD_TYPE_CALL_PILEUP)
})

test_that(".guess_file_type works for rt-arrest as expected", {
  header_names <- c("#contig",
                    "start","end",
                    "name",
                    "stat",
                    "strand",
                    "arrest_bases11", "through_bases11",
                    "arrest_bases12", "through_bases12",
                    "arrest_bases21", "through_bases21",
                    "arrest_bases22", "through_bases22")
  line <- paste0(header_names, collapse = "\t")
  expect_equal(.guess_file_type(line), .METHOD_TYPE_CALL_PILEUP)
})

test_that(".guess_file_type works for lrt-arrest as expected", {
  header_names <- c("#contig",
                    "start", "end",
                    "name",
                    "stat",
                    "strand",
                    "arrest_pos")
  line <- paste0(header_names, collapse = "\t")
  expect_equal(.guess_file_type(line), .METHOD_TYPE_LRT_ARREST)
})

test_that(".guess_file_type fails on missing #contig", {
  line <- "contig\tbases11"
  expect_error(.guess_file_type(line), paste0("Invalid header line: ", line), fixed = TRUE)
})