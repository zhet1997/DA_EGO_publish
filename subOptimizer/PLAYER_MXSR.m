function [y] = PLAYER_MXSR(option,opt)
if nargin==1
    opt = [];% 建立初始模型
end
dim = size(option.variables,2);
option.max = option.max*dim;
option.sam.initial = option.sam.initial*dim;

if nargin==1
    option.model = 'HierarchicalKriging';
    opt = Iter_EGO(option);% 建立初始模型
end
%% 多保真迭代
ratio = 0.5;
iterBrk = option.max;
for iter=1:option.max%这里的max是指最大迭代次数
    if isfield(option,'save')
        save([option.path,option.name(option.num,option.iter)]);
    end
    x = opt.find_EI();
    opt.Update_HK(x,option.globalfunc);
    opt.record;
    if opt.termination('eimax')==1
        iterBrk = iter;
        break;
    end
end
%% 设置空间缩减
modHK = opt.Model;
opt.option.model = 'Kriging';
opt.Update([]);
modKR = opt.Model;
opt.border = spaceReduceMM(@(x)modHK.predict(x),@(x)modKR.predict(x),opt.border,ratio,'intersect');
%% 单保真迭代
for iter=iterBrk:option.max%这里的max是指最大迭代次数
    if isfield(option,'save')
        save([option.path,option.name(option.num,option.iter)]);
    end
    x = opt.find_EI();
    opt.Update(x);
    opt.record;
end

%% 设置空间缩减
modKR = opt.Model;
 opt.option.model = 'HierarchicalKriging';
opt.Update_HK([],option.globalfunc);
modHK = opt.Model;
opt.borderNewMM = spaceReduceMM(@(x)modHK.predict(x),@(x)modKR.predict(x),opt.border,ratio,'union');


%% 计算结果储存
opt.option.globalfunc = [];
opt.option.sam.func = [];
opt.Sample.func = [];
opt.Sample.option.func = [];
y = opt;
save([option.path,option.name(option.num,option.iter)]);
disp('alredy save');
end

