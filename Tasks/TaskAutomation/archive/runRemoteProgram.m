function runRemoteProgram(mode,scriptdir,ipaddress,program)

% Starts or stops a remote program at the specified address. When starting
% a program, "program" is the full path to the executable. When stopping a
% program, "program" is either the name or the pid of the process to be
% stopped. runRemoteProgram.exe can be called in Labview using the command
% line vi.
%
% Example: runRemoteProgram('StartProgram','E:\Code\Core\TaskAutomation\Scripts','155.101.184.62','C:\FingerPressRT.exe')
% Example: runRemoteProgram('StartProgram','E:\Code\Core\TaskAutomation\Scripts','localhost','C:\Windows\System32\notepad.exe') %localhost can be used to start a local program
% Example: runRemoteProgram('StopRecording','E:\Code\Core\TaskAutomation\Scripts','155.101.184.62','FingerPressRT.exe')
% Example: runRemoteProgram('StopRecording','E:\Code\Core\TaskAutomation\Scripts','155.101.184.62','8156')
%
% Version date: 20120724
% Author: Tyler Davis

switch mode
    case 'StartProgram'
        
        try
            [~,name,ext] = fileparts(program);
            [~,result] = system(['cscript "',fullfile(scriptdir,'ExistProgram.vbs'),'" "',ipaddress,'" "',[name,ext],'"']);
            if strcmp(cell2mat(deblank(regexp(result,'\w+\s$','match'))),'missing')
                [~,result] = system(['cscript "',fullfile(scriptdir,'StartProgram.vbs'),'" "',ipaddress,'" "',program,'"']);                                
                processId = cell2mat(deblank(regexp(result,'\w+\s$','match')));
                if isempty(regexp(processId,'\d+','once'))
                    disp(['error: ',result])
                else                                  
                    disp(['Program started successfully with processId: ',processId])
                end
            else
                disp(['error: ',result])
            end
        catch ME
            disp(['error: ',ME.message])
        end
        
    case 'StopProgram'
        
        try
            [~,result] = system(['cscript "',fullfile(scriptdir,'StopProgram.vbs'),'" "',ipaddress,'" "',program,'"']);
            if strcmp(cell2mat(deblank(regexp(result,'\w+\s$','match'))),'successfully')
                disp('Program stopped successfully')
            else
                disp(['error: ',result])
            end            
        catch ME
            disp(['error: ',ME.message])
        end
        
    otherwise
        disp('error: Invalid function input')
        
end



    
    
    
    
    