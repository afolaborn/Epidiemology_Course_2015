use Step5_EventHistory_Data.dta, clear

list Id DoB Sex EventDate EventCode if  Id=="BKNXW"
/*
       |    Id                  DoB    Sex            EventDate   EventC~e |
       |-------------------------------------------------------------------|
  603. | BKNXW   22dec1982 00:00:00   Male   01mar1992 00:00:00        ENU |
  604. | BKNXW   22dec1982 00:00:00   Male   10sep2002 00:00:00        OMG |
  605. | BKNXW   22dec1982 00:00:00   Male   15jun2004 00:00:00        IMG |
  606. | BKNXW   22dec1982 00:00:00   Male   15dec2008 00:00:00        OMG |
*/

sort Id EventDate EventCode	
*Drop variaable if it exists					  
capture drop datebeg
***cond(_n==1, DoB, EventDate[_n-1]) 
**cond= condition **_n==1 - if it is the first record  ***DoB - Put DoB else put **EventDate[_n-1] the previous EventDate
by Id: gen double datebeg=cond(_n==1, DoB, EventDate[_n-1])
format datebeg %tc
lab var datebeg "Date of beginning"

/*
      +----------------------------------------------------------------------------------------+
       |    Id                  DoB    Sex              datebeg            EventDate   EventC~e |
       |----------------------------------------------------------------------------------------|
  603. | BKNXW   22dec1982 00:00:00   Male   22dec1982 00:00:00   01mar1992 00:00:00        ENU |
  604. | BKNXW   22dec1982 00:00:00   Male   01mar1992 00:00:00   10sep2002 00:00:00        OMG |
  605. | BKNXW   22dec1982 00:00:00   Male   10sep2002 00:00:00   15jun2004 00:00:00        IMG |
  606. | BKNXW   22dec1982 00:00:00   Male   15jun2004 00:00:00   15dec2008 00:00:00        OMG |
       +----------------------------------------------------------------------------------------+
*/
**Create the Censor variable

****Censored data are inherent in any analysis, like Event History or Survival Analysis, in which the outcome measures the Time to Event
sort Id EventDate EventCode
capture drop censor_death
**Create a censor death Death==4 . You can try codebook=EventCode
codebook EventCode

gen censor_death=EventCode==4 
tab censor_death, m

**Ye1 ar
display %20.0f 365.25 * 24 * 60 * 60 * 1000
*31557600000
***Generate a graph
set linesize 250
stset EventDate,  id(Id) failure(censor_death==1) origin(time DoB) time0(datebeg) scale(31557600000)

*count if datebeg>EventDate
count if datebeg==EventDate

sts graph

sts graph, hazard


cap drop S_EventDate
cap drop EventYear

gen double S_EventDate=EventDate
replace S_EventDate=dofc(S_EventDate)
format S_EventDate %td

/*     |    Id              datebeg            EventDate   S_Event~e   EventC~e |
       |------------------------------------------------------------------------|
  603. | BKNXW   22dec1982 00:00:00   01mar1992 00:00:00   01mar1992        ENU |
  604. | BKNXW   01mar1992 00:00:00   10sep2002 00:00:00   10sep2002        OMG |
  605. | BKNXW   10sep2002 00:00:00   15jun2004 00:00:00   15jun2004        IMG |
  606. | BKNXW   15jun2004 00:00:00   15dec2008 00:00:00   15dec2008        OMG |
       +------------------------------------------------------------------------+
*/
**Generate year variable
cap drop YYYY
gen YYYY=year(S_EventDate)
tab YYYY EventCode

tab YYYY Sex if EventCode==4
tab YYYY Sex if EventCode==4, row


stptime , by(YYYY) per(1000) at(0(10)70) dd(1)

stptime if YYYY==2010, per(1000) at(0(10)70) dd(1)

stptime if YYYY==2012, per(1000) at(1 5(5)70) dd(1)

sts graph if YYYY==2012, log by(Sex) hazard cih kernel(rectangle) width(2) xline(0(5)70)tmin(0) tmax(70) ///
xlab(0(5)70) ylab(,angle(horizontal)) title("Mortality rate")


/**
cap drop S_EventDate
cap drop EventYear
gen double S_EventDate=EventDate
replace S_EventDate=dofc(S_EventDate)
format S_EventDate %td

cap drop YYYY
gen YYYY=year(S_EventDate)
tab YYYY EventCode


cap drop ageday ageyear
gen ageday=res_eventd-datebirth
gen ageyear= int(ageday/365.25)
cap drop agebeg
*/



cap drop S_EventDate
cap drop EventYear
gen double S_EventDate=EventDate
replace S_EventDate=dofc(S_EventDate)
format S_EventDate %td

cap drop YYYY
gen YYYY=year(S_EventDate)
tab YYYY EventCode


cap drop ageday ageyear
gen ageday=res_eventd-datebirth
gen ageyear= int(ageday/365.25)
cap drop agebeg

sort Id EventDate EventCode	
*Drop variaable if it exists					  
capture drop datebeg
***cond(_n==1, DoB, EventDate[_n-1]) 
**cond= condition **_n==1 - if it is the first record  ***DoB - Put DoB else put **EventDate[_n-1] the previous EventDate
by Id: gen double datebeg=cond(_n==1, DoB, EventDate[_n-1])
format datebeg %tc
lab var datebeg "Date of beginning"
   