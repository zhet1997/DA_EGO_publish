%本函数中的A为了简化起见是和文档中的A不一致的。
%文档中的A对应这里的V
function [y] = get_A(obj,label_l,value_l,theta,points)%序号放在label里%都是行向量
%l_label确定变量的维度

%theta超参数
%points样本坐标
if nargin==3
   theta = obj.theta;
   points = obj.points;
end

%ug-xg
if isempty(value_l)
    y=ones(size(points,1),1);%考虑计算整体均值的情况
else
    temp = ones(size(points,1),obj.l).*value_l-points(:,label_l);%全部做差
    temp = temp.*temp;%平方
    temp = temp.*theta(:,label_l);%乘以超参数
    y = exp(-sum(temp,2));%指数幂
end
end
