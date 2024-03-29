function [y] = PLAYER_DASR(option,opt)
if nargin==1
    opt = [];% ������ʼģ��
end
dim = size(option.variables,2);
option.max = ceil(option.max*dim);
option.sam.initial = option.sam.initial*dim;
borderOld = option.border;
ratio = 0.2;

if nargin==1
    opt = Iter_nash(option);% ������ʼģ��
end
%% ����
for iter=1:option.max%�����max��ָ����������
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
%% ����������
save([option.path,option.name(option.num,option.iter)]);
disp('alredy save');
end

