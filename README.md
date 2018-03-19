# 1. Smart Put
Repository for smrput (AKA "smart put" Stata packages) for use with putdocx. A family of commands that produces various tables through putdocx.

**Version 1.0 available from Boston College Statistical Software Components (SSC) :** `ssc install smrtbl`

**Version 2.0 (beta) available as of March 11, 2018 from this repo.**  
*After further testing, will push to ssc*  
*Version 2.0 is "ifable" and "inable"*  
*Version 2.0 also includes added options*

## 1.1. Table of Contents
<!-- TOC -->

- [1. Smart Put](#1-smart-put)
    - [1.1. Table of Contents](#11-table-of-contents)
    - [1.2. Introduction](#12-introduction)
    - [1.3. Table of available commands](#13-table-of-available-commands)
- [2. Installation](#2-installation)
    - [2.1. Boston College Statistical Software Components (SSC)](#21-boston-college-statistical-software-components-ssc)
    - [2.2. From GitHub.com](#22-from-githubcom)
- [3. Example](#3-example)
- [4. Known limitations](#4-known-limitations)
- [5. See Also](#5-see-also)

<!-- /TOC -->
## 1.2. Introduction

This package is inpsired by discussion on statalist.org. See for example: 

[https://www.statalist.org/for...post1416542](https://www.statalist.org/forums/forum/general-stata-discussion/general/1398211-putdocx-command?p=1416542#post1416542) and

[https://www.statalist.org/for...stata-result-to-word-file](https://www.statalist.org/forums/forum/general-stata-discussion/general/1377169-how-to-export-stata-result-to-word-file).

## 1.3. Table of available commands


Command Name | Description
-------------|------------
`smrtbl` | produces one- or two-way tables. 
`smrcol` | produces a table of dummy varaibles and related summary statistics. 
`smrfmn` | produces a table of summary statistics filtered by one or more indicator variables.

# 2. Installation

## 2.1. Boston College Statistical Software Components (SSC)

```Stata
ssc install smrtbl
```

## 2.2. From GitHub.com

Installing from GitHub.com will install the most recent development version.

```Stata
net install smrtbl, from(https://raw.githubusercontent.com/adamrossnelson/smrput/master/)
```

Upon installation command help and documenation available by `help smrtbl`, `help smrcol`, and/or `help smrfmn`.

# 3. Example

The following is a self contained example using smrtble.

```Stata
clear all
sysuse auto

capture putdocx clear

    // Begin a new word document.
putdocx begin

    // Provide introductory text.
putdocx paragraph, style(Title)
putdocx text ("Here is a demonstration of -smrtble-")
putdocx paragraph, style(Subtitle)
putdocx text ("More information at: https://github.com/adamrossnelson/smrput")

putdocx paragraph, style(Heading1)
putdocx text ("One-way examples")

    // Talk about the table to be presented.
putdocx paragraph
putdocx text ("Here is some text for demonstration purposes. Followed by a table:")
    // Call smrtbl with one variable name for a one-way table.
    // smrtbl must be called in the context of an open putdocx word document.
smrtbl foreign

putdocx paragraph
putdocx text ("For good measure, second example: two tables from a different data set:")
sysuse bplong.dta, clear
    // Call smrtbl with one variable name for a one-way table.
smrtbl when
smrtbl sex

    // Manage page spacing.
putdocx paragraph
putdocx text ("Be sure to see second page for more . . . ")
putdocx pagebreak

putdocx paragraph, style(Heading1)
putdocx text ("Two-way examples")
putdocx paragraph
putdocx text ("One example of a two-way table:")
    // Call smrtbl with one variable name for a two-way table.
smrtbl agegrp sex

    // Save word docx file.
putdocx save "GitHub.docx", replace
```
# 4. Known limitations

Version 1.0.0 did/does does not support `if` or `in` options.
Version 2.0.0 supports `if` and `in` options.

# 5. See Also

PUTDOCXFREQTABLE: Stata module to produce frequency oneway tables with putdocx.  
https://ideas.repec.org/c/boc/bocode/s458464.html
