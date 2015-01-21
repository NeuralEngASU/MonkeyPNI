function autoCentral(mode,configfile)

% Creates Central configuration files, loads configuration files and starts
% Central recording, and stops Central recording. Control of Central is via
% cbmex. autoCentral.exe can be called in Labview using the command line
% vi.
%
% Example: autoCentral('SaveConfiguration','E:\Code\Tasks\TaskAutomation\ConfigFiles\32ChanRecording2K.mat')
% Example: autoCentral('StartRecording','E:\Code\Tasks\TaskAutomation\ConfigFiles\32ChanRecording2K.mat')
% Example: autoCentral('StopRecording')
%
% Version date: 20120728
% Author: Tyler Davis

tmp1 = 'C:\Program Files (x86)\Blackrock Microsystems\NeuroPort Windows Suite\Central.exe';
tmp2 = 'C:\Program Files (x86)\Blackrock Microsystems\Cerebus Windows Suite\Central.exe';
if exist(tmp1,'file')
    CentralFile = tmp1;
elseif exist(tmp2,'file')
    CentralFile = tmp2;
else
    disp('error: Install Cerebus Windows Suite on this computer')
    return
end

switch mode
    case 'SaveConfiguration'
        
        try
            cbmex('open',1)
            chan_labels = cbmex('chanlabel');
            chan_labels(:,2:end) = [];
            config = cell(size(chan_labels,1),1);
            for k=1:size(chan_labels,1)
                config(k) = {cbmex('config',k)};
            end
            save(configfile,'config','chan_labels')
            cbmex('close',1)
        catch ME
            if strcmp(ME.message,'Unable to open library for Central interface')
                disp('error: Open Central and set the desired channel properties')
            else
                disp(['error: ',ME.message])
            end
        end
        
    case 'StartRecording'
        
        try
            % Starting Central and cbmex interface
            [status,~] = system('powershell -inputformat none -command get-process -name Central'); %checks if Central is open
            if status
                system(['powershell -inputformat none -command start-process -filepath ''',CentralFile,'''']); %opens Central
            else
                [status,~] = system('powershell -inputformat none -command get-process -name File');
                if ~status
                    system('powershell -inputformat none -command stop-process -name File'); %closes file storage if open
                end
            end
            pause(2)
            cbmex('open',1)
            
            % Loading channel labels
            load(configfile)
            cbmex('chanlabel',1:size(chan_labels,1),chan_labels)
            pause(1)
            
            % Loading channel properties
            for k=1:size(config,1)
                chan_config = config{k};
                chan_config = cell2mat(reshape([regexprep(chan_config(:,1),'(.*)',',''$1'','),cellfun(@num2str,chan_config(:,2),'uniformoutput',false)]',[],1)');
                eval(['cbmex(''config'',',num2str(k),chan_config,')'])
            end
            pause(1)
            
            % Starting recording
            folderName = datestr(clock,'yyyymmdd-HHMMSS');
            dataPath = ['D:\Data\',folderName];
            mkdir(dataPath);
            cbmex('fileconfig','','', 0)
            pause(1)
            cbmex('fileconfig',fullfile(dataPath,folderName),'',1)
            pause(1)
            cbmex('close',1)
            
            % Checking for .nev file to verify recording
            if exist(fullfile(dataPath,[folderName,'-001.nev']),'file')
                disp(['Recording started successfully: ',folderName])
            else
                disp('error: Recording failed to start')
            end
        catch ME
            if strcmp(ME.message,'Unable to open library for Central interface')
                disp('error: Central failed to start')
            else
                disp(['error: ',ME.message])
            end
        end
        
    case 'StopRecording'
        
        try
            [status,~] = system('powershell -inputformat none -command get-process -name File'); %checks if file storage is open
            if ~status
                cbmex('open',1)
                cbmex('fileconfig','','', 0)
                cbmex('close',1)
                system('powershell -inputformat none -command stop-process -name File'); %closes file storage
                disp('Recording stopped')
            else
                disp('error: No active recording found')
            end
        catch ME
            disp(['error: ',ME.message])
        end
        
    otherwise
        disp('error: Invalid function input')
        
end



    
    
    
    
    