%multi-model
function [y] = spaceReduceMM(mod1,mod2,border,ratio,set)
lower = border(:,1)';
upper = border(:,2)';
dim = size(border,1);
design = lhsdesign(dim*5000,dim);
design = design.*(upper-lower)+lower;
predict1 = mod1(design);
predict2 = mod2(design);
[~,index1] = sort(predict1,'ascend');
index1 = index1(1:floor(dim*5000*ratio));
[~,index2] = sort(predict2,'ascend');
index2 = index2(1:floor(dim*5000*ratio));
if strcmp(set,'intersect')
index = intersect(index1,index2);
elseif strcmp(set,'union')
index = union(index1,index2);
end

designSelect = design(index,:);
lowerNew = min(designSelect,[],1);
upperNew = max(designSelect,[],1);
borderNew = [lowerNew',upperNew'];
y = borderNew;
end

