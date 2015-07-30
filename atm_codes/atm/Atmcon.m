function ATMCON
%***********************************************************************
%     THIS SUBROUTINE INITIALIZES THE CONSTANTS USED IN THE            
%     PROGRAM. CONSTANTS RELATING TO THE ATMOSPHERIC PROFILES ARE STORED
%     IN BLOCK DATA MLATMB.                                             
%***********************************************************************
global PZERO TZERO AVOGAD ALOSMT GASCON PLANK BOLTZ CLIGHT ADCON
global ALZERO AVMWT AIRMWT AMWT

	PZERO = 1013.25;
	TZERO = 273.15;
	AVOGAD = 6.022045E+23;
	ALOSMT = 2.68675E+19;
	GASCON = 8.31441E+7;
	PLANK = 6.626176E-27;
	BOLTZ = 1.380662E-16;  %erg/K
	CLIGHT = 2.99792458E10;
		%*****ALZERO IS THE MEAN LORENTZ HALFWIDTH AT PZERO AND 296.0 K.
		%*****AVMWT IS THE MEAN MOLECULAR WEIGHT USED TO AUTOMATICALLY
		%*****GENERATE THE FASCODE BOUNDARIES IN AUTLAY
	ALZERO = 0.1;
	AVMWT = 36.0;
   AIRMWT = 28.964;
   AMWT = [18.015,44.010,47.998,44.01,28.011,16.043,31.999,30.01,64.06,...
         46.01,17.03,63.01,17.00,20.01,36.46,80.92,127.91,51.45,60.08,30.03,...
         52.46,28.014,27.03,50.49,34.01,26.03,30.07,34.00,0,0,0,0,0,0,0];
return