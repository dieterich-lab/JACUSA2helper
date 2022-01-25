# Overview

Auxiliary R package for the assessment of [JACUSA1.x](https://github.com/dieterich-lab/JACUSA) and [JACUSA2.x](https://github.com/dieterich-lab/JACUSA2) results.

## Install

Install JACUSA2helper by either downloading a specific [release](https://github.com/dieterich-lab/JACUSA2helper/releases) or 
install it directly from the repository via [devtools](https://www.r-project.org/nosvn/pandoc/devtools.html).

### Download
1. Download JACUSA2helper from [releases](https://github.com/dieterich-lab/JACUSA2helper/releases)
2. Change to directory where JACUSA2helper was saved
2. Start R
3. Install downloaded package by running: `install.packages("<DOWNLOADED-FILE>")`

### devtools
1. Make sure, [devtools](https://www.r-project.org/nosvn/pandoc/devtools.html) is installed
2. Start R
3. Run `install_github("dieterich-lab/JACUSA2helper", build_vignettes = TRUE)`

## Documentation
Check vignettes:
* `vignette(Introduction to JACUSA2helper)`
* `vignette(Analysis of DART-seq with JACUSA2helper)`
* `vignette(Analysis of m6A mapping by MazF with JACUSA2helper)`
* `vignette(Introduction to meta conditions with JACUSA2helper)`