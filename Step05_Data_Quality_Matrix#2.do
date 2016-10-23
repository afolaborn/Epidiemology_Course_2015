*cd "C:\EpiField_2015"

use Step4_Short_to_Long.dta, replace
   
sort Id EventDate EventCode
capture drop Prior_Event

*_n -position of observation
***Previous record
by Id: gen Prior_Event=EventCode[_n-1]
lab value Prior_Event eventlab

set linesize 250
tabulate Prior_Event EventCode
	  

/* 
Prior_Even |                    residence initiating event
         t |       ENU        BTH        IMG        OMG        DTH        CUR |     Total
-----------+------------------------------------------------------------------+----------
       ENU |         0          0          0      3,944        586      2,411 |     6,941 
       BTH |         0          0          0      1,466        186      1,933 |     3,585 
       IMG |         0          0          0      4,791        502      4,689 |     9,982 
       OMG |         0          0         47          0          0          0 |        47 
         . |     6,941      3,585      9,935          0          0          0 |    20,461 
-----------+------------------------------------------------------------------+----------
     Total |     6,941      3,585      9,982     10,201      1,274      9,033 |    41,016 
*/	   

compress
save Step5_EventHistory_Data.dta, replace
