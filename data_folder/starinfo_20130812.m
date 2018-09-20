function s = starinfo(s)
if exist('s','var')&&isfield(s,'t')&&~isempty(s.t)
   daystr = datestr(s.t(1),'yyyymmdd');
else
   daystr=evalin('caller','daystr');
end

toggle = update_toggle;
if isfield(s, 'toggle')
   toggle = catstruct(s.toggle, toggle);
end
s.toggle = toggle;

%get variables from caller 
 
% No good time periods ([start end]) and memo for all pixels 
%  flag: 1 for unknown or others, 2 for before and after measurements, 10 for unspecified type of clouds, 90 for cirrus, 100 for unspecified instrument trouble, 200 for instrument tests, 300 for frost. 
s.ng=[datenum('14:11:10') datenum('14:16:50') 90]; 
s.ng(:,1:2)=s.ng(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
flight=[datenum('13:20:48') datenum('21:33:18')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); % updated 27Sep13 JML 
groundcomparison=[datenum('22:28:45') datenum('22:35:25')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
!!! A rough timing, to be updated. No good post-flight comparison, as dirt may have deposited during the flight. 
horilegs=[datenum('13:33:53') datenum('14:39:26');... 
datenum('14:53:45') datenum('15:10:01');... 
datenum('15:14:46') datenum('15:23:07');... 
datenum('15:29:33') datenum('15:37:15');... 
datenum('15:48:22') datenum('16:05:09');... 
datenum('16:08:41') datenum('16:15:37');... 
datenum('16:22:17') datenum('16:26:32');... 
datenum('16:31:45') datenum('16:42:23');... 
datenum('16:46:09') datenum('16:51:57');... 
datenum('16:55:02') datenum('16:57:41');... 
datenum('17:13:12') datenum('17:18:49');... 
datenum('17:22:08') datenum('17:25:45');... 
datenum('17:27:48') datenum('17:32:53');... 
datenum('17:45:51') datenum('17:53:39');... 
datenum('17:55:52') datenum('17:59:09');... 
datenum('18:03:40') datenum('18:10:37');... 
datenum('18:31:20') datenum('18:43:43');... 
datenum('18:55:11') datenum('19:02:55');... 
datenum('20:03:51') datenum('20:14:31');... 
datenum('20:23:51') datenum('20:33:52');... 
datenum('20:46:28') datenum('20:57:58');... 
datenum('21:16:20') datenum('21:23:53');... 
    ]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
vertprofs=[datenum('13:20:50') datenum('13:33:51') 
datenum('14:39:27') datenum('15:12:25');... 
datenum('16:05:10') datenum('16:08:40');... 
datenum('16:17:09') datenum('16:21:37');... 
datenum('16:26:33') datenum('16:31:44');... 
datenum('16:42:23') datenum('16:46:01');... 
datenum('16:57:41') datenum('17:03:39');... 
datenum('17:04:52') datenum('17:27:36');... 
datenum('17:33:17') datenum('17:45:49');... 
datenum('17:59:10') datenum('18:13:43');... 
datenum('18:21:35') datenum('18:27:05');... 
datenum('18:43:44') datenum('18:48:43');... 
datenum('18:48:43') datenum('18:53:59');... 
datenum('19:02:55') datenum('19:08:38');... 
datenum('19:10:50') datenum('20:03:50');... 
datenum('20:14:32') datenum('20:22:37');... 
datenum('20:33:52') datenum('20:46:27');... 
datenum('20:57:58') datenum('21:33:14');... 
    ]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
% daystr=mfilename; 
% daystr=daystr(end-7:end); 
% No good time periods ([start end]) for specific pixels 
s.ng=s.ng; 
 
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
 
%push variable to caller 
varNames=who(); 
for i=1:length(varNames) 
  assignin('caller',varNames{i},eval(varNames{i})); 
end; 

%push variable to caller
% Bad coding practice to blind-push variables to the caller.  
% Creates potential for clobbering and makes collaborative coding more
% difficult because fields appear in caller memory space undeclared.

varNames=who();
for i=1:length(varNames)
   if ~strcmp(varNames{i},'s')
  assignin('caller',varNames{i},eval(varNames{i}));
   end
end;

return

