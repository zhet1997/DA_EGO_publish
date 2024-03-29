function [y] = PLAYER_FIDA(option)
dim = size(option.variables,2);
option.max = option.max*dim;
option.sam.initial = option.sam.initial*dim;
opt = Iter_nash(option);% 建立初始模型
%% 迭代
for iter=1:option.max%这里的max是指最大迭代次数
    x = opt.find_EI();
    opt.Update(x);
    opt.record;
    if opt.termination('eimax')==1
        break;
    end
end
clear('x','iter');
y = opt.best;
% LooCV and interaction
list = LooCV(opt.Model);
y.R2 = list.R2;
boundary = repmat([0.1,0.9],[dim,1]);
y.sensitive =iteraction(opt.Model,boundary);
if dim>1
ano= ANOVA(opt.Model);
y.contribution = ano.contribution();
else
y.contribution = [];   
end
%% 计算结果储存
save([option.path,option.name(option.num,option.iter)]);
disp('alredy save');
end

