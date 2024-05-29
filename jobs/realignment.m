function realignment(data)

job = [];
job{1}.spm.spatial.realign.estwrite.data = {data};
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