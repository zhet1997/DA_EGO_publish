%2022-1-11
clc;clear;
caseMax = 3;
pathRoot = 'D:\WQN\DATA\data_BS_30D\';
pathSam = 'D:\WQN\DATA\IniSam\';
warning('off');

while true
    [taskCurrent,caseNum] = readList(pathRoot,caseMax) ;
    option = updateOption(pathRoot,taskCurrent,caseNum,pathSam);
    condition =  checkCondition(option);
    option = setOption(taskCurrent,option);
    option.coreNum = 3;
    switch condition
        case 'unexecuted'
            algo = option.algo;
        case 'unfinished'
            algo = @(x) load_opt(x);
        case  'finished'
            disp('The number of samples is reach the terminated comdition~');
            continue;
    end
    %=============================================================%
    try
        mainTest(option,algo)
    catch ME
        disp(ME.identifier);
    end
%     mainTest(option,algo)
end