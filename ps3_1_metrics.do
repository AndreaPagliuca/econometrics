** Author: Andrea Pagliuca 
** Project: PS3 Econometrics, year 1 LBS
** Date: 10 November 2023

** Clearing
clear all 

********************************************************************************
********************************************************************************
** EXERCISE 1, MAXIMUM LIKELIHOOD ESTIMATOR

**Import dataset
import excel using "C:\Users\apagliuca\OneDrive - London Business School\Desktop\metrics\ps3_metrics\SP500Index.xlsx", firstrow clear

**Variables
rename DateofObservation time
rename LeveloftheSP500Index SP
gen x = log(SP / SP[1]) //x variable: x_t= d + x_{t-1} + e_t

**Estimators
gen d_ML = x[_N]/(_N-1) //ML estimate of d. Note that we divided by N-1 since we do not consider the first zero obs

tsset time
gen x_1 = x[_n-1]
egen sum_2 = total( (x- x_1 - d_ML)^2 )
gen sigma_ML = sqrt( 1/(_N-1) * sum_2) //ML estimate of sigma

********************************************************************************
********************************************************************************