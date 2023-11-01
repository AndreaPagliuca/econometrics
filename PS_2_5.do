** Author: Andrea Pagliuca 
** Project: PS2 Econometrics, year 1 LBS
** Date: 1 November 2023

** Clearing
clear all 

********************************************************************************
********************************************************************************
**Parameters
set seed 54321
scalar beta = 0
scalar T = 100
matrix rho = matrix(0, 0.5, 0.95)

**Variables
matrix x = J(100, 1, 1)
matrix y = J(100, 3, 0)
matrix e = J(100, 1, 0)

**Simulation
forvalues j = 1/3{
	scalar r = rho[1, `j']
	forvalues i = 1/100 {
		if `i' == 1 {
			matrix e[`i', 1] = rnormal()
		}
		else{
			matrix e[`i', 1] = r * e[`i'-1, 1] + rnormal()
		}
		matrix y[`i', `j'] = beta + e[`i', 1]
	}
}

********************************************************************************
********************************************************************************
**OLS regression
svmat y
reg y1 
reg y2 
reg y3 

********************************************************************************
********************************************************************************
**NEWEY-WEST regression with G=4
generate time = _n
tsset time
newey y1, lag(4)
newey y2, lag(4)
newey y3, lag(4)