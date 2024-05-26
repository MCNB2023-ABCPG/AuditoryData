function contrasts(folder_path_root, spm_path)


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

    % select the design
    file_path_design = spm_select('FPList', folder_path_glm, '^SPM.mat$');

    job = [];
    job{1}.spm.stats.con.spmmat = {file_path_design};
    job{1}.spm.stats.con.consess{1}.tcon.name = 'listening>rest';
    job{1}.spm.stats.con.consess{1}.tcon.weights = [1 0];
    job{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    
    %job{1}.spm.stats.con.consess{2}.tcon.name = 'name_of_contrast';
    %job{1}.spm.stats.con.consess{2}.tcon.weights = [-1 0];
    %job{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    
    job{1}.spm.stats.con.delete = 0;
    
    spm_jobman('run', job);
    
    
    job = [];
    job{1}.spm.stats.results.spmmat = {file_path_design};
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