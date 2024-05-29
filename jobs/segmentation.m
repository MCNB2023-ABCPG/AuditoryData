function segmentation(str_vols, spm_path_nii_list)
job = [];
job{1}.spm.spatial.preproc.channel.vols = {str_vols};
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