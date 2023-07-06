
cd "C:\Users\Justin\Dropbox\Roosevelt\June 2023 Soft Landing"

import fred USMINE USLAH USCONS MANEMP USFIRE USEHS USPBS USWTRADE USTRADE USSERV CES4300000001 CES4422000001 USINFO CES1000000003 CES2000000003 CES3000000003 CES4142000003 CES4200000003 CES4300000003 CES4422000003 CES5000000003 CES5500000003 CES6000000003 CES6500000003 CES7000000003 CES0500000003 CES8000000003 AWHAEMAL AWHAECON AWHAEMAN AWHAEUTIL AWHAEWT AWHAERT AWHAETAW AWHAEPBS AWHAEEHS AWHAEFA AWHAEINFO AWHAELAH AWHAEOS, clear

ren USMINE empmining
ren USLAH empleishosp
ren CES4422000001 emputil
ren USCONS empconstr
ren MANEMP empmanuf
ren USWTRADE empwholesale
ren USTRADE empretail
ren CES4300000001 emptranspware
ren USPBS empprofbus
ren USFIRE empfinance
ren USEHS empeduchealth
ren USINFO empinfo
ren USSERV empserv

ren CES1000000003 wmining
ren CES7000000003 wleishosp
ren CES4422000003 wutil
ren CES2000000003 wconstr
ren CES3000000003 wmanuf
ren CES4142000003 wwholesale
ren CES4200000003 wretail
ren CES4300000003 wtranspware
ren CES6000000003 wprofbus
ren CES5500000003 wfinance
ren CES6500000003 weduchealth
ren CES5000000003 winfo
ren CES8000000003 wserv
ren CES0500000003 aheprivate

ren AWHAEMAL hmining
ren AWHAEUTIL hutil
ren AWHAECON hconstr
ren AWHAEMAN hmanuf
ren AWHAEWT hwholesale
ren AWHAERT hretail
ren AWHAETAW htranspware
ren AWHAEPBS hprofbus
ren AWHAEEHS heduchealth
ren AWHAEFA hfinance
ren AWHAEINFO hinfo
ren AWHAEOS hserv
ren AWHAELAH hleishosp


save "wages_employment_by_industry.dta", replace
use "wages_employment_by_industry.dta", clear 

gen year = year(daten)
gen month = month(daten)
gen time = ym(year,month)
tsset time

keep if year>=2006
foreach var in mining leishosp util constr manuf wholesale retail transpware profbus finance educhealth info serv {
	gen emp`var'2019 = emp`var' if year<=2019
	carryforward emp`var'2019, replace
	gen h`var'2019 = h`var' if year<=2019
	carryforward h`var'2019, replace	
	gen wagebill`var' = emp`var'*w`var'*h`var'
	gen wagebill`var'2019 = emp`var'2019*h`var'2019*w`var'
	gen tothours`var' = h`var'*emp`var'
	gen tothours`var'2019 = h`var'2019*emp`var'2019
	
	
	// weights using employment and hours 6 months ago
	gen emp`var'_l6 = l6.emp`var'
	gen h`var'_l6 = l6.h`var'
}


gen wagebill = wagebillmining + wagebillleishosp + wagebillutil + wagebillconstr + wagebillmanuf + wagebillwholesale + wagebillretail + wagebilltranspware + wagebillprofbus + wagebillfinance + wagebilleduchealth + wagebillinfo + wagebillserv
gen wagebill2019 = wagebillmining2019 +  wagebillleishosp2019 + wagebillutil2019 + wagebillconstr2019 + wagebillmanuf2019 + wagebillwholesale2019 + wagebillretail2019 + wagebilltranspware2019 + wagebillprofbus2019 + wagebillfinance2019 + wagebilleduchealth2019 + wagebillinfo2019 + wagebillserv2019

// total employment
//gen totemp = empmining + empleishosp + emputil + empconstr + empmanuf + empwholesale + empretail + emptranspware + empprofbus + empfinance + empeduchealth + empinfo + empserv
//gen totemp2019 = empmining2019 + empleishosp2019 + emputil2019 + empconstr2019 + empmanuf2019 + empwholesale2019 + empretail2019 + emptranspware2019 + empprofbus2019 + empfinance2019 + empeduchealth2019 + empinfo2019 + empserv2019
//gen ahe = wagebill/totemp
//gen ahe2019 = wagebill2019/totemp2019

// total hours
gen totemp = tothoursmining + tothoursleishosp + tothoursutil + tothoursconstr + tothoursmanuf + tothourswholesale + tothoursretail + tothourstranspware + tothoursprofbus + tothoursfinance + tothourseduchealth + tothoursinfo + tothoursserv
gen totemp2019 = tothoursmining2019 + tothoursleishosp2019 + tothoursutil2019 + tothoursconstr2019 + tothoursmanuf2019 + tothourswholesale2019 + tothoursretail2019 + tothourstranspware2019 + tothoursprofbus2019 + tothoursfinance2019 + tothourseduchealth2019 + tothoursinfo2019 + tothoursserv2019

gen ahe = wagebill/totemp
gen ahe2019 = wagebill2019/totemp2019

tsline aheprivate ahe ahe2019, graphregion(color(white)) xla(540(48)748, format(%tmCCYY)) xtitle("")

gen d6ahe = ((ahe/l6.ahe)^2-1)*100
gen d6ahe2019 = ((ahe2019/l6.ahe2019)^2-1)*100
gen d6aheprivate = ((aheprivate/l6.aheprivate)^2-1)*100
gen d3ahe = ((ahe/l3.ahe)^2-1)*100
gen d3ahe2019 = ((ahe2019/l3.ahe2019)^2-1)*100
gen d3aheprivate = ((aheprivate/l3.aheprivate)^2-1)*100
tsline d6ahe*, graphregion(color(white)) xla(564(48)748, format(%tmCCYY)) xtitle("")
tsline d6ahe* if year>=2011, graphregion(color(white)) xla(708(12)756, format(%tmCCYY)) xtitle("")
tsline d6aheprivate d6ahe d6ahe2019 if year>=2021, graphregion(color(white)) xla(732(6)756, format(%tmMon_CCYY)) xtitle("") legend( label(1 "Average Hourly Earnings") label(2 "Reconstructed AHE") label(3 "AHE, Fixed 2019 Employment & Hours")) title("Average Hourly Earnings 6 Month Growth") subtitle("with composition adjustment")
tsline d6aheprivate d6ahe2019 if year>=2021, graphregion(color(white)) xla(732(6)756, format(%tmMon_CCYY)) xtitle("") legend( label(1 "Average Hourly Earnings")  label(2 "Fix 2019 Employment & Hours")) title("Six-Month Growth in Average Hourly Earnings ") subtitle("Adjusted for composition at 1-2 digit NAICS level") ytitle("Percent Growth, Annualized")
graph export "AHE_6mo_composition_adjusted.png", replace 

