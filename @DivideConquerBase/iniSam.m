function iniSam(obj,option)
if ~isfield(option,'IniSam')
    option.IniSam = [];
end
if ~isfield(option,'IniVal')
    option.IniVal = [];
end

if ~isempty(option.IniSam)
    if ~isempty(option.IniVal)
        obj.AddGlobal(option.IniSam,option.IniVal);
    else
        obj.AddGlobal(option.IniSam);
    end
    obj.update_elite();
else
    obj.iniElite(option);
end

end

