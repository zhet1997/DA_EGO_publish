function [y] = PLAYER_MF(option,opt)
if nargin==1
    opt = [];% 建立初始模型
end
dim = size(option.variables,2);
option.max = option.max*dim;
option.sam.initial = option.sam.initial*dim;

if nargin==1
    opt.option.model = 'HierarchicalKriging';
    opt = Iter_EGO(option);% 建立初始模型
end
%% 迭代
for iter=1:option.max%这里的max是指最大迭代次数
    if isfield(option,'save')
        save([option.path,option.name(option.num,option.iter)]);
    end
    x = opt.find_EI();
    opt.Update_HK(x,option.globalfunc);
    opt.record;
    if opt.termination('eimax')==1
        break;
    end
end
y = opt;
%% 计算结果储存
save([option.path,option.name(option.num,option.iter)]);
disp('alredy save');
end

