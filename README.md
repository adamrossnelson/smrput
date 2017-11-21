# Smart Put
Repository for smrput (AKA "smart put" Stata packages) for use with putdocx. A family of commands that produces various tables through putdocx.

## Introduction

This package is inpsired by discussion on statalist.org. See for example: https://www.statalist.org/forums/forum/general-stata-discussion/general/1398211-putdocx-command?p=1416542#post1416542 and https://www.statalist.org/forums/forum/general-stata-discussion/general/1377169-how-to-export-stata-result-to-word-file.

`smrtbl` produces one- or two-way tables. `smrcol` produces a table of dummy varaibles and related summary statistics. `smrfmn` produces a table of summary statistics filtered by one or more indicator variables.

## Installation

```Stata
net install smrtbl, from(https://raw.githubusercontent.com/adamrossnelson/smrput/master/)
```

Upon installation command help and documenation available by `help smrtbl`, `help smrcol`, and/or `help smrfmn`.

## Example

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

## Known limitations

Does not support `if` or `in` statements.