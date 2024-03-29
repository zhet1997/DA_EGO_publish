%计算部分或全部方差的函数
function [y] = get_sigma_sing(obj,label_l)
%采用了和miu一致的输入格式
if isempty(label_l)%求全局均值的情况
    label_l = [];
end
obj.l = size(label_l,2);
obj.p = obj.dimension-obj.l;
label_p = obj.l2p(label_l);%从label_l到label_p
distIdx = obj.get_idx(obj.num);
%A的计算
[Aii,Aij] = obj.get_B(label_l);
%B的计算
%[Bii,Bij] = obj.get_B(label_p);
B = obj.get_B(label_p);
Bii = B.*B;%这里已经平方了
Bij = B(distIdx(:,1)).*B(distIdx(:,2));
%V的计算
V = obj.R\(obj.values-ones(obj.num,1)*obj.alpha);
Vii = V.*V;%这里已经平方了
Vij = V(distIdx(:,1)).*V(distIdx(:,2));
%汇总
a0 = obj.get_miu_sing([]);%计算a0的值
temp1 = Vii.*Aii.*Bii;
temp1 = sum(temp1(:));
temp2 = Vij.*Aij.*Bij;
temp2 = sum(temp2(:))*2;
y = -(a0-obj.alpha)^2 + temp1 + temp2;%关键公式
end

