/*****Step*1* Import and explore data into STATA from MS Access Database using ODBC *******/
**clear all open records
clear
***Set memory if necessary
set memory 100m

/*************Create a working directory or folder ******************/
cd "D:\Afo_Agin2008-2020\AppliedFieldEpi2013\03_Stata_Data_Analyses"

****Importing***the**Data [1]Indivduals AND [2]Residences using odbc
odbc load, dsn("MS Access Database") table("dbo_Individuals") dialog(complete)
****
save Individuals.dta, replace 

**Count the number of records in Individuals
count
codebook Id

clear
odbc load, dsn("MS Access Database") table("dbo_Residences") dialog(complete)
save Residences.dta, replace 

codebook Id

**Count the number of records in Residences
count 
**
****Join the data Residences to Indivduals
merge m:1 Id using Individuals.dta
****Importing**the**Data

***Keep the variables of interest
keep Id StartDate InitiatingEventType EndDate TerminatingEventType Gender DoB DoD

***
/***Date conversion from short date to a long format
replace StartDate=cofd(StartDate)
format StartDate %tc

replace EndDate=cofd(EndDate)
format EndDate %tc

replace DoB=cofd(DoB)
format DoB %tc

replace DoD=cofd(DoD)
format DoD %tc
*/

*****Save the merger of residence and indivdual
save Step1_Residence_Individual.dta, replace


clear
odbc load, dsn("MS Access Database") table("dbo_Deaths") dialog(complete)

save Death.dta,replace

****Join the data Residences to Indivduals
merge 1:m Id using Step1_Residence_Individual.dta


