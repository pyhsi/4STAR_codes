horilegs=[datenum('10:28:55') datenum('14:41:05'); ...
datenum('14:58:24') datenum('15:28:33'); ...
datenum('15:32:36') datenum('15:40:10'); ...
datenum('16:20:58') datenum('18:26:49'); ...
]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);

vertprofs=[datenum('10:13:45') datenum('10:28:55'); ...
datenum('14:41:05') datenum('14:58:24'); ...
datenum('15:28:33') datenum('15:32:36'); ...
datenum('15:40:10') datenum('15:48:46'); ...
datenum('15:40:10') datenum('16:05:06'); ...
datenum('16:05:06') datenum('16:20:58'); ...
datenum('18:26:49') datenum('18:43:22'); ...
]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);

flight=[datenum('10:08:28') datenum('18:43:23')] -datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);

% % % % manual masking
% % % s.ng=[datenum('10:13:45') datenum('10:30:00')] ... % bogus calculated airmass, before sunrise
% % %     -datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);

% STD-based cloud screening for direct Sun measurements
s.sd_aero_crit=0.01;

% Ozone and other gases
s.O3h=21;
s.O3col=0.300;  % Yohei's guess, to be updated
s.NO2col=5e15; % Yohei's guess, to be updated

% other tweaks
if isfield(s, 'Pst');
    s.Pst(find(s.Pst<10))=1013;
end;
if isfield(s, 'Lon') & isfield(s, 'Lat');
    s.Lon(s.Lon==0 & s.Lat==0)=NaN;
    s.Lat(s.Lon==0 & s.Lat==0)=NaN;
end;
if isfield(s, 'AZstep') & isfield(s, 'AZ_deg');
    s.AZ_deg=s.AZstep/(-50);
end;

% notes
if isfield(s, 'note');
    s.note(end+1,1) = {['See ' mfilename '.m for additional info. ']};
end;


