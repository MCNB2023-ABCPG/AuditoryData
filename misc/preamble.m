%%% Prepare the directories and data
% working_directory should be a string leading to AuditoryData
function preamble(working_directory)

    % change working directory
    % working_directory = strrep(matlab.desktop.editor.getActiveFilename, 'preamble.m', '');
    cd(working_directory)
    
    
    % create auditory
    if ~exist('./auditory/', 'dir')
           mkdir('./auditory/')
    end
    
    
    % create subfolders
    subfolders = ["classical", "dummy", "jobs"];
    
    for sub = subfolders
        path = strcat('./auditory/', sub, '/');
        if ~exist(path, 'dir')
               mkdir(path)
        end
    end
    
    
    % move .img and .hdr files 004 to 015 to dummy
    try
        for i = 4:15
            number = sprintf('%03d', i);
            %file = sprintf('MoAEpilot/fM00223/fM00223_%s.img', number);
            file = sprintf('MoAEpilot/fM00223/fM00223_%s.*', number);
            movefile(file, './auditory/dummy/');
        end
    catch
        warning('Files do not exist, check if already moved.');
    end
