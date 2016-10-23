**
cd "C:\EpiField_2015"

use Step2_RecodeRename_Data.dta, clear

****** CONSISTENCY CHECK *******
**1 Check if StartDate=EndDate
count if(StartDate==EndDate)
**49 cases
**View the cases 
list Id StartEvent EndEvent StartDate EndDate if(StartDate==EndDate)
/*
       +-----------------------------------------------------------------------+
       |    Id   StartE~t   EndEvent            StartDate              EndDate |
       |-----------------------------------------------------------------------|
  534. | BKTES        ENU        OMG   01mar1992 00:00:00   01mar1992 00:00:00 |
 1038. | BLFSZ        ENU        OMG   01mar1992 00:00:00   01mar1992 00:00:00 |
 1092. | BLGVD        ENU        OMG   01mar1992 00:00:00   01mar1992 00:00:00 |
 1263. | BLLJT        ENU        OMG   01mar1992 00:00:00   01mar1992 00:00:00 |
 1659. | BLRFN        ENU        OMG   01mar1992 00:00:00   01mar1992 00:00:00 |
       |-----------------------------------------------------------------------|
 2173. | BMCFO        ENU        OMG   01mar1992 00:00:00   01mar1992 00:00:00 |
 2174. | BMCFP        ENU        OMG   01mar1992 00:00:00   01mar1992 00:00:00 |
 4037. | BNROC        ENU        OMG   01mar1992 00:00:00   01mar1992 00:00:00 |
 5165. | BOSML        ENU        OMG   01mar1992 00:00:00   01mar1992 00:00:00 |
 5693. | BSRKT        ENU        OMG   01mar1992 00:00:00   01mar1992 00:00:00 |

*/
list Id StartEvent EndEvent StartDate EndDate  if Id=="BKTES"
/*
       +-----------------------------------------------------------------------+
       |    Id   StartE~t   EndEvent            StartDate              EndDate |
       |-----------------------------------------------------------------------|
  534. | BKTES        ENU        OMG   01mar1992 00:00:00   01mar1992 00:00:00 |
       +-----------------------------------------------------------------------+
*/

***Resolution
**tag the case 
sort Id StartDate EndDate
by Id: generate Incon1=1 if (StartDate==EndDate)
*** Add a unit of time
replace EndDate=EndDate+(6*60*60*1000) if(EndDate==StartDate) 
/*
        +--------------------------------------------------------------------------------+
       |    Id   StartE~t   EndEvent            StartDate              EndDate   Incon1 |
       |--------------------------------------------------------------------------------|
  534. | BKTES        ENU        OMG   01mar1992 00:00:00   01mar1992 06:00:00        1 |
       +--------------------------------------------------------------------------------+
*/

