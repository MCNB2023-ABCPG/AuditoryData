% List of open inputs
% fMRI model specification: Directory - cfg_files
% fMRI model specification: Interscan interval - cfg_entry
% fMRI model specification: Scans - cfg_files
% fMRI model specification: Name - cfg_entry
% fMRI model specification: Durations - cfg_entry
nrun = X; % enter the number of runs here
jobfile = {'/Users/pschm/Documents/University/mcnb/2_semester/NMDA-II/AuditoryData/specify_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(5, nrun);
for crun = 1:nrun
    inputs{1, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification: Directory - cfg_files
    inputs{2, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification: Interscan interval - cfg_entry
    inputs{3, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification: Scans - cfg_files
    inputs{4, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification: Name - cfg_entry
    inputs{5, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification: Durations - cfg_entry
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
