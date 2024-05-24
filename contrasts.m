function contrasts(wd, spm_path)


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

     % select the design
    pat_glm_design = spm_select('FPList', pat_glm_dir, '^SPM.mat$');

    job = [];
    job{1}.spm.stats.con.spmmat = {'./DATA/PAT_1/GLM/SPM.mat'};
    job{1}.spm.stats.con.consess{1}.tcon.name = 'listening>rest';
    job{1}.spm.stats.con.consess{1}.tcon.weights = [1 0];
    job{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    
    %job{1}.spm.stats.con.consess{2}.tcon.name = 'name_of_contrast';
    %job{1}.spm.stats.con.consess{2}.tcon.weights = [-1 0];
    %job{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    
    job{1}.spm.stats.con.delete = 0;
    
    spm_jobman('run', job);
    
    
    job = [];
    job{1}.spm.stats.results.spmmat = {'/Users/pschm/Documents/University/mcnb/2_semester/NMDA-II/AuditoryData/DATA/PAT_1/GLM/SPM.mat'};
    job{1}.spm.stats.results.conspec.titlestr = '';
    job{1}.spm.stats.results.conspec.contrasts = 1;
    job{1}.spm.stats.results.conspec.threshdesc = 'FWE';
    job{1}.spm.stats.results.conspec.thresh = 0.05;
    job{1}.spm.stats.results.conspec.extent = 0;
    job{1}.spm.stats.results.conspec.conjunction = 1;
    job{1}.spm.stats.results.conspec.mask.none = 1;
    job{1}.spm.stats.results.units = 1;
    job{1}.spm.stats.results.export{1}.ps = true;
    job{1}.spm.stats.results.export{2}.tspm.basename = 'output';
    job{1}.spm.stats.results.export{3}.jpg = true;
    
    
    spm_jobman('run', job);

end