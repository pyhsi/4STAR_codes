flight=[datenum(2016,6,17,17,12,33) datenum(2016,6,17,22,13,25)];
% spirals=[datenum(2016,4,21,21,45,50) datenum(2016,4,21,21,56,55)
% datenum(2016,4,21,21,57,50) datenum(2016,4,21,22,12,00)];

% Ozone and other gases
s.O3h=21; % Yohei's guess
%s.O3col=0.300; %  guess    
%s.NO2col=2.0e15; % guess 
s.O3col=0.286;    % OMI O3 average along the track, Qin 
s.NO2col=3.10e15;  % OMI NO2 average along the track 

% other tweaks
if isfield(s, 'Pst');
    s.Pst(find(s.Pst<10))=1013.25; 
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