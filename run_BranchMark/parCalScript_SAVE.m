%2022-1-11
clc;clear;
caseMax = 3;
pathRoot = 'D:\CODE\Test\mkOptionFile\30D_SRDA\';
pathSam = 'D:\DATA\IniSam_150\';
warning('off');

    optionList = importdata([pathRoot,'optionList.txt']);
    ii = 3;
    taskCurrent = optionList{ii,:};
    option = updateOption(pathRoot,optionList{ii,:},1,pathSam);
    condition =  checkCondition(option);
    option = setOption(taskCurrent,option);
    option.SAVE_MODE=0;
    option.DEBUG_MODE=1;
    option.coreNum = 3;
    switch condition
        case 'unexecuted'
            algo = option.algo;
        case 'unfinished'
            algo = @(x) load_opt(x);
        case  'finished'
            error('The number of samples is reach the terminated comdition~');
    end
    %=============================================================%
%     try
%         mainTest(option,algo)
%     catch ME
%         disp(ME.identifier);
%     end
        mainTest(option,algo)
