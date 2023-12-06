** Author: Andrea Pagliuca 
** Project: PS4 Econometrics, year 1 LBS
** Date: 2 December 2023

** Clearing
clear all 

********************************************************************************
********************************************************************************
** EXERCISE 2, GMM ESTIMATION 

**Import dataset
 use "C:\Users\apagliuca\OneDrive - London Business School\Desktop\metrics\ps4_metrics\ccapm.dta"

**Variables
*Generate lagged variables for the moment equations
gen cratio_1 = cratio[_n -1]
gen rrate_1 = rrate[_n -1]
gen e_1 = e[_n -1]

********************************************************************************
********************************************************************************
** PART A: GMM simple estimation: The default STATA setting is the optimal two-step GMM with heteroskedasticityrobust estimation of the optimal weighting matrix

gmm ({b}*(cratio^(-{g}))*rrate-1), ///
inst(cratio_1 rrate_1 e_1) from ( b=1 g=1)


********************************************************************************
********************************************************************************
** PART B: GMM Use option wmatrix(hac ba 5) to change the default estimation of the optimal weight to the NeweyWest-type HAC estimation with truncation lag equal to 5
gen time =[_n]
gmm ({b}*(cratio^(-{g}))*rrate-1), ///
inst(cratio_1 rrate_1 e_1) wmatrix(hac ba 5) from ( b=1 g=1)


********************************************************************************
********************************************************************************
** PART C: Using the setting in (b), test the hypothesis that β = 0.98 at 95% significance level.

**COEFFICIENTS STORAGE
matrix results = e(b)
matrix std_errors = e(V)
scalar b_val = results[1, 1] // Extract value of 'b' and store it in a scalar
scalar g_val = results[1, 2] // Extract value of 'g' and store it in a scalar
scalar std_error_b = sqrt(std_errors[1, 1]) // Extract standard error of 'b' and store it in a scalar
scalar std_error_g = sqrt(std_errors[2, 2]) // Extract standard error of 'g' and store it in a scalar

**TEST b=0.98 at 95% significance level.


// Define the hypothesized value
scalar hypothesized_value = 0.98

// Calculate the t-statistic for b
scalar t_statistic_b = (b_val - hypothesized_value) / std_error_b

// Degrees of freedom
scalar df = e(N) - e(k)

// Calculate the critical t-value at 5% significance level
scalar critical_t_value = invttail(df, 0.025)

// Perform the test
if abs(t_statistic_b) > critical_t_value {
    di "Reject null hypothesis: b is significantly different from 0.98"
}
else {
    di "Fail to reject null hypothesis: b is not significantly different from 0.98"
}









