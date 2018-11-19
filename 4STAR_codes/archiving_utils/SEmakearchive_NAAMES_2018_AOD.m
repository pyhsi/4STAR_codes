%% Details of the program:
% NAME:
%   SEmakearchive_NAAMES_2018_AOD
%
% PURPOSE:
%  To generate AOD archive files for use wih NAAMES 2018 (modified from
%  NAAMES-2017 code)
%
% CALLING SEQUENCE:
%   SEmakearchive_NAAMES_2018_AOD
%
% INPUT:
%  none
%
% OUTPUT:
%  plots and ict file
%
% DEPENDENCIES:
%  - version_set.m
%  - t2utch.m
%  - ICARTTwriter.m
%  - evalstarinfo.m
%  - ...
%
% NEEDED FILES:
%  - starsun.mat file compiled from raw data using allstarmat and then
%  processed with starsun
%  - starinfo for the flight with the flagfile defined
%  - flagfile
%
% EXAMPLE:
%  none
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, Osan AFB, Korea, May 7th, 2016
%                 ported over from SEmakearchive_ARISE_starzen.m
% MS, updated starinfo files path
% 2016-07-01, MS, tweaked for certain flag days for KORUS
% 2016-07-14, MS, twaeked to accept automatic flags
% 2016-09-04, SL,v2.0 ported from KORUS
% 2016-09-18, SL,v2.1, added variable paths depending on the user
% 2017-03-15, SL,v2.2, Fixed issue with altitude and some other value
%                      interpolation. Was doing nearest neighbor
%                      interpolation without maximum time distance, now set
%                      to only use nearest neighbor if less than 1 second
%                      away. Set new revision for R1
% 2017-04-05, SL,v2.3, Added reading of the tau_aero_subtract_all to use
%                      aod with gas subtracted
% 2017-06-28, SL,v3.0, Added uncertainty, window deposition
%                      correction, and notes on final archive.
%                      Added new wavelengths and uncertainty comments
% 2017-08-11, SL,v4.0, Ported over from ORACLES 2016
% 2017-11-21, MS,    , tweaked line 196 to overcome archiving issues for
%                      rooftests
% 2018-04-18, SL,v5.0, Added new values to archive, 
%                      with acaod flags, polynomials, and angstrom exponent 
% 2018-06-07, SL,v6.0, Ported over from ORACLES to NAAMES
% 2018-11-16, KP,v7.0, NAAMES-2017 to NAAMES-2018 (why do the numbers keep
%                      going up when it's an entirely different code?)
% -------------------------------------------------------------------------

function SEmakearchive_NAAMES_2018_AOD
version_set('v7.0')
%% set variables
starinfo_path = starpaths; %'C:\Users\sleblan2\Research\4STAR_codes\data_folder\';
starsun_path = getnamedpath('NAAMES2018_starsun')
ICTdir = getnamedpath('NAAMES2018_aod_ict')

prefix='NAAMES-4STARB-AOD'; %'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-SKYSCAN'; % 'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-SKYSCAN'; % 'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-SKYSCAN'; % 'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-WV';
rev='0'; % A; %0 % revision number; if 0 or a string, no uncertainty will be saved. <-- KP: i hope this isn't true, NAAMES-2018 will only have R0 as final since there was no field archive since there was no field
platform = 'C130';
gas_subtract = false;
include_uncert = true;
avg_wvl = true;
deltatime_dAOD = NaN; %time in seconds around the shift in AOD due to the window deposition <-- I don't THINK this is being used, but it mad me uncomfortable to keep it as a number so I'm NaN'ing it out --kp
dAOD_uncert_frac = 0.25; %fraction of the change in dAOD due to window deposition to be kept as extra uncertainty (default 20%, 0.2)

%% Prepare General header for each file
HeaderInfo = {...
    'Jens Redemann';...                           % PI name
    'NASA Ames Research Center';...              % Organization
    'Spectrometers for Sky-Scanning, Sun-Tracking Atmospheric Research - B (4STARB)';...     % Data Source
    'NAAMES-3 (2018)';...                                  % Mission name
    '1, 1';...                                   % volume number, number of file volumes
    '1';...                                      % time interval (see documentation)
    'Start_UTC, seconds, Elapsed seconds from 0 hours UT on day: DATE';...  % Independent variable name and description
    };

NormalComments = {...
    'PI_CONTACT_INFO: jredemann@ou.edu';...
    'PLATFORM: NASA C-130';...
    'LOCATION: Based in St-Johns, Newfoundland, Canada. Aircraft latitude, longitude, altitude are included in the data records';...
    'ASSOCIATED_DATA: N/A';...
    'INSTRUMENT_INFO: (4STARB) Spectrometers for Sky-Scanning, Sun-Tracking Atmospheric Research-B';...
    'DATA_INFO: measurements represent Aerosol Optical Depth values of the column above the aircraft at measurement time nearest to Start_UTC.';...
    'UNCERTAINTY: AOD uncertainty is wavelength-dependent, determined primarily by 2-sigma of the variability in calibration coefficients [Shinozuka et al 2013, doi:10.1002/2013JD020596] plus an additional constant to reflect 4STARB performance over NAAMES-3.  Consult PI for more detail.';...
    'ULOD_FLAG: -7777';...
    'ULOD_VALUE: N/A';...
    'LLOD_FLAG: -8888';...
    'LLOD_VALUE: N/A';...
    'DM_CONTACT_INFO: Kristina Pistone, kristina.pistone@nasa.gov';...
    'PROJECT_INFO: NAAMES-4, 2018 deployment; March 2018';...
    'STIPULATIONS_ON_USE: This is the initial public release of the 4STARB-AOD dataset for NAAMES-3. We strongly recommend that you consult the PI, both for updates to the dataset, and for the proper and most recent interpretation of the data for specific science use.';...
    'OTHER_COMMENTS: Due to issues with the plane, only a test flight out of Wallops Flight Facility and the transit from WFF to St John''s are included in this archival';...
    };

revComments = {...
    %'R2: Final calibrations, with new error calculations, and correction of window deposition for some selected flights. Added new wavelengths to archive.';...
    %'R1: Fix on field archived data for erroneus altitude, position, and some AOD data interpolation. Column trace gas impact to AOD has been removed for O3, O4, H2O, NO2, CO2, and CH4. Updated calibration from Mauna Loa, November 2016 has been applied. There is still uncertainty in the impact of window deposition affection light transmission.';...
    %'R1: Updated instrument calibration.  New screening of data for clouds and tracking errors. ';...
    'R0: Final instrument calibrations have been applied. Data have been screened for clouds and tracking errors and uncertainties are quantified. The data are still subject to uncertainties associated with detector stability, cloud screening, transfer efficiency of light through fiber optic cable, diffuse light, tracking error, gas absorption and deposition on the front windows.'
    };

% specComments_extra_uncertainty = 'The uncertainty for this flight has been increased to reflect the potential impact of deposition on the window.';%'AOD in this file has been adjusted to reflect impact of deposition on window.\n';

%% Prepare details of which variables to save
%info.Start_UTC = 'Fractional Seconds, Elapsed seconds from midnight UTC from 0 Hours UTC on day given by DATE';
info.Latitude  = 'deg, Aircraft latitude (deg) at the indicated time';
info.Longitude = 'deg, Aircraft longitude (deg) at the indicated time';
info.GPS_Alt   = 'm, Aircraft GPS geometric altitude (m) at the indicated time';
info.qual_flag = 'unitless, quality of retrieved AOD: 0=good; 1=poor, due to clouds, tracking errors, or instrument stability';
info.cirrus_flag = 'unitless, Indicates likely presence of cirrus, may not be completely inclusive; 0=no cirrus, 1=likely cirrus';
info.amass_aer = 'unitless, aerosol optical airmass';
info.AOD_angstrom_470_865 = 'unitless, Angstrom exponent calculated from the AOD at 470 nm and 865 nm, is equivalent to the inverse of the slope of the log(AOD) at these 2 wavelengths, -dlog(AOD)/dlog(wavelength)';
% info.AOD_polycoef_a2 = 'unitless, ln(AOD) vs ln(wavelength) polynomial fit coefficient (2nd), to recreate aod at other wavelengths use spectral fit equation: log(AOD) = a2*log(wvl[nm])*log(wvl[nm]) + a1*log(wvl[nm]) + a0.';
% info.AOD_polycoef_a1 = 'unitless, ln(AOD) vs ln(wavelength) polynomial fit coefficient (1st), to recreate aod at other wavelengths use spectral fit equation: log(AOD) = a2*log(wvl[nm])*log(wvl[nm]) + a1*log(wvl[nm]) + a0.';
% info.AOD_polycoef_a0 = 'unitless, ln(AOD) vs ln(wavelength) polynomial fit coefficient (0th), to recreate aod at other wavelengths use spectral fit equation: log(AOD) = a2*log(wvl[nm])*log(wvl[nm]) + a1*log(wvl[nm]) + a0.';

% wls = [355, 380,452, 470,501,520,530,532,550,606,620,660,675, 700,781,865,1020,1040,1064,1236,1250,1559,1627,1650];

save_wvls  = [354.9,380.0,451.7,470.2,500.7,520,530.3,532.0,550.3,605.5,619.7,660.1,675.2,780.6,864.6,1019.9,1039.6,1064.2,1235.8,1249.9];
% save_wvls  = [380.0,451.7,500.7,520,532.0,550.3,605.5,619.7,675.2,780.6,864.6,1019.9,1039.6,1039.6,1064.2,1235.8,1558.7,1626.6]; old
iwvls_angs = [4,15];
[v,n] = starwavelengths(now,'4STARB'); wvl = [v,n].*1000.0;

for i=1:length(save_wvls);
    namestr = sprintf('AOD%04.0f',save_wvls(i));
    if avg_wvl;
        [nul,iw] = min(abs(wvl-save_wvls(i)));
        info.(namestr) = sprintf(['unitless, Aerosol optical depth averaged over 3 wavelength pixels from %4.1f nm to %4.1f nm centered at %4.1f nm'],wvl(iw-1),wvl(iw+1),save_wvls(i));
    else;
        info.(namestr) = sprintf(['unitless, Aerosol optical depth at %4.1f nm'],save_wvls(i));
    end;
end;

if include_uncert;
    for i=1:length(save_wvls);
        uncnamestr = sprintf('UNCAOD%04.0f',save_wvls(i));
        info.(uncnamestr) = sprintf('unitless, Uncertainty in aerosol optical depth at %4.1f nm',save_wvls(i));
    end;
end;
%set the format of each field
form = info;
names = fieldnames(info);
for ll=1:length(names); form.(names{ll}) = '%2.3f'; end;
form.GPS_Alt = '%7.1f';
form.Latitude = '%3.7f';
form.Longitude = '%4.7f';
form.qual_flag = '%1.0f';
form.cirrus_flag = '%1.0f';

originfo = info; origform = form; orignames = names;

%% prepare list of details for each flight
dslist={'20180318','20180324'}; %test flight and transit are all we've got
%Values of jproc: 1=archive 0=do not archive
jproc=[         1          1]; 

%% run through each flight, load and process
idx_file_proc=find(jproc==1);
for i=idx_file_proc
    info = originfo; form = origform; names = orignames;
    iradstart = 8; % the start of the field names related to wavelengths
    
    %% get the flight time period
    daystr=dslist{i};
    disp(['on day:' daystr])
    %cd starinfo_path
    %infofile_ = fullfile(starinfo_path, ['starinfo_' daystr '.m']);
    infofile_ = ['starinfo_' daystr '.m'];
    infofnt = str2func(infofile_(1:end-2)); % Use function handle instead of eval for compiler compatibility
    s = ''; s.dummy = ''; s.instrumentname = '4STARB';
    try
        s = infofnt(s);
    catch
        eval([infofile_(1:end-2),'(s)']);
    end
    s.AODuncert_constant_extra = 0.009;
    UTCflight=t2utch(s.flight);
    %UTCflight=t2utch(s.ground);
    HeaderInfo{7} = strrep(HeaderInfo{7},'DATE',daystr);
    
    %% build the Start_UTC time array, spaced at one second each
    Start_UTCs = [UTCflight(1)*3600:(UTCflight(2))*3600];% tweaked to allow day change
    UTC = Start_UTCs/3600.;
    num = length(Start_UTCs);
    
    %% get the special comments
    switch daystr
        case '20170802'
            specComments = {...
                'Aborted flight, nearly no data.\n',...
                };
        otherwise
            specComments = {};
    end
    
    %% read file to be saved
    starfile = fullfile(starsun_path, ['4STARB_' daystr 'starsun.mat']);
    disp(['loading the starsun file: ' starfile])
    load(starfile, 't','tau_aero_noscreening','w','Lat','Lon','Alt','m_aero','note');
%     try;
%         load(starfile,'tau_aero_subtract_all');
%         tau = tau_aero_subtract_all;
%     catch;
%         disp('*** tau_aero_subtract_all not available, reverting to tau_aero_noscreening ***')
        tau = tau_aero_noscreening; %we have no tau_aero_subtract_all because we had no gases running
%     end;
%     if gas_subtract;
%         try;
%             load(starfile,'tau_aero_subtract_all');
%             tau = tau_aero_subtract_all;
%         catch;
%             disp('*** tau_aero_subtract_all not available, reverting to tau_aero_noscreening ***')
%             tau = tau_aero_noscreening;
%         end;
%     else;
%         tau = tau_aero_noscreening;
%     end;
    
    if include_uncert;
        try;
            load(starfile, 't','tau_aero_err');
        catch;
            error(['Problem loading the uncertainties in file:' starfile])
        end;
    end;
    
    %% Update the uncertainties with merge marks file saved in the starinfo
    add_uncert = false;
    correct_aod = false;
    if isfield(s,'AODuncert_mergemark_file');
        disp(['Loading the AOD uncertainty correction file: ' s.AODuncert_mergemark_file])
        d = load(s.AODuncert_mergemark_file);
        if(exist('specComments_extra_uncertainty')) %KP: adding conditional here because it was putting an empty string in this array and throwing an error on writing
            specComments{end+1} = specComments_extra_uncertainty;
        end
        add_uncert = true; correct_aod = true;
    elseif isfield(s,'AODuncert_constant_extra');
        disp(['Applying constant AOD factor to existing AOD'])
        d.dAODs = repmat(s.AODuncert_constant_extra,[length(t),length(save_wvls)]);
        if(exist('specComments_extra_uncertainty')) %KP: adding conditional here because it was putting an empty string in this array and throwing an error on writing
            specComments{end+1} = specComments_extra_uncertainty;
        end
        add_uncert = true; correct_aod = false;
        d.time = t;
    end
    
    %% extract special comments about response functions from note
    if ~isempty(strfind(note, 'C0'));
        temp_cells = strfind(note,'C0');
        inote = find(not(cellfun('isempty',temp_cells)));
        for n=1:length(inote);
            specComments{end+1} = [strrep(note{inote(n)},'C0 from','Using the C0 calibration file: ') '\n'];
        end
    end
    
    %% fill with NaN the data structure, with appropriate sizes
    disp('initializing the data fields')
    for n=1:length(names)
        data.(names{n}) = NaN(num,1);
    end
    
    %% fill up some of the data and interpolate for proper filling
    tutc = t2utch(t);
    ialt = find(Alt>0&Alt<10000.0); % filter out bad data
    [nutc,iutc] = unique(tutc(ialt));
    data.GPS_Alt = interp1(nutc,Alt(ialt(iutc)),UTC);
    [nnutc,iiutc] = unique(tutc);
    data.Latitude = interp1(nnutc,Lat(iiutc),UTC);
    data.Longitude = interp1(nnutc,Lon(iiutc),UTC);
    data.amass_aer = interp1(nnutc,m_aero(iiutc),UTC);
    
    %% Load the flag file
    if isfield(s, 'flagfilename');
        disp(['Loading flag file: ' s.flagfilename])
        flag = load(s.flagfilename);
    else
        [flagfilename, pathname] = uigetfile2('*.mat', ...
            ['Pick starflag file for day:' daystr]);
        disp(['Loading flag file: ' pathname flagfilename])
        flag = load([pathname flagfilename]);
    end
    
    %% Combine the flag values
    disp('Setting the flags')
    [qual_flag,flag,cirrus_flag] = convert_flags_to_qual_flag(flag,t,s.flight);
    data.qual_flag = Start_UTCs*0+1; % sets the default to 1
    
    %cirrus flag
    data.cirrus_flag = Start_UTCs*0; % sets the default to 0
    
    % tweak for different flag files
    if strcmp(daystr,'20170824') || strcmp(daystr,'20170831')|| strcmp(daystr,'20170812')|| strcmp(daystr,'20170817') || strcmp(daystr,'20170912')
        flag.utc = t2utch(flag.flags.time.t);
    else
        try;
            flag.utc = t2utch(flag.time.t);
        catch;
            flag.utc = t2utch(flag.t);
        end;
    end
    [ii,dt] = knnsearch(flag.utc,UTC');
    idd = dt<1.0/3600.0; % Distance no greater than one second.
    data.qual_flag(idd) = qual_flag(ii(idd)); 
    data.cirrus_flag(idd) = cirrus_flag(ii(idd)); %cirrus_flag
    
    %% Now go through the times of measurements, and fill up the related variables (AOD wavelengths)
    disp('filling up the data')
    for n=1:length(save_wvls); [uu,i] = min(abs(w-save_wvls(n)/1000.0)); save_iwvls(n)=i; end;
    % make sure to only have unique values
    [tutc_unique,itutc_unique] = unique(tutc);
    [idat,datdt] = knnsearch(tutc_unique,UTC');
    iidat = datdt<1.0/3600.0; % Distance no greater than 1.0 seconds.
    if ~include_uncert; nend = length(names); else; nend = length(names)-length(save_iwvls); end;
    for nn=iradstart:nend;
        ii = nn-iradstart+1;
        data.(names{nn}) = UTC*0.0+NaN;
        if avg_wvl;
            t_im = tau(itutc_unique(idat(iidat)),save_iwvls(ii)-1);
            t_ii = tau(itutc_unique(idat(iidat)),save_iwvls(ii));
            t_ip = tau(itutc_unique(idat(iidat)),save_iwvls(ii)+1);
            data.(names{nn})(iidat) = nanmean([t_im,t_ii,t_ip]')';
        else;
            data.(names{nn})(iidat) = tau(itutc_unique(idat(iidat)),save_iwvls(ii));
        end;
        if correct_aod;
            d.dAODs(isnan(d.dAODs)) = 0.0;
            if ~strcmp(datestr(d.time(1),'YYYYmmDD'),daystr); error('Time array in delta AOD merge mark file not the same as starsun file'), end;
            [tutc_unique_daod,itutc_unique_daod] = unique(t2utch(d.time));
            try;
                data.(names{nn}) = data.(names{nn}) - interp1(tutc_unique_daod,d.dAODs(itutc_unique_daod,ii),UTC,'nearest');
            catch;
                [tutc_unique_daod,itutc_unique_daod] = unique(t2utch(d.time));
                data.(names{nn}) = data.(names{nn}) - interp1(tutc_unique_daod,d.dAODs(itutc_unique_daod,ii),UTC,'nearest');
                disp('dAOD merge marks file does not have the same time array size, interpolating to nearest values and trying again.')
            end;
        end;
        if ii ==1; aod_saved=data.(names{nn}); else aod_saved(ii,:)=data.(names{nn});end;
    end;
    
    %% Get the Angstrom and the polyfit coefficients
%     [a2,a1,a0,ang,curvature]=polyfitaod(save_wvls,aod_saved'); % polynomial separated into components for historic reasons
%     data.AOD_polycoef_a2 = a2;
%     data.AOD_polycoef_a1 = a1;
%     data.AOD_polycoef_a0 = a0;
    ae = sca2angstrom(aod_saved(iwvls_angs,:)', save_wvls(iwvls_angs));
    data.AOD_angstrom_470_865 = ae;
    
    %% do the same but for uncertainty
    if include_uncert;
        for nn=iradstart+length(save_wvls):length(names);
            ii = nn-iradstart-length(save_wvls)+1;
            [tutc_unique,itutc_unique] = unique(tutc);
            data.(names{nn}) = interp1(tutc_unique,abs(tau_aero_err(itutc_unique,save_iwvls(ii))),UTC,'nearest');
            if add_uncert;  % if the add uncertainty exists then run that also.
                if correct_aod;
                    it = find(diff(d.dCo(:,5))<-0.0001);
                    dAODs = d.dAODs.*0.0;
                    for itt=1:length(it); % add uncertainty equivalent to the daod change for a period of +/- deltatime_dAOD seconds around the effect
                        [nul,itm] = min(abs(d.time-(d.time(it(itt))-deltatime_dAOD/86400)));
                        [nul,itp] = min(abs(d.time-(d.time(it(itt))+deltatime_dAOD/86400)));
                        dAODs(itm:itp,:) = repmat(d.dAODs(it(itt)+1,:)-d.dAODs(it(itt),:),itp-itm+1,1);
                    end;
                    try;
                        data.(names{nn}) = data.(names{nn}) + interp1(tutc_unique_daod,dAODs(itutc_unique_daod,ii),UTC,'nearest');
                    catch;
                        [tutc_unique_daod,itutc_unique_daod] = unique(t2utch(d.time));
                        data.(names{nn}) = data.(names{nn}) + interp1(tutc_unique_daod,dAODs(itutc_unique_daod,ii),UTC,'nearest');
                        disp('dAOD merge marks file does not have the same time array size, interpolating to nearest values and trying again.')
                    end;
                    try;  % add uncertainty equivalent to 20% of the correction
                        data.(names{nn}) = data.(names{nn}) + interp1(tutc_unique_daod,d.dAODs(itutc_unique_daod,ii).*dAOD_uncert_frac,UTC,'nearest');
                    catch;
                        [tutc_unique_daod,itutc_unique_daod] = unique(t2utch(d.time));
                        data.(names{nn}) = data.(names{nn}) + interp1(tutc_unique_daod,d.dAODs(itutc_unique_daod,ii).*dAOD_uncert_frac,UTC,'nearest');
                        disp('dAOD merge marks file does not have the same time array size, interpolating to nearest values and trying again.')
                    end;
                else;
                    try;
                        data.(names{nn}) = data.(names{nn}) + interp1(tutc_unique_daod,d.dAODs(itutc_unique_daod,ii),UTC,'nearest');
                    catch;
                        [tutc_unique_daod,itutc_unique_daod] = unique(t2utch(d.time));
                        data.(names{nn}) = data.(names{nn}) + interp1(tutc_unique_daod,d.dAODs(itutc_unique_daod,ii),UTC,'nearest');
                        disp('dAOD merge marks file does not have the same time array size, interpolating to nearest values and trying again.')
                    end;
                end;
            end;

            %end
        end;
    end;
    
    %% make sure that no UTC, Alt, Lat, and Lon is displayed when no measurement
    inans = find(isnan(data.(names{iradstart+2})));
    %data.UTC(inans) = NaN;
    data.GPS_Alt(inans) = NaN;
    data.Latitude(inans) = NaN;
    data.Longitude(inans) = NaN;
    data.amass_aer(inans) = NaN;
    for i=2:length(names)
        data.(names{i})(inans) = NaN;
    end
    
    %% Now print the data to ICT file
    disp('Printing to file')
    ICARTTwriter(prefix, platform, HeaderInfo, specComments, NormalComments, revComments, daystr,Start_UTCs,data,info,form,rev,ICTdir)
end;

function name = getUserName ()
if isunix()
    name = getenv('USER');
else
    name = getenv('username');
end
return
