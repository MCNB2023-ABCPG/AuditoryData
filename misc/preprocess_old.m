function  preprocess(mode, wd)
% Main function for preprocessing
% pathBase = '/Users/pschm/Documents/University/mcnb/2_semester/NMDA-II/AuditoryData';
% 
%
% Ideas for general structure from:
% https://github.com/phildean/SPM_fMRI_Example_Pipeline/blob/master/preprocess.m
% https://youtube.com/playlist?list=PLhzkDK3o0fcCO3hQORMU6GjKGBjMRWBSb&si=wE4SUJ1x1r-jQyFG
%
%
% Parameters
% ----------
% mode: array
%   pass array with characters for the steps that should be applied ['r', 'c', ...]
%   r: realign
%   c: coregister
%   e: segment
%   n: normalize       
%   s: smooth
%
% wd: char
%   specify the top level working directory

% Returns
% ----------
% None
%%% INITILIAZE
spm('defaults', 'fmri')
spm_jobman('initcfg')


%%% DEFAULTS
% set filepath if wd not given
if ~exist('wd','var')
    pathBase = fileparts(matlab.desktop.editor.getActiveFilename);
else
    pathBase = wd;
end

% change backslash to slash
if contains('\s\s','\') == '\'
    pathBase = strrep(wd,'\','/');
end

% set default mode if not given
if ~exist('mode', 'var')
    mode = 'rcens';
end


%%% GLOBALS
% set subdir of data
pathData = fullfile(pathBase, 'data');

files = cellstr(spm_select('FPList', pathData, '^f.*\.img$'));
disp(files{1})
disp(mode);
end