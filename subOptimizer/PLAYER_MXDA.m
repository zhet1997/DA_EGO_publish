%2021-1-5
%和原本PLAYER的不同在于这里的player直接使用全局模型的切片来作为低精度
function [y] = PLAYER_MXDA(option)%这里输入的option其实是player
dim = size(option.variables,2);
option.max = option.max*dim;
option.sam.initial = option.sam.initial*dim;
opt = Iter_nash(option);% 建立初始模型%初始模型是kriging模型


%% 初始加点
%使用HK模型
opt.option.model = 'HierarchicalKriging';
opt.Update_HK([],option.globalfunc);

%% 迭代
for iter=1:floor(option.max*0.33)%这里的max是指最大迭代次数
    x = opt.find_EI(); %这里EI的搜索成本会很高，因为每次取值要从globalMod去加一个点
    opt.Update_HK(x,option.globalfunc);
    opt.record;
    if opt.termination('eimax')==1
        break;
    end
    
end

y = opt.best;
y_min_co = y.point;
wid = 0.2;
temp1 = max(y_min_co' - wid,0);
temp2 = min(y_min_co' + wid,1);
EIborder = [temp1,temp2];

opt.option.model = 'Kriging';
for iter=1:floor(option.max*0.33)%这里的max是指最大迭代次数
    x = opt.find_EI(EIborder); %这里EI的搜索成本会很高，因为每次取值要从globalMod去加一个点
    opt.Update(x);
    opt.record;
    if opt.termination('eimax')==1
        break;
    end
    
end

y = opt.best;
% LooCV and interaction
list = LooCV(opt.Model);
y.R2 = list.R2;
y.sensitive =iteraction(opt.Model,EIborder);

if y.point==option.sam.elite
    opt.option.model = 'Kriging';
    for iter=1:floor(option.max*0.33)%这里的max是指最大迭代次数
        x = opt.find_EI(EIborder); %这里EI的搜索成本会很高，因为每次取值要从globalMod去加一个点
        opt.Update(x);
        opt.record;
    end
    y = opt.best;
    % LooCV and interaction
    list = LooCV(opt.Model);
    y.R2 = list.R2;
    y.sensitive =iteraction(opt.Model,EIborder);
end

clear('x','iter');
%% 计算结果储存
opt.option.globalfunc = [];
opt.option.sam.func = [];
opt.Sample.func = [];
opt.Sample.option.func = [];
opt.Model = opt.Model.hyperparameters;
save([option.path,option.name(option.num,option.iter)],'opt');
%option.name是固定形式的匿名函数，这里只需要把序号和迭代次数填入即可
disp('alredy save');
end