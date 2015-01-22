%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ImpFreq
%   Plots a simple impedance vs frequency plot
%   Author: Kevin O'Neill
%   Date: 2014/12/11
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Load in data

[fileName, pathName] = uigetfile();

load(fullfile(pathName, fileName));

%% Average frequencies

% List of frequencies [Hz]
freqListStr = {'35', '70', '140', '280', '560','1120', '2240'};
freqList = [35, 70, 140, 280, 560, 1120, 2240];


for i = 1:length(freqListStr);
    tmpData = eval(['impData.f', freqListStr{i}, 'Hz']);
    dataIdx = tmpData>=0.001;
    dataIdx = find(dataIdx(1,:)==1, 1,'First');
    dataMean(:,i) = mean(tmpData(:, dataIdx:end),2);
    dataError(:,i) = 2*std(tmpData(:, dataIdx:end),1, 2);
        
end % END FOR

dataMean = dataMean.*1000;
dataError = dataError.*1000;

% errorbar(dataMean(1,:), dataError(1,:))
errorbar(dataMean', dataError')
xlim([0.5,7.5])
ylim([0, 600]);

title('Monkey Electrode Impedance. 2014/12/12')
xlabel('Frequency, Hz')
ylabel('Impedance, k\Omega')

set(gca, 'XTick', [1:7]);
set(gca, 'XTickLabel', freqListStr);
