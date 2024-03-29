function update_localPoints(obj)
%在迭代次数>2时后加载子优化的数据
if isempty(obj.pointsLocal)
    obj.pointsLocal = cell(obj.iter,obj.subsetMax);
    obj.valuesLocal = cell(obj.iter,obj.subsetMax );
end

jj = obj.iter; %把新一轮的子优化样本加入到pointsLocal中
pointsInIter = cell(1,obj.subset);
valuesInIter = cell(1,obj.subset);
for ii = 1:obj.subset
    option = obj.player_option{1,ii};
    if option.start==1
    subopt = load([obj.option.pathRoot,obj.option.tree.caseLocation,option.name(option.num,jj)]);
    points = repmat(obj.elite.point,size(subopt.opt.Sample.samples_h,1),1);
    points(:,subopt.opt.option.variables)=subopt.opt.Sample.samples_h(:,1:end-1);
    values = subopt.opt.Sample.samples_h(:,end);%把样本值加入
    
    pointsInIter{1, ii} = points;%这里是一次迭代全部的数据
    valuesInIter{1, ii} = values;
    end
end
obj.valuesLocal(jj,1:obj.subset) = valuesInIter;
obj.pointsLocal(jj,1:obj.subset) = pointsInIter;
end

