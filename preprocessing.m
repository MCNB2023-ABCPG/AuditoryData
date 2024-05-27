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
    spm_path = '/Users/angelaseo/Desktop/spm12';
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

%% Option 1 and Option 2 are commented out; see legend below and edit switch_prep

% specifying the steps
% 1 - realign
% 2 - coregister
% 3 - segment
% 4 - normalise
% 5 - smooth

switch_prep = [1];

% % OPTION 1
% for i = switch_prep
% 
%     switch i
%         case 1 
%             % REALIGN
%             % select files
%             file_path_volumes = cellstr(spm_select('ExtFPListRec', folder_path_run, '^f.*\.img$', 1));
% 
%             % job options
%             job = [];
%             job{1}.spm.spatial.realign.estwrite.data = {file_path_volumes};
%             job{1}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
%             job{1}.spm.spatial.realign.estwrite.eoptions.sep = 4;
%             job{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
%             job{1}.spm.spatial.realign.estwrite.eoptions.rtm = 0;
%             job{1}.spm.spatial.realign.estwrite.eoptions.interp = 2;
%             job{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
%             job{1}.spm.spatial.realign.estwrite.eoptions.weight = '';
%             job{1}.spm.spatial.realign.estwrite.roptions.which = [0 1];
%             job{1}.spm.spatial.realign.estwrite.roptions.interp = 4;
%             job{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
%             job{1}.spm.spatial.realign.estwrite.roptions.mask = 1;
%             job{1}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
% 
%             spm_jobman('run', job)
%         end
% 
% 
%         case 2
%             % COREGISTER
%             file_path_str = spm_select('ExtFPListRec', folder_path_str, '^s.*\.img$', 1);
%             file_path_mean = spm_select('ExtFPListRec', folder_path_run, '^mean.*\.img', 1);
% 
%             % job options
%             job = [];
%             job{1}.spm.spatial.coreg.estimate.ref = {file_path_mean};
%             job{1}.spm.spatial.coreg.estimate.source = {file_path_str};
%             job{1}.spm.spatial.coreg.estimate.other = {''};
%             job{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
%             job{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
%             job{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
%             job{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
% 
%             spm_jobman('run', job)
%         end
% 
%         case 3
%             % SEGMENT
%             spm_path_nii = spm_select('FPList', fullfile(spm_path,'tpm'), '^TPM.nii$');
%             spm_path_nii_list = cellstr([repmat(spm_path_nii,6,1) strcat(',',num2str([1:6]'))]);
% 
%             % job options
%             job = [];
%             job{1}.spm.spatial.preproc.channel.vols = {file_path_str};
%             job{1}.spm.spatial.preproc.channel.biasreg = 0.001;
%             job{1}.spm.spatial.preproc.channel.biasfwhm = 60;
%             job{1}.spm.spatial.preproc.channel.write = [0 1];
%             job{1}.spm.spatial.preproc.tissue(1).tpm = {spm_path_nii_list{1}};
%             job{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
%             job{1}.spm.spatial.preproc.tissue(1).native = [1 0];
%             job{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
%             job{1}.spm.spatial.preproc.tissue(2).tpm = {spm_path_nii_list{2}};
%             job{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
%             job{1}.spm.spatial.preproc.tissue(2).native = [1 0];
%             job{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
%             job{1}.spm.spatial.preproc.tissue(3).tpm = {spm_path_nii_list{3}};
%             job{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
%             job{1}.spm.spatial.preproc.tissue(3).native = [1 0];
%             job{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
%             job{1}.spm.spatial.preproc.tissue(4).tpm = {spm_path_nii_list{4}};
%             job{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
%             job{1}.spm.spatial.preproc.tissue(4).native = [1 0];
%             job{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
%             job{1}.spm.spatial.preproc.tissue(5).tpm = {spm_path_nii_list{5}};
%             job{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
%             job{1}.spm.spatial.preproc.tissue(5).native = [1 0];
%             job{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
%             job{1}.spm.spatial.preproc.tissue(6).tpm = {spm_path_nii_list{6}};
%             job{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
%             job{1}.spm.spatial.preproc.tissue(6).native = [0 0];
%             job{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
%             job{1}.spm.spatial.preproc.warp.mrf = 1;
%             job{1}.spm.spatial.preproc.warp.cleanup = 1;
%             job{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
%             job{1}.spm.spatial.preproc.warp.affreg = 'mni';
%             job{1}.spm.spatial.preproc.warp.fwhm = 0;
%             job{1}.spm.spatial.preproc.warp.samp = 3;
%             job{1}.spm.spatial.preproc.warp.write = [0 1];
%             job{1}.spm.spatial.preproc.warp.vox = NaN;
%             job{1}.spm.spatial.preproc.warp.bb = [NaN NaN NaN
%                                                           NaN NaN NaN];
% 
% 
%             spm_jobman('run', job)
%         end
% 
%         case 4
%             % NORMALISE
%             file_path_str_y = spm_select('FPList', folder_path_str, '^y_.*\.nii$');
% 
%             % job options
%             job = [];
%             job{1}.spm.spatial.normalise.write.subj.def = {file_path_str_y};
%             job{1}.spm.spatial.normalise.write.subj.resample = file_path_volumes;
%             job{1}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
%                                                               78 76 85];
%             job{1}.spm.spatial.normalise.write.woptions.vox = [3 3 3];
%             job{1}.spm.spatial.normalise.write.woptions.interp = 4;
%             job{1}.spm.spatial.normalise.write.woptions.prefix = 'w';        
% 
% 
%             spm_jobman('run', job)
%         end
%         case 5
%             % SMOOTH
%             file_path_volumes_norm = cellstr(spm_select('ExtFPListRec', folder_path_run, '^wf.*\.img$', 1));
% 
%             % job options
%             job = [];
%             job{1}.spm.spatial.smooth.data = file_path_volumes_norm;
%             job{1}.spm.spatial.smooth.fwhm = [7 7 7];
%             job{1}.spm.spatial.smooth.dtype = 0;
%             job{1}.spm.spatial.smooth.im = 0;
%             job{1}.spm.spatial.smooth.prefix = 's';
% 
%             spm_jobman('run', job)
%         end
% 
% end


% % OPTION 2
% for i = switch_prep
% 
%     if i == 1
%         % REALIGN
%             % select files
%             file_path_volumes = cellstr(spm_select('ExtFPListRec', folder_path_run, '^f.*\.img$', 1));
% 
%             % job options
%             job = [];
%             job{1}.spm.spatial.realign.estwrite.data = {file_path_volumes};
%             job{1}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
%             job{1}.spm.spatial.realign.estwrite.eoptions.sep = 4;
%             job{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
%             job{1}.spm.spatial.realign.estwrite.eoptions.rtm = 0;
%             job{1}.spm.spatial.realign.estwrite.eoptions.interp = 2;
%             job{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
%             job{1}.spm.spatial.realign.estwrite.eoptions.weight = '';
%             job{1}.spm.spatial.realign.estwrite.roptions.which = [0 1];
%             job{1}.spm.spatial.realign.estwrite.roptions.interp = 4;
%             job{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
%             job{1}.spm.spatial.realign.estwrite.roptions.mask = 1;
%             job{1}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
% 
%             spm_jobman('run', job)
%     end
% 
%     elseif i == 2
%         % COREGISTER
%             file_path_str = spm_select('ExtFPListRec', folder_path_str, '^s.*\.img$', 1);
%             file_path_mean = spm_select('ExtFPListRec', folder_path_run, '^mean.*\.img', 1);
% 
%             % job options
%             job = [];
%             job{1}.spm.spatial.coreg.estimate.ref = {file_path_mean};
%             job{1}.spm.spatial.coreg.estimate.source = {file_path_str};
%             job{1}.spm.spatial.coreg.estimate.other = {''};
%             job{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
%             job{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
%             job{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
%             job{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
% 
%             spm_jobman('run', job)
%     end
% 
%     elseif i == 3
%         % SEGMENT
%             spm_path_nii = spm_select('FPList', fullfile(spm_path,'tpm'), '^TPM.nii$');
%             spm_path_nii_list = cellstr([repmat(spm_path_nii,6,1) strcat(',',num2str([1:6]'))]);
% 
%             % job options
%             job = [];
%             job{1}.spm.spatial.preproc.channel.vols = {file_path_str};
%             job{1}.spm.spatial.preproc.channel.biasreg = 0.001;
%             job{1}.spm.spatial.preproc.channel.biasfwhm = 60;
%             job{1}.spm.spatial.preproc.channel.write = [0 1];
%             job{1}.spm.spatial.preproc.tissue(1).tpm = {spm_path_nii_list{1}};
%             job{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
%             job{1}.spm.spatial.preproc.tissue(1).native = [1 0];
%             job{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
%             job{1}.spm.spatial.preproc.tissue(2).tpm = {spm_path_nii_list{2}};
%             job{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
%             job{1}.spm.spatial.preproc.tissue(2).native = [1 0];
%             job{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
%             job{1}.spm.spatial.preproc.tissue(3).tpm = {spm_path_nii_list{3}};
%             job{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
%             job{1}.spm.spatial.preproc.tissue(3).native = [1 0];
%             job{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
%             job{1}.spm.spatial.preproc.tissue(4).tpm = {spm_path_nii_list{4}};
%             job{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
%             job{1}.spm.spatial.preproc.tissue(4).native = [1 0];
%             job{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
%             job{1}.spm.spatial.preproc.tissue(5).tpm = {spm_path_nii_list{5}};
%             job{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
%             job{1}.spm.spatial.preproc.tissue(5).native = [1 0];
%             job{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
%             job{1}.spm.spatial.preproc.tissue(6).tpm = {spm_path_nii_list{6}};
%             job{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
%             job{1}.spm.spatial.preproc.tissue(6).native = [0 0];
%             job{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
%             job{1}.spm.spatial.preproc.warp.mrf = 1;
%             job{1}.spm.spatial.preproc.warp.cleanup = 1;
%             job{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
%             job{1}.spm.spatial.preproc.warp.affreg = 'mni';
%             job{1}.spm.spatial.preproc.warp.fwhm = 0;
%             job{1}.spm.spatial.preproc.warp.samp = 3;
%             job{1}.spm.spatial.preproc.warp.write = [0 1];
%             job{1}.spm.spatial.preproc.warp.vox = NaN;
%             job{1}.spm.spatial.preproc.warp.bb = [NaN NaN NaN
%                                                           NaN NaN NaN];
% 
% 
%             spm_jobman('run', job)
% end
%     elseif i == 4
%         % NORMALISE
%             file_path_str_y = spm_select('FPList', folder_path_str, '^y_.*\.nii$');
% 
%             % job options
%             job = [];
%             job{1}.spm.spatial.normalise.write.subj.def = {file_path_str_y};
%             job{1}.spm.spatial.normalise.write.subj.resample = file_path_volumes;
%             job{1}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
%                                                               78 76 85];
%             job{1}.spm.spatial.normalise.write.woptions.vox = [3 3 3];
%             job{1}.spm.spatial.normalise.write.woptions.interp = 4;
%             job{1}.spm.spatial.normalise.write.woptions.prefix = 'w';        
% 
% 
%             spm_jobman('run', job)
%         end
%         elseif i == 5
%         % SMOOTH
%         file_path_volumes_norm = cellstr(spm_select('ExtFPListRec', folder_path_run, '^wf.*\.img$', 1));
% 
%         % job options
%         job = [];
%         job{1}.spm.spatial.smooth.data = file_path_volumes_norm;
%         job{1}.spm.spatial.smooth.fwhm = [7 7 7];
%         job{1}.spm.spatial.smooth.dtype = 0;
%         job{1}.spm.spatial.smooth.im = 0;
%         job{1}.spm.spatial.smooth.prefix = 's';
% 
%         spm_jobman('run', job)
%         end
%     end
% 
% end


% OPTION 3
if any(switch_prep == 1)
    % REALIGN
    % select files
    file_path_volumes = cellstr(spm_select('ExtFPListRec', folder_path_run, '^f.*\.img$', 1));
    
    % job options
    job = [];
    job{1}.spm.spatial.realign.estwrite.data = {file_path_volumes};
    job{1}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
    job{1}.spm.spatial.realign.estwrite.eoptions.sep = 4;
    job{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
    job{1}.spm.spatial.realign.estwrite.eoptions.rtm = 0;
    job{1}.spm.spatial.realign.estwrite.eoptions.interp = 2;
    job{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
    job{1}.spm.spatial.realign.estwrite.eoptions.weight = '';
    job{1}.spm.spatial.realign.estwrite.roptions.which = [0 1];
    job{1}.spm.spatial.realign.estwrite.roptions.interp = 4;
    job{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
    job{1}.spm.spatial.realign.estwrite.roptions.mask = 1;
    job{1}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
    
    spm_jobman('run', job)
end

if any(switch_prep == 2)
    % COREGISTER
    file_path_str = spm_select('ExtFPListRec', folder_path_str, '^s.*\.img$', 1);
    file_path_mean = spm_select('ExtFPListRec', folder_path_run, '^mean.*\.img', 1);

    % job options
    job = [];
    job{1}.spm.spatial.coreg.estimate.ref = {file_path_mean};
    job{1}.spm.spatial.coreg.estimate.source = {file_path_str};
    job{1}.spm.spatial.coreg.estimate.other = {''};
    job{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
    job{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
    job{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    job{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
    
    spm_jobman('run', job)
end

if any(switch_prep == 3)
    % SEGMENT
    spm_path_nii = spm_select('FPList', fullfile(spm_path,'tpm'), '^TPM.nii$');
    spm_path_nii_list = cellstr([repmat(spm_path_nii,6,1) strcat(',',num2str([1:6]'))]);

    % job options
    job = [];
    job{1}.spm.spatial.preproc.channel.vols = {file_path_str};
    job{1}.spm.spatial.preproc.channel.biasreg = 0.001;
    job{1}.spm.spatial.preproc.channel.biasfwhm = 60;
    job{1}.spm.spatial.preproc.channel.write = [0 1];
    job{1}.spm.spatial.preproc.tissue(1).tpm = {spm_path_nii_list{1}};
    job{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
    job{1}.spm.spatial.preproc.tissue(1).native = [1 0];
    job{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
    job{1}.spm.spatial.preproc.tissue(2).tpm = {spm_path_nii_list{2}};
    job{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
    job{1}.spm.spatial.preproc.tissue(2).native = [1 0];
    job{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
    job{1}.spm.spatial.preproc.tissue(3).tpm = {spm_path_nii_list{3}};
    job{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
    job{1}.spm.spatial.preproc.tissue(3).native = [1 0];
    job{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
    job{1}.spm.spatial.preproc.tissue(4).tpm = {spm_path_nii_list{4}};
    job{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
    job{1}.spm.spatial.preproc.tissue(4).native = [1 0];
    job{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
    job{1}.spm.spatial.preproc.tissue(5).tpm = {spm_path_nii_list{5}};
    job{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
    job{1}.spm.spatial.preproc.tissue(5).native = [1 0];
    job{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
    job{1}.spm.spatial.preproc.tissue(6).tpm = {spm_path_nii_list{6}};
    job{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
    job{1}.spm.spatial.preproc.tissue(6).native = [0 0];
    job{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
    job{1}.spm.spatial.preproc.warp.mrf = 1;
    job{1}.spm.spatial.preproc.warp.cleanup = 1;
    job{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
    job{1}.spm.spatial.preproc.warp.affreg = 'mni';
    job{1}.spm.spatial.preproc.warp.fwhm = 0;
    job{1}.spm.spatial.preproc.warp.samp = 3;
    job{1}.spm.spatial.preproc.warp.write = [0 1];
    job{1}.spm.spatial.preproc.warp.vox = NaN;
    job{1}.spm.spatial.preproc.warp.bb = [NaN NaN NaN
                                                  NaN NaN NaN];


    spm_jobman('run', job)
end

if any(switch_prep == 4)
    % NORMALISE
    file_path_str_y = spm_select('FPList', folder_path_str, '^y_.*\.nii$');

    % job options
    job = [];
    job{1}.spm.spatial.normalise.write.subj.def = {file_path_str_y};
    job{1}.spm.spatial.normalise.write.subj.resample = file_path_volumes;
    job{1}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                                      78 76 85];
    job{1}.spm.spatial.normalise.write.woptions.vox = [3 3 3];
    job{1}.spm.spatial.normalise.write.woptions.interp = 4;
    job{1}.spm.spatial.normalise.write.woptions.prefix = 'w';        


    spm_jobman('run', job)
end

if any(switch_prep == 5)
    % SMOOTH
    file_path_volumes_norm = cellstr(spm_select('ExtFPListRec', folder_path_run, '^wf.*\.img$', 1));
    
    % job options
    job = [];
    job{1}.spm.spatial.smooth.data = file_path_volumes_norm;
    job{1}.spm.spatial.smooth.fwhm = [7 7 7];
    job{1}.spm.spatial.smooth.dtype = 0;
    job{1}.spm.spatial.smooth.im = 0;
    job{1}.spm.spatial.smooth.prefix = 's';

    spm_jobman('run', job)
end




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

    end % run loop


end % subject loop

rmpath(spm_path)

end 