function [y] = senCurves(obj)
x =0:obj.dense:1;
num = size(x,2);
dim = obj.dimension;
xc = ones(dim*2,num);
for ii = 1:dim
    xc(2*ii-1,:)=xc(2*ii-1,:)*ii;
end
for ii = 1:dim
    xc(2*ii,:)=x;
end
xcc = mat2cell(xc,linspace(2,2,dim),linspace(1,1,num));
y =cellfun(@obj.get_miu_sing,xcc);
end

