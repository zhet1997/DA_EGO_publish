function [y] = spaceReduce(mod,border,ratio)
lower = border(:,1)';
upper = border(:,2)';
dim = size(border,1);
design = lhsdesign(dim*1000,dim);
design = design.*(upper-lower)+lower;
predict = mod(design);

[~,index] = sort(predict,'ascend');
index = index(1:floor(dim*1000*ratio));
designSelect = design(index,:);
lowerNew = min(designSelect,[],1);
upperNew = max(designSelect,[],1);
borderNew = [lowerNew',upperNew'];

y = borderNew;
end

