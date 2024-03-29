function update_start(obj)
if isempty(obj.startStr)
    update_start@DivideConquerBase(obj);
elseif strcmp(obj.startStr,'ContributionBase')
    obj.player_start = CBstart(obj.subsetPlayer, obj.contribution);
else
    error('illeagle startStr setting~');
end
end

