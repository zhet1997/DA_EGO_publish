function update_decompose(obj)
decomposeStr = obj.decomposeStr;
obj.subsetPlayer = feval(decomposeStr, obj.func_dim, obj.subset);
end

