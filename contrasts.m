function contrasts(wd, spm_path)


% initialization
if ~exist('spm_path', 'var')
    spm_path = '/Users/angelaseo/Desktop/spm12';
end

if ~exist('wd','var')
    wd = fileparts(matlab.desktop.editor.getActiveFilename);
end

addpath(spm_path)
spm('defaults', 'fmri') 
spm_jobman('initcfg')


% specifying data, participant and run paths
dat_dir = fullfile(wd, 'DATA'); % DATA foulder path
pat_dir = {'PAT_1'}; % {'PAT_1', 'PAT_2'}
run_dir = {[1]}; % {[1 2 3] [1 2 3]} this would be two participnats with each three runs

for i = 1:numel(pat_dir)

    S = []; % init empty structure
    S.dat_dir = dat_dir; % add data folder path
    S.pat_dir = pat_dir{i}; % add subject path
    S.run_dir = run_dir{i}; % add run path
    
    % participant PRE directory
    pat_pre_dir = fullfile(S.dat_dir, S.pat_dir, 'PRE'); % Folder PRE for preprocessing path for the participant
    
    % select glm directory
    pat_glm_dir = fullfile(S.dat_dir, S.pat_dir, 'GLM');

    
    % for now just specifying RUN_1
    r = 1;
    pat_run_dir = fullfile(pat_pre_dir, ['RUN_' num2str(S.run_dir(r))]);

     % select the design
    pat_glm_design = spm_select('FPList', pat_glm_dir, '^SPM.mat$');

%ADD BATCH SCRIPT HERE

end