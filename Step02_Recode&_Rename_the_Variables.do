/*****Step*1* Recode and rename variables or columns *******/
**cd "C:\EpiField_2015"

*****Open the merged data file
use Step1_Residence_Individual.dta, clear

compress


****************************************************
***RECODE THE STARTING AND ENDING EVENTS
/********Start event ***********/
***View the variable
codebook  InitiatingEventType

/*   tabulation:  Freq.  Value
                          6977  "A"
                          3585  "B"
                          9990  "M"				*/
*A- Enumeration **B-Birth ***M-In-Migration
***Convert text to number
capture drop StEvent
encode InitiatingEventType, generate(StEvent)
***View the variable again
codebook StEvent

/*   tabulation:  Freq.   Numeric  Label
                          6977         1  A
                          3585         2  B
                          9990         3  M		*/

***Drop StartEvent if it exists
capture drop StartEvent
***recode StEvent & create a new variable StartEvent
recode StEvent (1=0 "ENU") (2=1 "BTH") (3=2 "IMG"), generate(StartEvent) label(StartEvent)
codebook StartEvent

***delete the redudant variables variables
drop InitiatingEventType StEvent 

****label the variable
label variable StartEvent "residence initiating event"
*
tabulate StartEvent

/*residence |
 initiating |
      event |      Freq.     Percent        Cum.
------------+-----------------------------------
        ENU |      6,977       33.95       33.95
        BTH |      3,585       17.44       51.39
        IMG |      9,990       48.61      100.00
------------+-----------------------------------
      Total |     20,552      100.00					*/


/*********End event ************/
***View the variable
codebook TerminatingEventType
**C-Current **D-Death  ***O-Out-Migration  

***Convert text to number
encode TerminatingEventType, gen(EdEvent)

capture drop EndEvent
recode EdEvent (3=3 "OMG") (2=4 "DTH") (1=5 "CUR"), gen(EndEvent) label(EndEvent)
drop  TerminatingEventType EdEvent 
lab variable EndEvent "residence terminating event"

/**************Gender *********/
codebook Gender
****F- Female ****M-Male
encode Gender, generate(XGender)
codebook XGender 

capture drop Sex
recode XGender (2=1 "Male") (1=2 "Female"), generate(Sex)
label variable Sex "Sex"
codebook Sex	

drop Gender XGender
lab var Sex "Gender"

***View a record of an individual
list Id DoB   StartEvent   EndEvent StartDate EndDate Sex  if Id=="DDFEJ"
/***
 +--------------------------------------------------------------------------+
 | Id     DoB   	  StartEvent  EndEvent   StartDate   EndDate    Sex  |
 |--------------------------------------------------------------------------|
 | DDFEJ  15jun1953   IMG         CUR        15feb2012   31dec2100  Male |
 +--------------------------------------------------------------------------+
**/


*****Save the merger of residence and indivdual
save Step2_RecodeRename_Data.dta, replace
