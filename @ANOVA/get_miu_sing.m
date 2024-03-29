function [y] = get_miu_sing(obj,all)
%all是一个2*m的矩阵
%第一行是确定的参数的位置；
%第二行是确定的参数的取值；
if isempty(all)%求全局均值的情况
    label_l = [];
    value_l = [];
else
    label_l = all(1,:);
    value_l = all(2,:);
end
obj.l = size(value_l,2);
obj.p = obj.dimension-obj.l;
label_p = obj.l2p(label_l);
%A的计算
A = obj.get_A(label_l,value_l);
%B的计算
B = obj.get_B(label_p);
%V的计算
V = obj.R\(obj.values-ones(obj.num,1)*obj.alpha);
%汇总
s = V.*A.*B;
y = obj.alpha + sum(s(:));
end