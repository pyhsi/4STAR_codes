function make_for_starflag(f_in)
%% Program that loads a full starsun to create a much smaller file useful for flagging only
% contains a very limited set of aod values at some distinct wavelengths
% created: Samuel LeBlanc, 2016-09-19, v1.0, Santa Cruz, CA

version_set('v1.0')

% Simple program to load a starsun and save just a few values from it to a
% smaller file used for starflag.
s = load(f_in,'w','Alt','Lat','Lon','tau_aero_noscreening','m_aero','t','roll',...
              'rawrelstd','Md','Str','raw','dark','c0','darkstd','QdVlr','QdVtot','ng','program_version','sd_aero_crit');

g.Alt = s.Alt; g.Lat=s.Lat; g.Lon=s.Lon; g.t = s.t;
g.m_aero = s.m_aero; g.rawrelstd = s.rawrelstd; g.Md = s.Md; g.Str = s.Str;
g.QdVlr = s.QdVlr; g.QdVtot = s.QdVtot; g.ng = s.ng; g.c0=s.c0;
g.program_version = s.program_version; g.sd_aero_crit=s.sd_aero_crit;

nm_380 = interp1(s.w,[1:length(s.w)],.38, 'nearest');
nm_500 = interp1(s.w,[1:length(s.w)],.5, 'nearest');
nm_870 = interp1(s.w,[1:length(s.w)],.87, 'nearest');
nm_452 = interp1(s.w,[1:length(s.w)],.452, 'nearest');
nm_865 = interp1(s.w,[1:length(s.w)],.865, 'nearest');
nm_1040 = interp1(s.w,[1:length(s.w)],1.04, 'nearest');
nm_1215 = interp1(s.w,[1:length(s.w)],1.215, 'nearest');
colsang=[nm_452 nm_865];
g.ang_noscreening=sca2angstrom(s.tau_aero_noscreening(:,colsang), s.w(colsang));
g.aod_380nm = s.tau_aero_noscreening(:,nm_380);
g.aod_452nm = s.tau_aero_noscreening(:,nm_452);
g.aod_500nm = s.tau_aero_noscreening(:,nm_500);
g.aod_865nm = s.tau_aero_noscreening(:,nm_865);
g.aod_1040nm = s.tau_aero_noscreening(:,nm_1040);
g.aod_1215nm = s.tau_aero_noscreening(:,nm_1215);
g.aod_500nm_max=3;
g.m_aero_max=15;

%calculate quantity [1-cos(roll angle)]
g.roll_proxy=1-cos(s.roll*pi/180);

g.raw = [s.raw(:,nm_380),s.raw(:,nm_452),s.raw(:,nm_500),s.raw(:,nm_865),s.raw(:,nm_1040),s.raw(:,nm_1215)];
g.dark = [s.dark(:,nm_380),s.dark(:,nm_452),s.dark(:,nm_500),s.dark(:,nm_865),s.dark(:,nm_1040),s.dark(:,nm_1215)];
g.darkstd = [s.darkstd(:,nm_380),s.darkstd(:,nm_452),s.darkstd(:,nm_500),...
             s.darkstd(:,nm_865),s.darkstd(:,nm_1040),s.darkstd(:,nm_1215)];
         
g.nm_380 = 1;g.nm_452 = 2;g.nm_500 = 3;g.nm_865 = 4;g.nm_1040 = 5;g.nm_1215 = 6; 
g.save_for_starflag = true;

f_out = strrep(f_in,'.mat', '_for_starflag.mat');
disp(['creating file for smaller size flagging: ' f_out])
save(f_out,'-struct','g','-mat','-v7.3');
end