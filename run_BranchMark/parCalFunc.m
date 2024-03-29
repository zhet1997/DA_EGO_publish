%2022-1-11
function parCalFunc(pathRoot,pathSam,caseMax)
warning('off');
while true
    [taskCurrent,caseNum] = readList(pathRoot,caseMax) ;
    option = updateOption(pathRoot,taskCurrent,caseNum,pathSam);
    condition =  checkCondition(option);
    switch condition
        case 'unexecuted'
            algo = @(x) EGO_global_local(x);         
        case 'unfinished'
            algo = @(x) load_opt(x);     
        case  'finished'
            disp('The number of samples is reach the terminated comdition~');
    end
    %=============================================================%
    try
        mainTest(option,algo)
    catch ME
        disp(ME.identifier);
    end
    
end