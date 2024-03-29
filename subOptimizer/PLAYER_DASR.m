function [y] = PLAYER_DASR(option,opt)
if nargin==1
    opt = [];% 建立初始模型
end
dim = size(option.variables,2);
option.max = ceil(option.max*dim);
option.sam.initial = option.sam.initial*dim;
borderOld = option.border;
ratio = 0.2;

if nargin==1
    opt = Iter_nash(option);% 建立初始模型
end
%% 迭代
for iter=1:option.max%这里的max是指最大迭代次数
    if isfield(option,'save')
    save([option.path,option.name(option.num,option.iter)]);
    end
    x = opt.find_EI(borderOld);
    opt.Update(x);
    opt.record;
    if opt.termination('eimax')==1
        break;
    end
end
clear('x','iter');
y = opt.best;
%get the new border
y.borderNew = spaceReduce(@(x)opt.Model.predict(x),borderOld,ratio);
% LooCV and interaction
list = LooCV(opt.Model);
y.R2 = list.R2;
y.sensitive =iteraction(opt.Model,y.borderNew);
%% 计算结果储存
save([option.path,option.name(option.num,option.iter)]);
disp('alredy save');
end

