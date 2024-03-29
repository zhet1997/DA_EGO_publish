function [y] = EGO_test(number,caseNum)
warning('off');
%2021-10-13
pathRoot = 'D:\WQN\DATA\EGO_test\';
% number = 1;
% caseNum = 1;
%set parameter
option.model = 'Kriging';
option.EI = -1;
option.max =  10000;
sam.initial =  0;
sam.elite = zeros([1,30]);

%set target function
func =  @(x) Testmodel_player(x,number);
sam.func = func;

%set initial sampling
data = importdata(['D:\WQN\DATA\Sam\IniSam',num2str(caseNum),'.dat']);
sample_x = data(1:50,:);
sam.initialSampling = sample_x;

option.sam = sam;

opt = Iter_nash(option);% 建立初始模型%初始模型是kriging模型
save([pathRoot,'EGOresult_',num2str(number),'_',num2str(caseNum),'.mat'],'opt');   
%% 迭代
for iter=1:1000
	disp(['the iter number is ',num2str(iter)]);
    x = opt.find_EI(); %这里EI的搜索成本会很高，因为每次取值要从globalMod去加一个点
    opt.Update(x);
    opt.record;
    if opt.termination('eimax')==1
        break;
    end   
    save([pathRoot,'EGOresult_',num2str(number),'_',num2str(caseNum),'.mat'],'opt');   
end
y = opt.y_min;
end