sort Id StartDate EndDate
**2 Check if StartDate==EndDate[_n-1] (end date of the previous recod
count if(StartDate==EndDate[_n-1]) & (Id==Id[_n-1])
****17
list Id StartEvent EndEvent StartDate EndDate if(StartDate==EndDate[_n-1]) & (Id==Id[_n-1])

*** Browse the records - a window willl open
*browse Id StartDate EndDate StartEvent EndEvent if(EndDate[_n-1]==StartDate) & (Id==Id[_n-1])
***solve
*sort Id StartDate EndDate 
by Id: gen Incon2=2 if((StartDate==EndDate[_n-1]) & (Id==Id[_n-1])) 
list Id StartEvent EndEvent StartDate EndDate Incon2   if Incon2==2
/*
       +--------------------------------------------------------------------------------+
       |    Id   StartE~t   EndEvent            StartDate              EndDate   Incon2 |
       |--------------------------------------------------------------------------------|
 1456. | BLOGZ        IMG        DTH   15dec2003 00:00:00   24sep2007 00:00:00        2 |
 8227. | CQEFH        IMG        OMG   15dec2003 00:00:00   15dec2006 00:00:00        2 |
 8229. | CQEFK        IMG        OMG   15aug2004 00:00:00   15dec2006 00:00:00        2 |
 8231. | CQEFL        IMG        OMG   15aug2004 00:00:00   15dec2006 00:00:00        2 |
 8233. | CQEFO        IMG        OMG   15jun2004 00:00:00   15dec2006 00:00:00        2 |
       |--------------------------------------------------------------------------------|
 9706. | CRKBB        IMG        OMG   15jun2002 00:00:00   15jun2007 00:00:00        2 |
12085. | CTJRH        IMG        OMG   15aug2004 00:00:00   15dec2006 00:00:00        2 |
12155. | CTKXN        IMG        OMG   30sep1995 00:00:00   14apr2000 00:00:00        2 |
12156. | CTKXN        IMG        OMG   14apr2000 00:00:00   21jun2001 00:00:00        2 |
12161. | CTKXR        IMG        OMG   13dec2000 00:00:00   15dec2005 00:00:00        2 |
       |--------------------------------------------------------------------------------|
12223. | CTMHX        IMG        OMG   15jan2003 00:00:00   10dec2003 00:00:00        2 |
12701. | CTVTH        IMG        CUR   15oct2001 00:00:00   31dec2100 00:00:00        2 |
12703. | CTVTJ        IMG        CUR   15oct2001 00:00:00   31dec2100 00:00:00        2 |
12705. | CTVTL        IMG        OMG   15oct2001 00:00:00   15dec2005 00:00:00        2 |
12770. | CTWYB        IMG        OMG   15dec2003 00:00:00   07aug2005 00:00:00        2 |
       |--------------------------------------------------------------------------------|
12773. | CTWYD        IMG        OMG   15dec2003 00:00:00   07aug2005 00:00:00        2 |
12904. | CTZHE        IMG        OMG   15jul2002 00:00:00   15dec2004 00:00:00        2 |
       +--------------------------------------------------------------------------------+*/

	   list Id StartEvent EndEvent StartDate EndDate Incon2   if Id=="BLOGZ"
/*
       +--------------------------------------------------------------------------------+
       |    Id   StartE~t   EndEvent            StartDate              EndDate   Incon2 |
       |--------------------------------------------------------------------------------|
 1455. | BLOGZ        ENU        OMG   01mar1992 00:00:00   15dec2003 00:00:00        . |
 1456. | BLOGZ        IMG        DTH   15dec2003 00:00:00   24sep2007 00:00:00        2 |
       +--------------------------------------------------------------------------------
*/	   
replace StartDate=StartDate+(6*60*60*1000) if((StartDate==EndDate[_n-1]) & (Id==Id[_n-1])) 
 list Id StartEvent EndEvent StartDate EndDate Incon2   if Id=="BLOGZ"
 /*
       +--------------------------------------------------------------------------------+
       |    Id   StartE~t   EndEvent            StartDate              EndDate   Incon2 |
       |--------------------------------------------------------------------------------|
 1455. | BLOGZ        ENU        OMG   01mar1992 00:00:00   15dec2003 00:00:00        . |
 1456. | BLOGZ        IMG        DTH   15dec2003 06:00:00   24sep2007 00:00:00        2 |
       +--------------------------------------------------------------------------------+
*/

**check again
sort Id StartDate EndDate
count if(StartDate==EndDate[_n-1]) & (Id==Id[_n-1])


****3 Check those where born before enumeration
count if DoB>StartDate
**44

set linesize 250
list Id DoB StartEvent EndEvent StartDate EndDate if DoB>StartDate
/*
      +--------------------------------------------------------------------------------------------+
       |    Id                  DoB   StartE~t   EndEvent            StartDate              EndDate |
       |--------------------------------------------------------------------------------------------|
  114. | BKJPT                    .        ENU        OMG   01mar1992 00:00:00   09aug2006 00:00:00 |
  195. | BKLMV                    .        ENU        OMG   01mar1992 00:00:00   15aug1994 00:00:00 |
  333. | BKONM                    .        ENU        OMG   01mar1992 00:00:00   15jun1997 00:00:00 |
  433. | BKQBJ   22sep1992 00:00:00        ENU        OMG   01mar1992 00:00:00   02feb1994 00:00:00 |
  988. | BLEJT   28jul1992 00:00:00        ENU        OMG   01mar1992 00:00:00   15dec2002 00:00:00 |
       |--------------------------------------------------------------------------------------------
*/
**treat the case
drop if DoB>StartDate
**44


***********************
	   
******* end or censored date
**Replacing EndDate=31dec2100 with 31Dec2012
***
replace EndDate=clock("1Jan2013","DMY") if EndDate==clock("31dec2100","DMY")  

save Step3_Checked_Data.dta, replace
