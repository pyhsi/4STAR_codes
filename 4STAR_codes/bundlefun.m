function [ output_args ] = bundlefun(inzip, outpath, over)
% [ output_args ] = bundlefun(inzip, outpath, over)
% inzip is an optional string containing the fname  of a bundlefnt zip file
% outpath is an optional string indicating the path to put new files
% over, if over==0, backup don't overwrite.  over==1 overwrite, over==2 overwrite if newer
% The default is 2, to overwrite if newer
tmpdir = ['unzip_tmpdir_',datestr(now,'yyyy-mm-dd_HHMMSS')];
[status, msg] = mkdir(tmpdir);
if ~exist('inzip','var')||~exist(inzip,'file')
   inzip = getfullname('*.zip','bundle','Select a bundlefnt zipped file.');
end
while ~exist('outpath','var')||~exist(outpath,'dir')
   outpath = uigetdir;
end
if ~strcmp(outpath(end),filesep)
   outpath = [outpath filesep];
end
if ~exist(outpath,'dir')
   mkdir(outpath);
end
if ~exist('over','var')
   over = 2;
end
if over<0
   over=0;
elseif over>2
   over=2
end
% unzips the supplied file into a temp directory
files = unzip(inzip, tmpdir);
for f = length(files):-1:1
   [~, fun,ext] = fileparts(files{f});
   % for each file, run which to get the fullpath
   there = which([fun ext]);
   if ~isempty(there)
      % if exists on path, check if same
      if cmp_files(there, files{f})
         % if exists and same skip or delete from temp_dir
         delete(files{f});
      else
         there_file = dir(there);
         there_f = dir(files{f});
         if over==0            
            N = 1;
            [there_path,~,~] = fileparts(there); there_path = [there_path filesep];
            dstr = datestr(now,'yyyymmdd_');
            while exist([there_path,fun,dstr,num2str(N),ext])
               N = N+1;
            end
            % if exists and not same, rename existing appending fname with datestamp + n
            movefile(there, [there_path,fun,dstr,num2str(N),ext]);
         elseif over==1
            %  then mv from temp_dir to exist_path
            movefile(files{f},there);
         elseif over==2
            if (there_f.datenum > there_file.datenum)
               movefile(files{f},there);
            else
               delete(files{f});
            end
         end
      end
   else
      % if not exist then mv to outpath, creating if necessary
      movefile(files{f},[outpath,fun, ext]);
   end
   
end % end for each file
leftover = dir(tmpdir);
% If empty delete temp_dir
if isempty(leftover)
   rmdir(leftover)
else    % else warning that some files couldn't be moved.
   warning(['Some files could not be moved out of ',tmpdir]);
end
% add outpath to end of matlab path
addpath(outpath, '-END')
savepath;

return
