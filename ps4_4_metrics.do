** Author: Andrea Pagliuca 
** Project: PS4 Econometrics, year 1 LBS
** Date: 2 December 2023

** Clearing
clear all 

********************************************************************************
********************************************************************************
**Import dataset
 use "C:\Users\apagliuca\OneDrive - London Business School\Desktop\metrics\ps4_metrics\MURDER.dta"

********************************************************************************
********************************************************************************
**PART A

reg mrdrte exec unem d90 d93

*only small positive correlation between murder rate and unemployment
********************************************************************************
********************************************************************************
**PART B: FE regression

xtset id year

xtreg mrdrte exec unem i.year, fe
mat b_FE=get(_b)
mat V_FE=get(VCE)
estimate store fe


********************************************************************************
********************************************************************************
**PART C: WITHIN regression

quietly xi: reg mrdrte i.id
predict rmrdrte, residuals
quietly xi: reg exec i.id
predict rexec, residuals
quietly xi: reg unem i.id
predict runem, residuals
quietly xi: reg d90 i.id
predict rd90, residuals
quietly xi: reg d93 i.id
predict rd93, residuals

reg rmrdrte rexec runem rd90 rd93, noconstant


********************************************************************************
********************************************************************************
**PART D: RANDOM EFFECTS and HAUSMAN TEST

*Random effects model:
xtreg mrdrte exec unem i.year
mat b_RE = e(b)
mat V_RE = e(V)
estimate store re

*Hausman statistics: 
matrix A1 = (b_FE-b_RE)
matrix A2 = (invsym(V_FE - V_RE))
matrix Hausman = A1 *A2*A1'
matrix list Hausman
hausman fe re
