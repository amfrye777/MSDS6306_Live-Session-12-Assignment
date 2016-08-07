libname Files "\\Client\D$\Documents\School\SMU\2016 Summer\MSDS 6306 - Into to Data Science\Assignments\Week 12\Files";


/*****************************************
*** Load StateAbbrMapping file 
*****************************************/

PROC IMPORT OUT= WORK.abbr 
            DATAFILE= "\\Client\D$\Documents\School\SMU\2016 Summer\MSDS 6306 - Into to Data Science\Assignments\Week 12\Files\StateAbbrMapping.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
	 GUESSINGROWS=32767;
RUN;

PROC SORT DATA=abbr; BY State;

proc print data = abbr;
run;

/*****************************************
*** Load And Merge DATASET1 file 
*****************************************/

Data EducationData;
	set files.DATASET1;
run;

data EducationData;
length State2 $ 50;
	set EducationData;
IF State EQ "DC" Then State2 = "DISTRICT OF COLUMBIA"; ELSE State2 = STRIP(UPCASE(State));
run;

data EducationData (DROP=State);
	set EducationData;
run;

data EducationData (RENAME=(State2=State));
	set EducationData;
run;

PROC SORT DATA=EducationData; BY State2;

proc print data = EducationData;
run;

DATA EducationData_WithAbbr;
MERGE abbr EducationData; By State;

proc print data = EducationData_WithAbbr; run;

/*****************************************
*** Load And Merge 2014PublicPrivateSchoolsClean file 
*****************************************/

PROC IMPORT OUT= WORK.PPS 
            DATAFILE= "\\Client\D$\Documents\School\SMU\2016 Summer\MSDS 6306 - Into to Data Science\Assignments\Week 12\Files\2014PublicPrivateSchoolsClean.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
	 GUESSINGROWS=32767;
RUN;

data PPS;
length State2 $ 50;
	set PPS;
IF State EQ "DC" Then State2 = "DISTRICT OF COLUMBIA"; ELSE State2 = STRIP(UPCASE(State));
run;

data PPS (DROP=State);
	set PPS;
run;

data PPS (RENAME=(State2=State));
	set PPS;
run;

PROC SORT DATA=PPS; BY State;

proc print data = PPS;
run;

DATA ED_WithAbbr_PPS;
MERGE EducationData_WithAbbr PPS; By State;

proc print data = ED_WithAbbr_PPS; run;

/*****************************************
*** Load And Merge DeathPenaltyStatsNotMerged file 
*****************************************/

PROC IMPORT OUT= WORK.DeathPen 
            DATAFILE= "\\Client\D$\Documents\School\SMU\2016 Summer\MSDS 6306 - Into to Data Science\Assignments\Week 12\Files\DeathPenaltyStatsNotMerged.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
	 GUESSINGROWS=32767;
RUN;


data DeathPen;
length State2 $ 50;
	set DeathPen;
IF States EQ "DC" Then State2 = "DISTRICT OF COLUMBIA"; ELSE State2 = STRIP(UPCASE(States));
run;

data DeathPen (DROP=States DROP=VAR1);
	set DeathPen;
run;

data DeathPen (RENAME=(State2=State));
	set DeathPen;
run;

PROC SORT DATA=ED_WithAbbr_PPS; BY State;
PROC SORT DATA=DeathPen; BY State;

proc print data = DeathPen;
run;

DATA ED_WithAbbr_PPS_DeathPen;
MERGE ED_WithAbbr_PPS DeathPen; By State;

proc print data = ED_WithAbbr_PPS_DeathPen; run;


/*****************************************
*** Load And Merge PercentAPStudents file 
*****************************************/

PROC IMPORT OUT= WORK.PAP 
            DATAFILE= "\\Client\D$\Documents\School\SMU\2016 Summer\MSDS 6306 - Into to Data Science\Assignments\Week 12\Files\PercentAPStudents.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
	 GUESSINGROWS=32767;
RUN;


data PAP;
length State2 $ 50;
	set PAP;
IF State EQ "DC" Then State2 = "DISTRICT OF COLUMBIA"; ELSE State2 = STRIP(UPCASE(State));
run;

data PAP (DROP=State DROP=VAR1);
	set PAP;
run;

data PAP (RENAME=(State2=State));
	set PAP;
run;

PROC SORT DATA=ED_WithAbbr_PPS_DeathPen; BY State;
PROC SORT DATA=PAP; BY State;

proc print data = PAP;
run;

DATA ED_WithA_PPS_DP_PAP;
MERGE ED_WithAbbr_PPS_DeathPen PAP; By State;

proc print data = ED_WithA_PPS_DP_PAP; run;



/*****************************************
*** Load And Merge StudentsPerTeacher2013 file 
*****************************************/

PROC IMPORT OUT= WORK.Teacher 
            DATAFILE= "\\Client\D$\Documents\School\SMU\2016 Summer\MSDS 6306 - Into to Data Science\Assignments\Week 12\Files\StudentsPerTeacher2013.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
	 GUESSINGROWS=32767;
RUN;

