function iniElite(obj, option)
if isfield(option,'elite_ini')
    obj.elite.point = option.elite_ini;
else
    obj.elite.point = rand([1,obj.func_dim]);
end
obj.elite.value = feval(obj.Func,obj.elite.point);
obj.AddGlobal(obj.elite.point,obj.elite.value);
end

