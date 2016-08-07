Data ex1217;
infile "\\Client\D$\Documents\School\SMU\2016 Summer\MSDS
 6371 - Experimental Statistics I\StatisticalSleuthDatasets\CSV\ex1217.csv" dlm="," dsd firstobs=2;
format City $20.;
input City $ Mortality Precip Humidity JanTemp JulyTemp Over65 House Educ Sound Density NonWhite WhiteCol Poor HC NOX SO2;
run;

proc print data=ex1217 (obs=10);
run;

proc sgscatter data = ex1217;
matrix Mortality HC NOX SO2;
run;

Data log1217;
set ex1217;
logHC = log(HC);
logNOX = log(NOX);
logSO2 = log(SO2);
run;

proc print data = log1217;run;

proc sgscatter data = log1217;
matrix Mortality logHC logNOX logSO2;
run;

proc reg data = log1217;
model Mortality = Precip Humidity JanTemp JulyTemp Over65 House Educ Sound Density NonWhite WhiteCol Poor logHC logNOX logSO2;
run;


proc reg data = log1217;
model Mortality = Precip Humidity JanTemp JulyTemp Over65 House Educ Sound Density NonWhite WhiteCol Poor logHC logNOX logSO2 / VIF;
run;
