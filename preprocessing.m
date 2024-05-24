function preprocessing(wd, spm_path)
%
% Ideas for general structure from:
% https://github.com/phildean/SPM_fMRI_Example_Pipeline/blob/master/preprocess.m
% https://youtube.com/playlist?list=PLhzkDK3o0fcCO3hQORMU6GjKGBjMRWBSb&si=wE4SUJ1x1r-jQyFG
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
% Parameters
% ----------
%       wd = char
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


% iteration over participants
for i = 1:numel(pat_dir)

    S = []; % init empty structure
    S.dat_dir = dat_dir; % add data folder path
    S.pat_dir = pat_dir{i}; % add subject path
    S.run_dir = run_dir{i}; % add run path

    % participant PRE directory
    pat_pre_dir = fullfile(S.dat_dir, S.pat_dir, 'PRE'); % Folder PRE for preprocessing path for the participant
    pat_pre_str_dir = fullfile(S.dat_dir, S.pat_dir, 'PRE', 'STR'); % Folder STR for structural path

    % iterate over runs
    for r = 1:numel(S.run_dir)
    
        % specify the RUN directory according to the run sequence in S.run_dir
        pat_run_dir = fullfile(pat_pre_dir, ['RUN_' num2str(S.run_dir(r))]); 
        
        
        % REALIGN
        % select files
        pat_run_volumes = cellstr(spm_select('ExtFPListRec', pat_run_dir, '^f.*\.img$', 1));
        
        % job options
        job = [];
        job{1}.spm.spatial.realign.estwrite.data = {pat_run_volumes};
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
        

        % COREGISTER
        pat_run_str = spm_select('ExtFPListRec', pat_pre_str_dir, '^s.*\.img$', 1);
        pat_run_mean = spm_select('ExtFPListRec', pat_pre_dir, '^mean.*\.img', 1);

        % job options
        job = [];
        job{1}.spm.spatial.coreg.estimate.ref = {pat_run_mean};
        job{1}.spm.spatial.coreg.estimate.source = {pat_run_str};
        job{1}.spm.spatial.coreg.estimate.other = {''};
        job{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
        job{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
        job{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
        job{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
        
        spm_jobman('run', job)


        % SEGMENT
        spm_path_nii = spm_select('FPList', fullfile(spm_path,'tpm'), '^TPM.nii$');
        spm_path_nii_list = cellstr([repmat(spm_path_nii,6,1) strcat(',',num2str([1:6]'))]);

        % job options
        job = [];
        job{1}.spm.spatial.preproc.channel.vols = {pat_run_str};
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


        % NORMALISE
        pat_run_str_y = spm_select('FPList', pat_pre_str_dir, '^y_.*\.nii$');

        % job options
        job = [];
        job{1}.spm.spatial.normalise.write.subj.def = {pat_run_str_y};
        job{1}.spm.spatial.normalise.write.subj.resample = pat_run_volumes;
        job{1}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                                          78 76 85];
        job{1}.spm.spatial.normalise.write.woptions.vox = [3 3 3];
        job{1}.spm.spatial.normalise.write.woptions.interp = 4;
        job{1}.spm.spatial.normalise.write.woptions.prefix = 'w';        


        spm_jobman('run', job)
        


        % SMOOTH
        pat_run_volumes_norm = cellstr(spm_select('ExtFPListRec', pat_run_dir, '^wf.*\.img$', 1));
        
        % job options
        job = [];
        job{1}.spm.spatial.smooth.data = pat_run_volumes_norm;
        job{1}.spm.spatial.smooth.fwhm = [7 7 7];
        job{1}.spm.spatial.smooth.dtype = 0;
        job{1}.spm.spatial.smooth.im = 0;
        job{1}.spm.spatial.smooth.prefix = 's';

        spm_jobman('run', job)

    end % run loop


end % subject loop

rmpath(spm_path)

end 