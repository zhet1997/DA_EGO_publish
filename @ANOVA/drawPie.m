function drawPie(obj)
%numMax = 20;
% get rid of tiny slice
sliceMin = 0.01;
if isempty(obj.sensitive)
sensitive = obj.contribution();
obj.sensitive = sensitive;
else
sensitive = obj.sensitive;
end
con1 = [sensitive.AllOrders{1,1}/sensitive.TotalVariance,sensitive.VarIdx{1,1}];
con2 = [sensitive.AllOrders{1,2}/sensitive.TotalVariance,sensitive.VarIdx{1,2}];
con1(con1(:,1)<sliceMin,:) = [];
con2(con2(:,1)<sliceMin,:) = [];
%make the labels 
input1 = mat2cell(con1(:,2),con1(:,1)*0+1);
labels = cellfun(@obj.makeLabel,input1,'UniformOutput',false);
if ~isempty(con2)
input2 = mat2cell(con2(:,2:3),con2(:,1)*0+1);
labels2 = cellfun(@obj.makeLabel,input2,'UniformOutput',false);
labels = [labels;labels2];
end
% recalculate all percentage
sumNew = sum(con1(:,1)) + sum(con2(:,1));
con = con1(:,1)/sumNew;
num = 0;
if ~isempty(con2)
    con2 = con2(:,1)/sumNew;
    num = size(con2,1);
    con = [con;con2];
end
figure();
pie(con,labels);
num = obj.dimension + num;
obj.colors =  obj.linspecer(num);
color1 = obj.colors(con1(:,2),:);
color = [color1;obj.colors(obj.dimension+1:end,:)];
colormap(color);
end


