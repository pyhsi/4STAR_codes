function [visresp, nirresp, visnote, nirnote, vislstr, nirlstr,visaerosolcols, niraerosolcols, visresperr, nirresperr] = starskyresp(t);
% [visresp, nirresp, visnote, nirnote, vislstr, nirlstr, visaerosolcols, niraerosolcols, visresperr, nirresperr] = starskyresp(t);

% returns the 4STAR responsivity [cts/ms / W/(m^2.sr.um)] for the time (t) of the
% measurement. t must be in the Matlab time format. Leave blank and now is
% assumed. New calibration files should be linked to this code, and all
% other 4STAR codes should obtain the c0 from this code. See also
% starwavelengths.m and starLangley.m.  
% Yohei, 2012/05/28, 2012/05/31.
% Samuel, v1.0, 2014/10/13, added version control of this m-script via version_set 
version_set('1.0');
%%[visc0, nirc0, visnote, nirnote, vislstr, nirlstr, visaerosolcols, niraerosolcols, visc0err, nirc0err]=starc0(t)

% control the input
if nargin==0;
    t=now;
end;

% select a source file
if isnumeric(t); % time of the measurement is given; return the C0 of the time.
    if t>=datenum([2012 7 3 0 0 0])&& t< datenum([2013 1 16 0 0 0]) ; % new VIS spectrometer since July 3, 2012       
        daystr='20120920'; % temporary calibration, over m_aero over 1.2 - 1.8.
        %         filesuffix='refined_Langley_on_G1_screened_2x_with_gas_absorption_ignored';
        %         filesuffix='refined_Langley_on_G1_second_flight_screened_2x_with_gas_absorption_ignored';
        filesuffix='from_20120920_006_VIS_park_with_201112131052Hiss-corrected';
    elseif t >= datenum([2013 1 16 0 0 0])
        % 20130506_VIS_SKY_Resp_with_20130605124300HISS.dat
        daystr = '20130506';
        filesuffix = 'with_20130605124300HISS';
    end;    
else % special collections
    % cjf: need to generate radiance cals from March data to be used at MLO
    if isequal(t, 'MLO201205') || isequal(t, 'MLO2012May')
        daystr={'20120525' '20120526' '20120528' '20120531' '20120601' '20120602' '20120603'};
        filesuffix=repmat({'refined_Langley_at_MLO_V3'},size(daystr));
    end;
end;

% read the file and return c0 values and notes
if ~exist('visresp')
    if ~exist('filesuffix');
        error('Update starc0.m');
    elseif isstr(filesuffix);
        daystr={daystr};
        filesuffix={filesuffix};
    end;
    visnote=['Resp from '];
    nirnote=['Resp from '];
    vislstr=repmat({},length(filesuffix),1);
    nirlstr=repmat({},length(filesuffix),1);
    for i=1:length(filesuffix);
        visfilename=[daystr{i} '_VIS_SKY_Resp_' filesuffix{i} '.dat'];
        orientation='vertical'; % coordinate with starLangley.m.
        if isequal(orientation,'vertical');
            a=importdata(fullfile(starpaths,visfilename));
            visresp(i,:)=a.data(:,strcmp(lower(a.colheaders), 'resp'))';
            if sum(strcmp(lower(a.colheaders), 'resperr'))>0;
                visresperr(i,:)=a.data(:,strcmp(lower(a.colheaders), 'resperr'))';
            else
                visresperr(i,:)=NaN(1,size(visresp,2));
            end;
        else
            visresp(i,:)=load(fullfile(starpaths,visfilename));
            visresperr(i,:)=NaN(1,size(visresp,2));
        end;
        visnote=[visnote visfilename ', '];
        vislstr(i)={visfilename};
        nirfilename=strrep(visfilename,'VIS','NIR');
        if isequal(orientation,'vertical');
            a=importdata(fullfile(starpaths,nirfilename));
            nirresp(i,:)=a.data(:,strcmp(lower(a.colheaders), 'resp'))';
            if sum(strcmp(lower(a.colheaders), 'resperr'))>0;
            nirresperr(i,:)=a.data(:,strcmp(lower(a.colheaders), 'resperr'))';
        else
            nirresperr(i,:)=NaN(1,size(nirresp,2));
        end;
        else
            nirresp(i,:)=load(fullfile(starpaths,nirfilename));
            nirresperr(i,:)=NaN(1,size(nirresp,2));
        end;
        nirnote=[nirnote nirfilename ', '];
        nirlstr(i)={nirfilename};
    end;
    visnote=[visnote(1:end-2) '.'];
    nirnote=[nirnote(1:end-2) '.'];
end;

% return channels used for AOD fitting
[visaerosolcols,niraerosolcols]=starchannelsatANET(t);
goodvis = sum(~isNaN(visaerosolcols));
% visaerosolcols=[repmat(visaerosolcols(~isNaN(visaerosolcols)),3,1)+repmat([-1 0 1]',1,goodvis)];
goodnir = sum(~isNaN(niraerosolcols));

% niraerosolcols=[repmat(niraerosolcols(~isNaN(niraerosolcols)),3,1)+1044+repmat([-1 0 1]',1,goodnir)]; 
aerosolcols=[visaerosolcols niraerosolcols];


% record keeping
if 1==2; % never executed, just for record keeping
    % preliminary MLO C0, used until 20120625
    if t>=datenum([2012 06 17]);
        daystr='MLO2012May';
        filesuffix='refined_Langley_at_MLO';
    elseif t>=datenum([2012 05 26]);
        daystr='20120526';
        filesuffix='refined_Langley_at_MLO';
    elseif t>=datenum([2012 05 25]);
        daystr='20120525';
        filesuffix='refined_Langley_at_MLO';
        filesuffix='refined_Langley_at_MLO_V2';
    end;
    if isequal(t, 'MLO201205') || isequal(t, 'MLO2012May')
        daystr={'20120525' '20120526' '20120528' '20120531' '20120601' '20120602' '20120603'};
        filesuffix=repmat({'refined_Langley_at_MLO'},size(daystr));
        filesuffix=repmat({'refined_Langley_at_MLO_V2'},size(daystr));
    elseif isequal(t, 'OLD_MLO201205') || isequal(t, 'OLD_MLO2012May')
        daystr={'20120420' '20120525' '20120526' '20120528' '20120531' '20120601' '20120602' '20120603'};
        filesuffix=repmat({'refined_Langley_at_MLO'},size(daystr));
        filesuffix(1)={'refined_Langley_on_G1'};
    end;
    % until 2012/05/23, V0 from standard Langley plots
    visresp=load(fullfile(starpaths,'20120420_VIS_C0_standard_Langley_on_G1.dat'));
    visnote='C0 from 20120420 airborne Langley on G1.';
    nirresp=load(fullfile(starpaths,'20120420_NIR_C0_standard_Langley_on_G1.dat'));
    nirnote='C0 from 20120420 airborne Langley on G1.';
end;

return

function [visaerosolcols,niraerosolcols] = starchannelsatANET(t)
anet_wl = [440, 673, 873, 1022];
[visw, nirw]=starwavelengths(nanmean(t));
visaerosolcols = interp1(1000.*visw, [1:length(visw)],anet_wl,'nearest');
niraerosolcols = interp1(1000.*nirw, [1:length(nirw)],anet_wl,'nearest')+1044;
visaerosolcols(isNaN(visaerosolcols))= [];
niraerosolcols(isNaN(niraerosolcols))= [];
return
% SSA441-T,SSA673-T,SSA873-T,SSA1022-T

