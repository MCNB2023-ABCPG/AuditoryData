function bids_setup()

% 
% bids-root/                % root directory
%   code/                   % all scripts
%   sourcedata/             % data NOT in BIDS format - e.g. DICOM
%   derivatives/            % everything different from the raw data
%     preprocessed/         % this is a pipeline
%       sub-01/
%         ses-01/           % if only one ses then ses is skipped
%            run-01/        % SPM 3D volumes stored here
%            run-02/ 
%       ...
%   sub-01/                 % raw data - output of DICOM to BIDS conversion
%     ses-01/
%       func/               % contain 4D files for individual runs
%       ana/
%   ...
%
%
% Parameters
% ----------
%       None
% 
% Returns
% ----------
%       None
%     
% Other
% ----------
%       Writes to disk
%
%
% Variable names for files and folders
%   file_path_              % full path to file
%   folder_path_            % full path to folder
%   file_base_              % basename file (usually appended to path)
%   folder_base_            % basename folder (usually appended to path)



% -------- INIT VARIABLES -------- %
folder_path_root = '/Users/pschm/Documents/University/mcnb/2_semester/NMDA-II/bids_test';
folder_path_code = fullfile(folder_path_root, 'code');
folder_path_sourcedata = fullfile(folder_path_root, 'sourcedata');
folder_path_derivatives = fullfile(folder_path_root, 'derivatives');

% How many subjects, sessions, runs? Either cell array (char) or number (double)
sub_n = 2; 
ses_n = 1;
run_n = 2;

% What subdirectories + modalities are needed?
% preprocessing
folder_base_pipelines{1}.name = {'preprocessing'}; % name of the pipeline
folder_base_pipelines{1}.modalities = {'anat','func'}; % lowest unit gets these modalieties
folder_base_pipelines{1}.run = {true}; % run folder necessary?
% first-level analysis
folder_base_pipelines{2}.name = {'firstlevel_analysis'};
folder_base_pipelines{2}.modalities = {NaN}; % results of first-level analysis will be safed directly in sub folder
folder_base_pipelines{2}.run = {false}; % run folder necessary?
% ADD MORE
% folder_base_pipelines{3}.name = {};
% folder_base_pipelines{3}.modalities = {}; % results of first-level analysis will be safed directly in sub folder
% folder_base_pipelines{3}.run = {}; % run folder necessary?



% -------- INIT FOLDER STRUCTURE-------- %
% creating code, sourcedate, derivatives folders
for i = {folder_path_code, folder_path_sourcedata, folder_path_derivatives}
    if ~exist(i{:}, 'dir')
        mkdir(i{:})
    end
end

% evaluate sub, ses, run structure
for i = {sub_n, ses_n, run_n}
    if ~isa(i{:}, 'double') && ~isa(i{:}, 'cell')
        error('Check values for sub_n, sess_n, run_n: Neither a cell array nor a number') 
    end
end

if isa(sub_n, 'double')
   sub_all = arrayfun(@(x) sprintf('%02d', x), 1:sub_n, 'UniformOutput', false);
elseif isa(sub_n, 'cell')
   sub_all = sub_n;
end

if isa(sub_n, 'double')
   ses_all = repmat(arrayfun(@(x) sprintf('%02d', x), 1:ses_n, 'UniformOutput', false),sub_n,1);
elseif isa(sub_n, 'cell')
   ses_all = ses_n;
end

if isa(sub_n, 'double')
   run_all = repmat(arrayfun(@(x) sprintf('%02d', x), 1:run_n, 'UniformOutput', false),sub_n*run_n,1);
elseif isa(sub_n, 'cell')
   run_all = run_n;
end


% looping over pipelines, create structure in each pipeline
for i = 1:numel(folder_base_pipelines)
    folder_path_pipeline = fullfile(folder_path_root, 'derivatives',folder_base_pipelines{i}.name{:});

    if ~exist(folder_path_pipeline, 'dir')
        mkdir(folder_path_pipeline)
    end

    for j = 1:numel(sub_all)
        folder_path_sub = fullfile(folder_path_pipeline, ['sub-', sub_all{j}]);
        mkdir(folder_path_sub);
        
        ses_sub = ses_all(j,:);
        run_sub = run_all(j,:);

        for k = 1:numel(ses_sub)
            if numel(ses_sub) == 1
                folder_path_ses = folder_path_sub;
            else
                folder_path_ses = fullfile(folder_path_sub,['ses-', ses_sub{k}]);
                mkdir(folder_path_ses)
            end

            for l = 1:numel(run_sub)
                if folder_base_pipelines{i}.run{:}
                    folder_path_run = fullfile(folder_path_ses,['run-', run_sub{l}]);
                    mkdir(folder_path_run)
                else
                    folder_path_run = folder_path_ses;
                end
                
                    
                for p = folder_base_pipelines{i}.modalities
                    if ~isnan(p{:})
                        folder_path_modalities = fullfile(folder_path_run, p{:});
                        mkdir(folder_path_modalities);
                    end
                    
                end % modalities loop
            end % run loop
        end % session loop
    end % subject loop
end % pipeline loop





end % main function


