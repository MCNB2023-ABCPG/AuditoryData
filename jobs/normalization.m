function normalization(deformation, resample)

job = [];
job{1}.spm.spatial.normalise.write.subj.def = {deformation};
job{1}.spm.spatial.normalise.write.subj.resample = resample;
job{1}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                                  78 76 85];
job{1}.spm.spatial.normalise.write.woptions.vox = [3 3 3];
job{1}.spm.spatial.normalise.write.woptions.interp = 4;
job{1}.spm.spatial.normalise.write.woptions.prefix = 'w';        


spm_jobman('run', job)


end