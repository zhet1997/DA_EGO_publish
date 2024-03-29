function [y] = contribution(obj)
if obj.dimension>1
% 1-D contribution
x1 = 1:obj.dimension;
x1 = mat2cell(x1',linspace(1,1,obj.dimension),1);
y1 =cellfun(@obj.get_sigma_sing,x1);
% 2-D contribution 
distIdx = obj.get_idx(obj.dimension);
x2 = mat2cell(distIdx,linspace(1,1,size(distIdx,1)),2);
y2 =cellfun(@obj.get_sigma_sing,x2);
y2 = y2 - y1(distIdx(:,1),:) - y1(distIdx(:,2),:);
y.AllOrders{1,2} = y2;
y.VarIdx{1,2} = distIdx;
y.AllOrders{1,1} = y1;
y.VarIdx{1,1} = (1:obj.dimension)';
else
y.AllOrders{1,2} = 0;
y.VarIdx{1,2} = 1;
y.AllOrders{1,1} = 1;
y.VarIdx{1,1} = (1:obj.dimension)';  
end
y.TotalVariance = obj.get_sigma_sing(1:obj.dimension);
end