data Teacher (RENAME=(ST=Abbreviation));
	set Teacher;
IF ST EQ "NB" Then ST = "NE";
run;

PROC SORT DATA=ED_WithA_PPS_DP_PAP; BY Abbreviation;
PROC SORT DATA=Teacher; BY Abbreviation;

proc print data = Teacher;
run;

DATA ED_WithA_PPS_DP_PAP_T;
MERGE ED_WithA_PPS_DP_PAP Teacher; By Abbreviation;

proc print data = ED_WithA_PPS_DP_PAP_T; run;



/*****************************************
*** Load And Merge ACS_14_5YR_GCT1105.US01PR file 
*****************************************/

PROC IMPORT OUT= WORK.ACS 
            DATAFILE= "\\Client\D$\Documents\School\SMU\2016 Summer\MSDS 6306 - Into to Data Science\Assignments\Week 12\Files\ACS_14_5YR_GCT1105.US01PR.xls" 
            DBMS=XLS REPLACE;
     GETNAMES=YES;
     DATAROW=8; 
	 GUESSINGROWS=32767;
RUN;



data ACS (DROP=B DROP=C DROP=E DROP=F);
	set ACS;
run;

data ACS (RENAME=(VAR1=State D=Person G=Margin_Of_Error));
	set ACS;
IF Length(VAR1) > 1;
run;

data ACS;
length State2 $ 50;
	set ACS;
IF State EQ "DC" Then State2 = "DISTRICT OF COLUMBIA"; ELSE State2 = STRIP(UPCASE(State));
run;

data ACS (DROP=State DROP=VAR1);
	set ACS;
run;

data ACS (RENAME=(State2=State));
	set ACS;
run;

PROC SORT DATA=ED_WithA_PPS_DP_PAP_T; BY State;
PROC SORT DATA=ACS; BY State;

proc print data = ACS;
run;

DATA ED_WithA_PPS_DP_PAP_T_ACS;
MERGE ED_WithA_PPS_DP_PAP_T ACS; By State;

proc print data = ED_WithA_PPS_DP_PAP_T_ACS; run;


/*****************************************
*** Load And Merge AverageClassSizeByState file 
*****************************************/

PROC IMPORT OUT= WORK.SBS 
            DATAFILE= "\\Client\D$\Documents\School\SMU\2016 Summer\MSDS 6306 - Into to Data Science\Assignments\Week 12\Files\AverageClassSizeByState.CSV" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
	 GUESSINGROWS=32767;
RUN;

data SBS (DROP=Rank);
	set SBS;
IF Length(State) > 1;
run;


data SBS;
length State2 $ 50;
	set SBS;
IF State EQ "DC" Then State2 = "DISTRICT OF COLUMBIA"; ELSE State2 = STRIP(UPCASE(State));
run;

data SBS (DROP=State);
	set SBS;
run;

data SBS (RENAME=(State2=State));
	set SBS;
run;

PROC SORT DATA=ED_WithA_PPS_DP_PAP_T_ACS; BY State;
PROC SORT DATA=SBS; BY State;

proc print data = SBS;
run;

DATA ED_WithA_PPS_DP_PAP_T_ACS_SBS;
MERGE ED_WithA_PPS_DP_PAP_T_ACS SBS; By State;

proc print data = ED_WithA_PPS_DP_PAP_T_ACS_SBS; run;

/*****************************************
*** Load And Merge PopDensity file 
*****************************************/

PROC IMPORT OUT= WORK.PD 
            DATAFILE= "\\Client\D$\Documents\School\SMU\2016 Summer\MSDS 6306 - Into to Data Science\Assignments\Week 12\Files\PopDensity.CSV" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
	 GUESSINGROWS=32767;
RUN;

data PD (Rename=(VAR2=SQMI VAR3=SQKM));
	set PD;
run;


data PD;
length State2 $ 50;
	set PD;
IF State EQ "DC" Then State2 = "DISTRICT OF COLUMBIA"; ELSE State2 = STRIP(UPCASE(State));
run;

data PD (DROP=State);
	set PD;
run;

data PD (RENAME=(State2=State));
	set PD;
run;

PROC SORT DATA=ED_WithA_PPS_DP_PAP_T_ACS_SBS; BY State;
PROC SORT DATA=PD; BY State;

proc print data = PD;
run;

DATA ED_WithA_PPS_DP_PAP_T_ACS_SBS_PD;
MERGE ED_WithA_PPS_DP_PAP_T_ACS_SBS PD; By State;

proc print data = ED_WithA_PPS_DP_PAP_T_ACS_SBS_PD; run;

/*****************************************
*** Export ED_WithA_PPS_DP_PAP_T_ACS_SBS_PD file 
*****************************************/

proc export data=ED_WithA_PPS_DP_PAP_T_ACS_SBS_PD 
			outfile="\\Client\D$\Documents\School\SMU\2016 Summer\MSDS 6306 - Into to Data Science\Assignments\Week 12\ED_WithA_PPS_DP_PAP_T_ACS_SBS_PD.CSV" 
			dbms = CSV replace;
run;
