/***********************************************************************
This program proccesses our raw 911 call data to limit the data to only calls made in 2017 and calls we determined are related to crime

Created October 8, 2024

Author Rachel Gaudreau
***********************************************************************/
* Set cd to computer path where the calls_final.csv file is saved and import the raw data
cd "C:\Users\regaudre\OneDrive - Syracuse University\documents"
import delimited "calls_final", clear
 
* Open log to track the work done by the do-file
log using "911CallCrimeLog", text replace

* Create specific year variable
gen year = call_timestamp
replace year = substr(year, 1, 4)

* Delete all calls made in years other than 2017
keep if year == "2017"

* Delete all 911 calls not concerning crime
drop if calldescription == "CHILD / ADULT ABUSE REPORT"
drop if calldescription == "DDOT TROUBLE"
drop if calldescription == "MISCELLANEOUS ACCIDENT"
drop if calldescription == "MISCELLANEOUS TRAFFIC"
drop if calldescription == "MOLESTATION REPORT"
drop if calldescription == "PERSON W/  A WEAPON REPORT"
drop if calldescription == "RAPE REPORT"
drop if calldescription == "SUICIDE ATTEMPT DELTA"
drop if calldescription == "SUICIDE I/P"
drop if calldescription == "SUICIDE THREAT"
drop if calldescription == "SUICIDE THREAT OR ABNORM BEHAV"
drop if calldescription == "SUSPICIOUS PACKAGE"
drop if calldescription == "THREATS REPORT"
drop if calldescription == "TRANSPORT PRISONER"
drop if calldescription == "TRANSPORT PRISONER-OTH AGT"
drop if calldescription == "VERIFIED ALR / PERSON W/O CODE"
drop if calldescription == "WRKABLE ARRST/OBV OR EXP DEATH"
drop if calldescription == "GRASS OR RUBBISH FIRE"
drop if calldescription == "KIDNAPPING REPORT"
drop if calldescription == "MEDICAL ALARM OR UNK PROB"
drop if calldescription == "MISSING REPORT"
drop if calldescription == "MT EMS-TRO/ENTRY"
drop if calldescription == "OTHR OUTSIDE STRUCTURE FIRE"
drop if calldescription == "PORTABLE ALARM SYSTEM"
drop if calldescription == "SERIOUS HEMORRHAGE"
drop if calldescription == "SERIOUS INJURIES"
drop if calldescription == "SHOOTING/CUTTING/PENT WND RPT"
drop if calldescription == "SHOTS J/H, EVIDENCE, REPT"
drop if calldescription == "UDAA REPORT"
drop if calldescription == "VERIFY RETURN OF MISSING"
drop if calldescription == "ALARM MALFUNCTION"
drop if calldescription == "ALARM MISUSE"
drop if calldescription == "ALR PT DISABLED / TIMEZONE CHG"
drop if calldescription == "ANIMAL COMPLAINT"
drop if calldescription == "ASSIST CITIZEN"
drop if calldescription == "ASSIST OTHER"
drop if calldescription == "ASSIST PERSONNEL"
drop if calldescription == "AUTO X REPORT"
drop if calldescription == "BACKGROUND CHECK / LIVESCAN"
drop if calldescription == "BACKGROUND/LEIN CHK / LIVESCAN"
drop if calldescription == "BE ON THE LOOK OUT"
drop if calldescription == "BREATHING PROBLEMS DELTA"
drop if calldescription == "BUILDING CHECK"
drop if calldescription == "BURGLARY BUSINESS REPORT"
drop if calldescription == "BURGLARY OCCUP RESD REPT"
drop if calldescription == "BURGLARY OTHER REPORT"
drop if calldescription == "BURGLARY RESIDENCE REPORT"
drop if calldescription == "CALL BACK DESK"
drop if calldescription == "CHILD(REN) HOME ALONE"
drop if calldescription == "ELEVATOR ENTRAPMENT"
drop if calldescription == "EMPLOYEE CALL IN / TIME OFF"
drop if calldescription == "ESCORT"
drop if calldescription == "EXTORTION JH OR REPORT"
drop if calldescription == "FIRE ALARM"
drop if calldescription == "FIRE ALARM TEST"
drop if calldescription == "FIRE ALARMS ALL"
drop if calldescription == "FOUND PERSON"
drop if calldescription == "FRAUD REPORT"
drop if calldescription == "HARASSMENT REPORT"
drop if calldescription == "LIFE STATUS QUESTIONABLE DELTA"
drop if calldescription == "NOISE COMPLAINT"
drop if calldescription == "NOTIFICATION(S) MADE"
drop if calldescription == "PARKING COMPLAINT"
drop if calldescription == "PEACE OFFICER DETAIL"
drop if calldescription == "PPO VIOLATION REPORT"
drop if calldescription == "RECOVER AUTO"
drop if calldescription == "RECOVERED / FOUND PROPERTY"
drop if calldescription == "REMARKS"
drop if calldescription == "SAFEWALK"
drop if calldescription == "SCHOOL CROSSING"
drop if calldescription == "SENIOR CITIZEN ASSIST"
drop if calldescription == "SICK NON PRIORIOTY COMPLAINTS"
drop if calldescription == "START OF SHIFT INFORMATION"
drop if calldescription == "TEMPERATURE ALARM"
drop if calldescription == "TOWING DETAIL"
drop if calldescription == "WELL BEING CHECK"
drop if calldescription == "ADMIT OR E/E"
drop if calldescription == "ANIMAL BITE OR ATTACK DELTA"
drop if calldescription == "ANIMAL BITES OR ATTACK DELTA"
drop if calldescription == "ANIMAL FIGHT"
drop if calldescription == "ARSON REPORT"
drop if calldescription == "ASSAULT AND BATTERY REPORT"
drop if calldescription == "AUTO OR PED H&R REPORT"
drop if calldescription == "FELONIOUS ASSAULT REPORT"
drop if calldescription == "LARCENY REPORT"
drop if calldescription == "MALICIOUS DESTRUCTION RPT"
drop if calldescription == "PROPERTY DAMAGE NON-CRIMINAL"
drop if calldescription == "ROBBERY ARMED REPORT"
drop if calldescription == "ROBBERY NOT ARMED REPORT"
drop if calldescription == "VISCOUS ANIMAL"
drop if calldescription == "VIP THREATS J/H OR REPORT"

* Save 2017 911 call data for later use
export delimited "GitHub\course-project-zipcentercrime\Reproducibility Package\2017_Crime_911calls.csv"

* Close log
log close
