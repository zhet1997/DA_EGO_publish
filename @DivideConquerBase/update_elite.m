function update_elite(obj)
    [pointsAll,valuesAll,~] = obj.allSample();       
    obj.elite.value = min(valuesAll);%最小值样本
    index = find(valuesAll==obj.elite.value);
    new = pointsAll(index(1),:);%当前最优样本坐标
    if isfield(obj.elite,'point')
    obj.elite_change = obj.elite.point - new;
    end
    obj.elite.point = new;
end

