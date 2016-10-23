cd "C:\EpiField_2015"

use Step3_Checked_Data.dta, clear

cap drop Multi
**Detecting the Indivduals with multiple records i.e. reisdence episode
gen Multi=1 if Id==Id[_n-1]

list Id DoB StartEvent EndEvent StartDate EndDate Multi if Mult==1
/*
       +--------------------------------------------------------------------------------------------+
       |    Id                  DoB   StartE~t   EndEvent            StartDate              EndDate |
       |--------------------------------------------------------------------------------------------|
  303. | BKNXW   22dec1982 00:00:00        IMG        OMG   15jun2004 00:00:00   15dec2008 00:00:00 |
 1449. | BLOGZ   24mar1961 00:00:00        IMG        DTH   15dec2003 06:00:00   24sep2007 00:00:00 |
 1572. | BLPSH   26sep1986 00:00:00        IMG        OMG   15jan2004 00:00:00   15mar2007 00:00:00 |
 2008. | BLYTP   13sep1974 00:00:00        IMG        OMG   15jun2002 00:00:00   15jun2007 00:00:00 |
 2356. | BMFGV   04apr1974 00:00:00        IMG        OMG   15jul2004 00:00:00   16jun2008 00:00:00 |
*/
**

list  Id DoB StartEvent EndEvent StartDate EndDate if Id=="BKNXW"
/*
       +--------------------------------------------------------------------------------------------+
       |    Id                  DoB   StartE~t   EndEvent            StartDate              EndDate |
       |--------------------------------------------------------------------------------------------|
  302. | BKNXW   22dec1982 00:00:00        ENU        OMG   01mar1992 00:00:00   10sep2002 00:00:00 |
  303. | BKNXW   22dec1982 00:00:00        IMG        OMG   15jun2004 00:00:00   15dec2008 00:00:00 |
       +--------------------------------------------------------------------------------------------+
*/
***RENAME VARIABLES
**Start with the end event. Keep the relavant variables 
keep Id DoB DoD Sex EndEvent EndDate 
*view the an example
list  Id DoB EndEvent EndDate if Id=="BKNXW"
/*     +------------------------------------------------------------+
       |    Id                  DoB   EndEvent              EndDate |
       |------------------------------------------------------------|
  302. | BKNXW   22dec1982 00:00:00        OMG   10sep2002 00:00:00 |
  303. | BKNXW   22dec1982 00:00:00        OMG   15dec2008 00:00:00 |
       +------------------------------------------------------------+
*/
***Create a variable or column with 1 to indicate people coming from this file
generate file=1


***Renaming the relavant variables
rename EndEvent EventCode
rename EndDate EventDate

**view the records
 list  Id DoB EventCode EventDate file if Id=="BKNXW"
/*
      +-------------------------------------------------------------------+
       |    Id                  DoB   EventC~e            EventDate   file |
       |-------------------------------------------------------------------|
  302. | BKNXW   22dec1982 00:00:00        OMG   10sep2002 00:00:00      1 |
  303. | BKNXW   22dec1982 00:00:00        OMG   15dec2008 00:00:00      1 |
       +-------------------------------------------------------------------+
*/

**Order the values by Id and EventDate and save
sort Id EventDate
save End_Event, replace

***Create new file with only start events
**Use the same recoded data data
use Step3_Checked_Data.dta, clear
***RENAME VARIABLES
keep Id DoB DoD Sex StartEvent StartDate
gen file=2
rename StartEvent EventCode
rename StartDate EventDate

**Order the values by Id and EventDate and save
sort  Id EventDate 
save Start_Event, replace

**list files 1
use End_Event.dta, clear 
list Id DoB EventCode EventDate file if Id=="BKNXW" & file==1

/*     +-------------------------------------------------------------------+
       |    Id                  DoB   EventC~e            EventDate   file |
       |-------------------------------------------------------------------|
  302. | BKNXW   22dec1982 00:00:00        OMG   10sep2002 00:00:00      1 |
  303. | BKNXW   22dec1982 00:00:00        OMG   15dec2008 00:00:00      1 |
     +-------------------------------------------------------------------+
*/
use Start_Event.dta, clear 
list Id DoB EventCode EventDate file if Id=="BKNXW" & file==2

/*     +-------------------------------------------------------------------+
       |    Id                  DoB   EventC~e            EventDate   file |
       |-------------------------------------------------------------------|
  302. | BKNXW   22dec1982 00:00:00        ENU   01mar1992 00:00:00      2 |
  303. | BKNXW   22dec1982 00:00:00        IMG   15jun2004 00:00:00      2 |
       +-------------------------------------------------------------------+
*/

****Append the two files (Starting and ending events) to have EHA format
use Start_Event, clear
count //20508
append using End_Event
count //41016

**view records
list Id DoB EventCode EventDate file if Id=="BKNXW"

**remove  variable file
drop file

**Labelling the generated variables
lab variable EventDate "EventDate"

***Label the values of variable EventCode
label define eventlab 0 "ENU" 1 "BTH" 2 "IMG" 3 "OMG" 4 "DTH" 5 "CUR", modify
lab value EventCode eventlab

codebook   EventCode
/*       
            tabulation:  Freq.   Numeric  Label
                          6941         0  ENU
                          3585         1  BTH
                          9982         2  IMG
                         10201         3  OMG
                          1274         4  DTH
                          9033         5  CU
*/
sort Id EventDate EventCode

list Id DoB Sex EventDate EventCode if  Id=="BKNXW"
**Long Format

/*
       +-------------------------------------------------------------------+
       |    Id                  DoB   EventC~e            EventDate   file |
       |-------------------------------------------------------------------|
  603. | BKNXW   22dec1982 00:00:00        ENU   01mar1992 00:00:00      2 |
  604. | BKNXW   22dec1982 00:00:00        OMG   10sep2002 00:00:00      1 |
  605. | BKNXW   22dec1982 00:00:00        IMG   15jun2004 00:00:00      2 |
  606. | BKNXW   22dec1982 00:00:00        OMG   15dec2008 00:00:00      1 |
       +-------------------------------------------------------------------+
*/

**previuos 
/*
       +--------------------------------------------------------------------------------------------+
       |    Id                  DoB   StartE~t   EndEvent            StartDate              EndDate |
       |--------------------------------------------------------------------------------------------|
  302. | BKNXW   22dec1982 00:00:00        ENU        OMG   01mar1992 00:00:00   10sep2002 00:00:00 |
  303. | BKNXW   22dec1982 00:00:00        IMG        OMG   15jun2004 00:00:00   15dec2008 00:00:00 |
       +--------------------------------------------------------------------------------------------+
*/
save Step4_Short_to_Long.dta, replace
