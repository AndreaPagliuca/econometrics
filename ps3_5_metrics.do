** Author: Andrea Pagliuca 
** Project: PS3 Econometrics, year 1 LBS
** Date: 20 November 2023

** Clearing
clear all 

********************************************************************************
********************************************************************************
** EXERCISE 5
**Import dataset
import excel using "C:\Users\apagliuca\OneDrive - London Business School\Desktop\metrics\ps3_metrics\PS4data.xls", firstrow clear

********************************************************************************
********************************************************************************
** A

* Generate a time variable from year and quarter
gen time = yq(year, quarter)
sort time
tsset time

gen c = (realconsumptionofnondurables + realconsumptionofservices)/population

reg c L1.c L2.c L3.c L4.c

test L2.c = L3.c = L4.c = 0

********************************************************************************
********************************************************************************
** C and D

**IV regression
gen y = realdisposableincome/population
gen lg_c = log(c/L1.c)
gen lg_y = log(y/L1.y)

ivregress 2sls lg_c (lg_y = L2.lg_c L3.lg_c L4.lg_c L5.lg_c), r 
estat endogenous //test for endogeneity
estat overid //test for overi-identification
********************************************************************************
********************************************************************************














