function update_decompose(obj)
if strcmp(obj.decomposeStr,'DynamicAgregate')||strcmp(obj.decomposeStr,'DynamicAgregate_DM')
    if strcmp(obj.borderStr,'Reduce')
        [obj.subsetPlayer,NomList] = feval(obj.decomposeStr, obj.func_dim, obj.interaction, obj.sensitive);
        obj.border(NomList,:) = repmat([0,1],[length(NomList),1]);
    else
        obj.subsetPlayer = feval(obj.decomposeStr, obj.func_dim, obj.interaction, obj.sensitive);
    end
    obj.subset = size(obj.subsetPlayer,2);
else
    update_decompose@DivideConquerBase(obj);
end



end

