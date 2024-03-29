function drawCurves(obj)
dim = obj.dimension;
if isempty(obj.colors)% if the pie picture has set the colors of variables, make it same.
    obj.colors = obj.linspecer(dim);
end
if isempty(obj.curves)
	curves = obj.senCurves();
	obj.curves = curves;
else
	curves = obj.curves;
end

figure();
for ii = 1:dim
    plot(0:obj.dense:1,curves(ii,:),'color',obj.colors(ii,:),'linewidth',2);hold on;
end
index = (1:dim)';
input1 = mat2cell(index,index*0+1);
labels = cellfun(@obj.makeLabel,input1,'UniformOutput',false);
if dim<10
    h = legend(labels);
else
    h = legend(labels,'NumColumns',2);
end
set(gca,'FontSize',11);
set(h,'box','off');
end

