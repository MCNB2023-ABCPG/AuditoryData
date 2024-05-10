% List of open inputs
% Realign: Estimate & Reslice: Session - cfg_files
% Coregister: Estimate: Reference Image - cfg_files
% Coregister: Estimate: Source Image - cfg_files
% Segment: Volumes - cfg_files
% Normalise: Write: Data - cfg_repeat
% Smooth: Images to smooth - cfg_files
nrun = 1; % enter the number of runs here
wd = '/Users/pschm/Documents/University/mcnb/2_semester/NMDA-II/AuditoryData'; % enter working directory
jobfile = {strcat(wd,'/auditory/jobs/batch_job.m')};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(6, nrun);
%for crun = 1:nrun
%    inputs{1, crun} = MATLAB_CODE_TO_FILL_INPUT; % Realign: Estimate & Reslice: Session - cfg_files
%    inputs{2, crun} = MATLAB_CODE_TO_FILL_INPUT; % Coregister: Estimate: Reference Image - cfg_files
%    inputs{3, crun} = MATLAB_CODE_TO_FILL_INPUT; % Coregister: Estimate: Source Image - cfg_files
%    inputs{4, crun} = MATLAB_CODE_TO_FILL_INPUT; % Segment: Volumes - cfg_files
%    inputs{5, crun} = MATLAB_CODE_TO_FILL_INPUT; % Normalise: Write: Data - cfg_repeat
%    inputs{6, crun} = MATLAB_CODE_TO_FILL_INPUT; % Smooth: Images to smooth - cfg_files
%end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
