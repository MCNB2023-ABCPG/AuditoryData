function preprocessing(folder_path_root, spm_path)
%
% Ideas for general structure from:
% https://github.com/phildean/SPM_fMRI_Example_Pipeline/blob/master/preprocess.m
% https://bids-standard.github.io/bids-starter-kit/
% https://youtube.com/playlist?list=PLhzkDK3o0fcCO3hQORMU6GjKGBjMRWBSb&si=wE4SUJ1x1r-jQyFG
% https://dartbrains.org/content/Group_Analysis.html
% https://github.com/Neurocomputation-and-Neuroimaging-Unit/fMRI_task-based
% 
% This function runs on the highest hierarchy, i.e. it should prepare and execute the preprocessing for each subject
% The data structure should be the following:
% TOP % Location of the data folder
% -> DATA % Data for all participants
%     -> PAR_1 % each subject has its own folder
%         -> PRE % Preprocessing
%               -> RUN_1
%                   -> VOL_1.img
%                   -> VOL_2.img
%                   ...
%               -> RUN_2
%         -> GLM % GLM
%         -> BEH  % Behavioural data
%
%
% Variable names for files and folders
%   file_path_              % full path to file
%   folder_path_            % full path to folder
%   file_base_              % basename file (usually appended to path)
%   folder_base_            % basename folder (usually appended to path)
%
%
% Parameters
% ----------
%       folder_path_root = char
%           specify the folder in which the data folder is located -> TOP
% 
% Returns
% ----------
%       None
%     
% Other
% ----------
%       Writes to disk


% initialization
if ~exist('spm_path', 'var')
    spm_path = '/Users/pschm/spm12';
end

if ~exist('folder_path_root','var')
    folder_path_root = fileparts(matlab.desktop.editor.getActiveFilename);
end

addpath(spm_path)
addpath(fullfile(folder_path_root,'jobs'))
spm('defaults', 'fmri') 
spm_jobman('initcfg')


% specifying data, participant and run paths
folder_path_data = fullfile(folder_path_root, 'DATA'); % DATA foulder path
folder_base_sub = {'PAT_1'}; % {'PAT_1', 'PAT_2'}
folder_base_run = {[1]}; % {[1 2 3] [1 2 3]} this would be two participnats with each three runs

% specifying the steps: fill in switch_prep
% 1 - realign
% 2 - coregister
% 3 - segment
% 4 - normalise
% 5 - smooth

switch_prep = [1 2 3 4 5];


% iteration over participants
for i = 1:numel(folder_base_sub)

    S = []; % init empty structure
    S.folder_path_data = folder_path_data; % add data folder path
    S.folder_base_sub = folder_base_sub{i}; % add subject path
    S.folder_base_run = folder_base_run{i}; % add run path

    % participant PRE directory
    folder_path_pre = fullfile(S.folder_path_data, S.folder_base_sub, 'PRE'); % Folder PRE for preprocessing path for the participant
    folder_path_str = fullfile(S.folder_path_data, S.folder_base_sub, 'PRE', 'STR'); % Folder STR for structural path

    % iterate over runs
    for r = 1:numel(S.folder_base_run)
    
        % specify the RUN directory according to the run sequence in S.folder_base_run
        folder_path_run = fullfile(folder_path_pre, ['RUN_' num2str(S.folder_base_run(r))]); 

        % REALIGN
        if any(switch_prep == 1)
            % select files
            file_path_volumes = cellstr(spm_select('ExtFPListRec', folder_path_run, '^f.*\.img$', 1));
            % run realignment
            realignment(file_path_volumes) 
        end

        % COREGISTER
        if any(switch_prep == 2)
            % select the structural source
            file_path_str = spm_select('ExtFPListRec', folder_path_str, '^s.*\.img$', 1);
            
            % select mean image as reference
            file_path_mean = spm_select('ExtFPListRec', folder_path_run, '^mean.*\.img', 1);

            %run
            coregistration(file_path_str, file_path_mean)
        end

        % SEGMENTATION
        if any(switch_prep == 3)
            % select nii files from spm path
            spm_path_nii = spm_select('FPList', fullfile(spm_path,'tpm'), '^TPM.nii$');
            spm_path_nii_list = cellstr([repmat(spm_path_nii,6,1) strcat(',',num2str([1:6]'))]);
            
            % select structural
            file_path_str = spm_select('ExtFPListRec', folder_path_str, '^s.*\.img$', 1);

            % run
            segmentation(file_path_str, spm_path_nii_list)
        end
        
        % NORMALIZATION
        if any(switch_prep == 4)
            % select deformation field from segmentation
            file_path_str_y = spm_select('FPList', folder_path_str, '^y_.*\.nii$');

            % select volumes
            file_path_volumes = cellstr(spm_select('ExtFPListRec', folder_path_run, '^f.*\.img$', 1));

            % run
            normalization(file_path_str_y,file_path_volumes)
        end
        
        % SMOOTHING
        if any(switch_prep == 5)
            % select normalized volumes
            file_path_volumes_norm = cellstr(spm_select('ExtFPListRec', folder_path_run, '^wf.*\.img$', 1));

            % run
            smoothing(file_path_volumes_norm)
        end


    end % run loop
end % subject loop



rmpath(spm_path)
rmpath(fullfile(folder_path_root,'jobs'))

end 