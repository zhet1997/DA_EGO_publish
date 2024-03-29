function [y] = findPoint(obj)
dim = obj.dimension;
x =0:obj.dense*10:1;
curves = obj.senCurves();
point = zeros(1,dim);
for ii = 1:dim
    temp = min(curves(ii,:));
    index = find(curves(ii,:)==temp);
    point(:,ii) = x(:,index(1));
end
    y = point;
end

