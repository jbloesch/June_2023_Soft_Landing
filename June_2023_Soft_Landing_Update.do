
cd "C:\Users\Justin\Dropbox\Roosevelt\June 2023 Soft Landing"

import fred JTSJOL JTSQUL JTSJOR JTSQUR UNRATE, clear 


gen year = year(daten)
gen month = month(daten)
gen time = ym(year,month)
tsset time

// create log of variables
gen lnV = log(JTSJOL)
gen lnQ = log(JTSQUL)
gen lnVr = log(JTSJOR)
gen lnQr = log(JTSQUR)
gen lnU = log(UNRATE)

// construct counterfacutal quits that stays at 2.3 from 2020-20023 
gen Qcounterfact = JTSQUR
replace Qcounterfact = 2.3 if year>=2020
gen lnQcounterfact = ln(Qcounterfact)

// compute predicted vacancies
reg lnV lnQ time if year<=2019
reg lnV l(0/1).lnQ time if year<=2019
predict lnVhat

// compute predicted vacancies w/o time trend
reg lnVr l(0/1).lnQr time if year<=2019
predict lnVrhat
reg lnVr l(0/1).lnQr if year<=2019
predict lnVrhatnotime
reg lnVr l(0/1).lnQcounterfact time if year<=2019
predict lnVrcounterfact

// convert log predicted vacancies back into levels
gen Vrhat = exp(lnVrhat)
gen Vrhatnotime = exp(lnVrhatnotime)
gen Vrcounterfact = exp(lnVrcounterfact)
tsline JTSJOR Vrhat if year>=2000

// plot 
label variable JTSJOR "Job Openings Rate"
label variable Vrhat "Predicted Vacancies"
label variable Vrhatnotime "Quits Only: No Time Trend"

tsline JTSJOR Vrhat Vrhatnotime if year>=2000, graphregion(color(white)) title("Vacancy Rate on Pace Given 2000-2019 Time Trend") subtitle("Predicted Vacancies using Quits and Time Trend") xla(492(48)748, format(%tmCCYY)) xtitle("")
graph export "Predicted_Vacancies_Time_Trend.png",replace

label variable Vrcounterfact "Counterfactual: Quits=2.3"
tsline JTSJOR Vrcounterfact if year>=2000, graphregion(color(white)) title("Vacancy Rate on Pace Given 2000-2019 Time Trend") subtitle("Predicted Vacancies using Quits and Time Trend") xla(492(48)748, format(%tmCCYY)) xtitle("")
graph export "Predicted_Vacancies_Counterfactual.png",replace

gen VoverQ = JTSJOL/JTSQUL
label variable VoverQ "Vacancies per Quit"
tsline VoverQ if year>=2000, graphregion(color(white)) xla(516(48)748, format(%tmCCYY)) xtitle("") title("Rising Vacancies Per Quit Since Early 2000's")
graph export "rising_VoverU.png",replace


// predicted vacancies based on unemployment rate
reg lnVr l(0/1).lnU time if year<=2019
predict lnVhatU if year>=2000
reg lnVr l(0/1).lnU  if year<=2019
predict lnVhatUnotime if year>=2000
gen VhatU = exp(lnVhatU)
gen VhatUnotime = exp(lnVhatUnotime)
tsline JTSJOR VhatU if year>=2000
tsline JTSJOR VhatU VhatUnotime if year>=2000

// predict vacancies using both quits and U
reg lnVr lnQr lnU if year<=2019
reg lnVr lnQr lnU time if year<=2019

//////////////////
// V/U Analysis //
//////////////////

gen VoverU = JTSJOR/UNRATE
gen lnVoverU = log(VoverU)

reg lnVoverU l(0/1).lnQ time if year<=2019
predict lnVoverUhat
gen VoverUhat = exp(lnVoverUhat)
tsline VoverU VoverUhat if year>=2000


reg lnVoverU l(0/1).lnQcounterfact time if year<=2019
predict lnVoverUcounterfact
gen VoverUcounterfact = exp(lnVoverUcounterfact)
tsline VoverU VoverUcounterfact if year>=2000