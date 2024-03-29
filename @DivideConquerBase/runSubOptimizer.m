function [y] = runSubOptimizer(obj,startList)
if nargin==1
    startList = 1:obj.subset;
end
%% the setting of save mode
if obj.SAVE_MODE ==1
    subOptimizer = [obj.subOptimizer,'_save'];
    %load the old setting if exist and use it.
    savePath = [obj.option.pathRoot,...
        obj.option.tree.caseLocation,...
        'Save',obj.option.tree.recordName];
    if exist(savePath,'file')
        ld = load(savePath);%load
        startList = ld.startList;%use
        obj = ld.obj;
    end
    %save the setting is used now.
    save(savePath,'obj','startList');
else
    subOptimizer = obj.subOptimizer;
end

%% start
player_option = obj.player_option(:,startList);
startNum = size(player_option,2);
result = cell(startNum,1);

if obj.coreNum == 1 % do not runing parallel
    for ii = 1:startNum
        result{ii,1} = feval(subOptimizer,player_option{ii});%这里是步入子优化的关键句子
        player_option = obj.update_players_inOpt(result,ii,startList);
    end
else
    coreNum = obj.coreNum;
    coreNum = min(coreNum,startNum);
    parList = runInTimes(startNum,coreNum);
    for parTime = 1:size(parList,1)
        if isempty(gcp('nocreate'))
            MyPar = parpool(min(coreNum,length(parList{parTime,1})));
        end
        
        parfor ii = parList{parTime,1}
            result{ii,1} = feval(subOptimizer,player_option{ii});%这里是步入子优化的关键句子
        end
        delete(MyPar);
        player_option = obj.update_players_inOpt(result,parList{parTime,1},startList);
        if obj.SAVE_MODE==1
            save(savePath,'obj','startList');
        end
    end
end
y = result;
if obj.SAVE_MODE==1
    delete(savePath);
end
end




function [y] = runInTimes(subSet,coreNum)
times = ceil(subSet/coreNum);
num = ceil(subSet/times);
nums = [linspace(num,num,times-1),subSet-(times-1)*num];
t = [0,cumsum(nums)];
y = cell(times,1);
for ii = 1:times
    y{ii,1} = t(ii)+1:t(ii+1);
end
end