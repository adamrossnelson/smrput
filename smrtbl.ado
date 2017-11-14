*! X.X.X Adam Ross Nelson 01nov2017 // Original version
*! Original author : Adam Ross Nelson
*! Maintained at   : https://github.com/adamrossnelson/smrput

capture program drop smrtbl
program smrtbl
	
	version 15
	syntax anything(id="arglist")

	capture putdocx describe
	if _rc {
		di in smcl as error "ERROR: No active docx."
		exit = 119
	}

	preserve
	
	local argcnt : word count `anything'
	/* Produce a two way table */
	if `argcnt' == 2 {
		capture decode `1', gen(dec`1')
		if _rc {
			capture confirm numeric variable `1'
			if !_rc {
				tostring `1', gen(dec`1')
			}
			else if _rc {
				gen dec`1' = `1'
			}
		}
		capture decode `2', gen(dec`2')
		if _rc {
			capture confirm numerica variable `2'
			if !_rc {
				tostring `2', gen(dec`2')
			}
			else if _rc {
				gen dec`2' = `2'
			}
		}
		tab dec`1' dec`2'
		local totrows = `r(r)' + 1
		local totcols = `r(c)' + 1
		if `totrows' > 40 | `totcols' > 20 {
			di in smcl as error "ERROR: smrtble supports a maximum of 40 rows and 20 columns. Reduce"
			di in smcl as error "the number of categories before proceeding."
			exit = 119
		}
		local rowtitle: variable label `1'
		local coltitle: variable label `2'
		putdocx paragraph
		putdocx text ("Table title: ")
		putdocx text ("_`1'_`2'_table"), italic linebreak 
		putdocx text ("Row variable label: ")
		putdocx text ("`rowtitle'."), italic linebreak 
		putdocx text ("Column variable label: ")
		putdocx text ("`coltitle'."), italic
		putdocx table _`1'_`2'_table = (`totrows',`totcols')
		qui levelsof dec`1', local(row_names)
		qui levelsof dec`2', local(col_names)
		local count = 2
		qui foreach lev in `row_names' {
			putdocx table _`1'_`2'_table(`count',1) = ("`lev'")
			local count = `count' + 1
		}
		local count = 2
		qui foreach lev in `col_names' {
			putdocx table _`1'_`2'_table(1,`count') = ("`lev'")
			local count = `count' + 1
		}
		local rowstep = 2
		local colstep = 2
		qui foreach rlev in `row_names' {
			foreach clev in `col_names' {
				count if dec`1' == "`rlev'" & dec`2' == "`clev'"
				local curcnt = `r(N)'
				putdocx table _`1'_`2'_table(`rowstep',`colstep') = ("`curcnt'")
				local colstep = `colstep' + 1
			}
			local colstep = 2
			local rowstep = `rowstep' + 1
		}
	}
	/* Produce a one way table */
	else if `argcnt' == 1 {
		capture decode `1', gen(dec`1')
		if _rc {
			capture confirm numeric variable `1'
			if !_rc {
				tostring `1', gen(dec`1')
			}
			else if _rc {
				gen dec`1' = `1'
			}
		}
		tab dec`1'
		local rowtitle: variable label `1'
		putdocx paragraph
		putdocx text ("Table title: ")
		putdocx text ("_`1'_table"), italic linebreak 
		putdocx text ("Row variable label: ")
		putdocx text ("`rowtitle'."), italic
		local totrows = `r(r)' + 1
		if `totrows' > 40 {
			di in smcl as error "ERROR: smrtble supports a maximum of 40 rows and 20 columns. Reduce"
			di in smcl as error "the number of categories before proceeding."
			exit = 119
		}
		putdocx table _`1'_table = (`totrows',2)
		qui levelsof dec`1', local(row_names)
		local count = 2
		putdocx table _`1'_table(1,2) = ("Counts")
		qui foreach lev in `row_names' {
			putdocx table _`1'_table(`count',1) = ("`lev'")
			count if dec`1' == "`lev'"
			local curcnt = `r(N)'
			putdocx table _`1'_table(`count',2) = ("`curcnt'")
			local count = `count' + 1
		}
	}
	/* Provide user feedback if arguments incorectly specified */
	else if `argcnt' > 2 {
		di in smcl as error "ERROR: Argumnets incorrectly specified (too many)."
		exit = 103
	}
	else if `argcnt' < 1 {
		di in smcl as error "ERROR: Argumnets incorrectly specified (too few)."
		exit = 102
	}
	restore

end
