function firstlevel_analysis(folder_path_root, spm_path)


% initialization
if ~exist('spm_path', 'var')
    spm_path = '/Users/pschm/spm12';
end

if ~exist('folder_path_root','var')
    folder_path_root = fileparts(matlab.desktop.editor.getActiveFilename);
end

addpath(spm_path)
spm('defaults', 'fmri') 
spm_jobman('initcfg')


% specifying data, participant and run paths
folder_path_data = fullfile(folder_path_root, 'DATA'); % DATA foulder path
folder_base_sub = {'PAT_1'}; % {'PAT_1', 'PAT_2'}
folder_base_run = {[1]}; % {[1 2 3] [1 2 3]} this would be two participnats with each three runs

for i = 1:numel(folder_base_sub)

    S = []; % init empty structure
    S.folder_path_data = folder_path_data; % add data folder path
    S.folder_base_sub = folder_base_sub{i}; % add subject path
    S.folder_base_run = folder_base_run{i}; % add run path
    
    % participant PRE directory
    folder_path_pre = fullfile(S.folder_path_data, S.folder_base_sub, 'PRE'); % Folder PRE for preprocessing path for the participant
    
    % select glm directory
    folder_path_glm = fullfile(S.folder_path_data, S.folder_base_sub, 'GLM');

    
    % for now just specifying RUN_1
    r = 1;
    folder_path_run = fullfile(folder_path_pre, ['RUN_' num2str(S.folder_base_run(r))]);
    
    % select smoothed img
    file_path_volumes_smooth = cellstr(spm_select('ExtFPListRec', folder_path_run, '^swf.*\.img$', 1));
    

    job = [];
    job{1}.spm.stats.fmri_spec.dir = {folder_path_glm};
    job{1}.spm.stats.fmri_spec.timing.units = 'scans';
    job{1}.spm.stats.fmri_spec.timing.RT = 7;
    job{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
    job{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
    job{1}.spm.stats.fmri_spec.sess.scans = file_path_volumes_smooth;
    job{1}.spm.stats.fmri_spec.sess.cond.name = 'listening';
    job{1}.spm.stats.fmri_spec.sess.cond.onset = [6
                                                      18
                                                      30
                                                      42
                                                      54
                                                      66
                                                      78];
    job{1}.spm.stats.fmri_spec.sess.cond.duration = 6;
    job{1}.spm.stats.fmri_spec.sess.cond.tmod = 0;
    job{1}.spm.stats.fmri_spec.sess.cond.pmod = struct('name', {}, 'param', {}, 'poly', {});
    job{1}.spm.stats.fmri_spec.sess.cond.orth = 1;
    job{1}.spm.stats.fmri_spec.sess.multi = {''};
    job{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
    job{1}.spm.stats.fmri_spec.sess.multi_reg = {''};
    job{1}.spm.stats.fmri_spec.sess.hpf = 128;
    job{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    job{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    job{1}.spm.stats.fmri_spec.volt = 1;
    job{1}.spm.stats.fmri_spec.global = 'None';
    job{1}.spm.stats.fmri_spec.mthresh = 0.8;
    job{1}.spm.stats.fmri_spec.mask = {''};
    job{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

    spm_jobman('run', job);


    
    % ESTIMATION

    % select the design
    file_path_design = spm_select('FPList', folder_path_glm, '^SPM.mat$');

    % job options
    job = [];
    job{1}.spm.stats.fmri_est.spmmat = {file_path_design};
    job{1}.spm.stats.fmri_est.write_residuals = 0;
    job{1}.spm.stats.fmri_est.method.Classical = 1;

    spm_jobman('run', job);


end