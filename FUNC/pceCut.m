%2021-9-1oo
%对全局模型进行一个切片
function [y] = pceCut(pceModel,elite_point,variable,x)%这里的variable是标出变量位置的参数，x为输入的值
points = repmat(elite_point,[size(x,1),1]);
points(:,variable) = x;%带入数值
model = @(x) uq_evalModel(pceModel,x);
y = model(points);
end

