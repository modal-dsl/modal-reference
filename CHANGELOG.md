# Customizations

* New fields in table `Resource` (156) and page `Resource Card` (76)
* New fields in table `Res. Ledger Entry` (203)
* New fields in table `Res. Journal Line` (207) and page `Resource Ledger Entries` (202)
* New fields in table `Source Code Setup` (242) and page `Source Code Setup` (279)
* Respect fields in `Res. Jnl.-Post Line` codeunit (212)
* Page `Navigate` (334)
* Table `Default Dimension` (352) and page `Default Dimensions-Multiple` (542) and codeunit `DimensionManagement` (408)

# New Objects

**Tables**

*Master and Setup*
* `Seminar` (123456700)
* `Seminar Setup` (123456701)

*Documents*
* `Seminar Comment Line` (123456704)
* `Seminar Registration Header` (123456710)
* `Seminar Registration Line` (123456711)
* `Seminar Charge` (123456712)

*Posted Documents*
* `Posted Seminar Reg. Header` (123456718)
* `Posted Seminar Reg. Line` (123456719)
* `Posted Seminar Charge` (123456721)

*Posting*
* `Seminar Journal Line` (123456731)
* `Seminar Ledger Entry` (123456732)
* `Seminar Register` (123456733)

*Role Tailoring*
* `Seminar Cue` (123456740)
* `My Seminar` (123456741)

**Pages**

*Master and Setup*
* `Seminar Card` (123456700)
* `Seminar List` (123456701)
* `Seminar Setup` (123456702)

*Documents*
* `Seminar Comment Sheet` (123456706)
* `Seminar Comment List` (123456707)
* `Seminar Registration` (123456710)
* `Seminar Registration Subform` (123456711)
* `Seminar Registration List` (123456713)
* `Seminar Details FactBox` (123456717)
* `Seminar Charges` (123456724)

*Posted Documents*
* `Posted Seminar Registration` (123456734)
* `Posted Seminar Reg. Subform` (123456735)
* `Posted Seminar Reg. List` (123456736)
* `Posted Seminar Charges` (123456739)

*Posting*
* `Seminar Ledger Entries` (123456721)
* `Seminar Registers` (123456722)

*Statistics*
* `Seminar Statistics` (123456714)

*Role Tailoring*
* `Seminar Manager Role Center` (123456740)
* `Seminar Manager Activities` (123456741)
* `My Seminars` (123456742)

**Codeunits**

*Posting*
* `Seminar-Post` (123456700)
* `Seminar-Post (Yes/No)` (123456701)
* `Seminar Jnl.-Check Line` (123456731)
* `Seminar Jnl.-Post Line` (123456732)
* `Seminar Reg.-Show Ledger` (123456734)

*Interfaces*
* `SeminarMailManagement` (123456705)

*Web Services*
* `Seminar Web Services Ext.` (123456710)

*Testing*
* `Seminar Master Data Tests` (123456752)
* `Seminar Registration Tests` (123456753)
* `Seminar Posting Tests` (123456754)
* `Seminar Reporting Tests` (123456756)
* `Seminar Statistics Tests` (123456757)
* `Seminar Dimensions Tests` (123456758)

**Reports**

* Posting Batch Job: `Create Seminar Invoices` (123456700)
* List Report: `Seminar Reg.- Participant List` (123456701)
* Report Selection

**MenuSuites**

* Seminar Management Department Page