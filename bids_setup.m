function bids_setup()
%
% Create a root directory, specify init variables and run script to set up bids structure  
% Paul Schmitthäuser (28.05.2024)
%
%
% bids-root/                % root directory
%   code/                   % all scripts
%   sourcedata/             % data NOT in BIDS format - e.g. DICOM
%   derivatives/            % everything different from the raw data
%     pipeline1/            % this is a pipeline
%       sub-01/             % adhere BIDS
%         ses-01/           % if only one ses then ses is skipped
%            anat/          
%            func/          % contain 4D files for individual runs
%            glm/
%         OR
%            run-01/        % RUNS ARE OPTIONAL - SPM 3D volumes stored here
%               anat/
%               func/
%               glm/ 
%         ses-02/
%            ...
%       sub-02/
%       ...
%
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
save_exp = true;                                                            % save experiment variables
folder_path_root = ...
    '/Users/pschm/Documents/University/mcnb/2_semester/NMDA-II/AuditoryData/bids_test';  % top level root directory 
folder_path_code = fullfile(folder_path_root, 'code');                      % scripts
folder_path_sourcedata = fullfile(folder_path_root, 'sourcedata');          % DICOM files
folder_path_derivatives = fullfile(folder_path_root, 'derivatives');        % everything else

% How many subjects, sessions, runs?
sub_n = 5;                                                                  % int or cell array with with char
ses_n = 1;                                                                  % int or cell array with with char
run_n = 5;                                                                  % int or cell array with with char

% What subdirectories + modalities are needed?
% pipeline with modalities at lowest level
folder_base_pipelines{1}.name = {'pipeline1'};                              % name of the pipeline
folder_base_pipelines{1}.modalities = {'anat','func','glm'};                % lowest unit gets these modalities
folder_base_pipelines{1}.run = {false};                                     % run folder necessary?

% pipeline without modalities at lowest level 
% folder_base_pipelines{2}.name = {'firstlevel_analysis'};                  % name of the pipeline
% folder_base_pipelines{2}.modalities = {NaN};                              % results of first-level analysis will be safed directly in sub folder
% folder_base_pipelines{2}.run = {false};                                   % run folder necessary?

% create pipelines inside sub with sub at derivatives level (ALTERNATIVE)
% folder_base_pipelines{1}.name = {NaN};                                    % no name leads to sub at derivative level
% folder_base_pipelines{1}.modalities = {'pipeline1', 'pipeline2'};         % add pi
% folder_base_pipelines{1}.run = {false};                                   % run folder necessary?

% ADD MORE
% folder_base_pipelines{1}.name = {};                                       % char or NaN
% folder_base_pipelines{1}.modalities = {};                                 % char or NaN
% folder_base_pipelines{1}.run = {};                                        % true or false



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

% save expriment variables
if save_exp
    save(fullfile(folder_path_code,'exp_var'), 'sub_all', 'ses_all', 'run_all', 'folder_base_pipelines')
end

% looping over pipelines, create structure in each pipeline
for i = 1:numel(folder_base_pipelines)

    if isnan(folder_base_pipelines{i}.name{:})
        folder_path_pipeline = fullfile(folder_path_root, 'derivatives');
    else
        folder_path_pipeline = fullfile(folder_path_root, 'derivatives',folder_base_pipelines{i}.name{:});

        if ~exist(folder_path_pipeline, 'dir')
            mkdir(folder_path_pipeline)
        end
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


            if ~folder_base_pipelines{i}.run{:}
                run_loop_n = 1;
            else
                run_loop_n = numel(run_sub);
            end


            for l = 1:run_loop_n
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
