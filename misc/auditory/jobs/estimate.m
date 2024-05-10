% List of open inputs
% Model estimation: Select SPM.mat - cfg_files
nrun = X; % enter the number of runs here
jobfile = {'/Users/pschm/Documents/University/mcnb/2_semester/NMDA-II/AuditoryData/estimate_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(1, nrun);
for crun = 1:nrun
    inputs{1, crun} = MATLAB_CODE_TO_FILL_INPUT; % Model estimation: Select SPM.mat - cfg_files
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
