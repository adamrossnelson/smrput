*! X.X.1 Adam Ross Nelson 20nov2017 // Merged smrfmn, smrcol, and smrtbl to same package.
*! X.X.X Adam Ross Nelson 05nov2017 // Original version
*! Original author : Adam Ross Nelson
*! Description     : Produces table of indicator variable statistics (through putdocx).
*! Maintained at   : https://github.com/adamrossnelson/smrput

capture program drop smrcol
program smrcol
	version 15
	local opts [, DESCription(string)]
	syntax anything(id="arglist") `opts'

	capture putdocx describe
	if _rc {
		di in smcl as error "ERROR: No active docx."
		exit = 119
	}
	local argcnt : word count `anything'
	
	if `argcnt' < 1 {
		di in smcl as error "ERROR: Argumnets incorrectly specified (too few). Must specify at least one indicator variable."
		exit = 102
	}

	forvalues cntr = 1/`argcnt' {
		local cntr = subinstr("``cntr''",",","",.)
		qui sum `cntr'
		capture assert `cntr' == 1 | `cntr' == 0
		if _rc {
			di in smcl as error "ERROR: Variables must be numberic & binary."
			exit = 452
		}
	}

	preserve

	putdocx paragraph
	putdocx text ("Table title: ")
	putdocx text ("_`1'_`2'_table"), italic linebreak
	// Test for missing description. If no description, provide generic.
	if "`description'" == "" {
		local description = "smrcol generated _`1'_`2'_table"
	}
	putdocx text ("Description: `description'")
	local totrows = `argcnt' + 1
	putdocx table _`1'_`2'_table = (`totrows',5)

	putdocx table _`1'_`2'_table(1,2) = ("Missing"), halign(center)
	putdocx table _`1'_`2'_table(1,3) = ("No"), halign(center)
	putdocx table _`1'_`2'_table(1,4) = ("Yes"), halign(center)
	putdocx table _`1'_`2'_table(1,5) = ("Pcnt Yes"), halign(center)

	local cntrow = 2
	forvalues cntr = 1/`argcnt' {
		local cntr = subinstr("``cntr''",",","",.)
		local vardesc: variable label `cntr'
		// Handle variables with empty variable label.  If no label, provide generic.
		if "`vardesc'" == "" {
			local vardesc = "Varname: `cntr'"
		}
		qui {
			putdocx table _`1'_`2'_table(`cntrow',1) = ("`vardesc'"), halign(center)
			count if `cntr' == .
			putdocx table _`1'_`2'_table(`cntrow',2) = (`r(N)'), halign(center)
			count if `cntr' == 0
			putdocx table _`1'_`2'_table(`cntrow',3) = (`r(N)'), halign(center)
			count if `cntr' == 1
			putdocx table _`1'_`2'_table(`cntrow',4) = (`r(N)'), halign(center)
			sum `cntr'
			local pcnt_of = round(`r(mean)' * 100,.01)
			putdocx table _`1'_`2'_table(`cntrow',5) = (`pcnt_of'), halign(center)
			local cntrow = `cntrow' + 1
		}
	}

	restore

	di "smrcol Table production successful. Table named: _`1'_`2'_table"
	
end

