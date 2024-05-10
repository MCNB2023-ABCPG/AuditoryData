function firstlevel_analysis(wd, spm_path)


% initialization
if ~exist('spm_path', 'var')
    spm_path = '/Users/pschm/spm12';
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
    
    % select smoothed img
    pat_run_volumes_smooth = cellstr(spm_select('ExtFPListRec', pat_run_dir, '^swf.*\.img$', 1));
    

    job = [];
    job{1}.spm.stats.fmri_spec.dir = {pat_glm_dir};
    job{1}.spm.stats.fmri_spec.timing.units = 'scans';
    job{1}.spm.stats.fmri_spec.timing.RT = 7;
    job{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
    job{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
    job{1}.spm.stats.fmri_spec.sess.scans = pat_run_volumes_smooth;
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
    pat_glm_design = spm_select('FPList', pat_glm_dir, '^SPM.mat$');

    % job options
    job = [];
    job{1}.spm.stats.fmri_est.spmmat = {pat_glm_design};
    job{1}.spm.stats.fmri_est.write_residuals = 0;
    job{1}.spm.stats.fmri_est.method.Classical = 1;

    spm_jobman('run', job);


end