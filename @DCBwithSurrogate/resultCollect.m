function resultCollect(obj,result)
%1.sensitive
%2.R2
%3.anova
%4.improve
resultCollect@DivideConquerBase(obj,result);%collect the location & optimal
% get the startList
startList = 1:obj.subset;startList = startList(obj.player_start==1);

sensitiveList = cell(1,obj.subset);
R2List = zeros(1,obj.subset);
anovaList = cell(1,obj.subset);
improveList = zeros(1,obj.subset);
for ii = startList%要考虑是否有计算过
    if strcmp(obj.decomposeStr,'DynamicAgregate')||strcmp(obj.decomposeStr,'DynamicAgregate_DM')
        % extract the values needed
        sensitive = result{ii,1}.sensitive;
        R2 = result{ii,1}.R2;
        % save and collect these values
        sensitiveList{1,ii}=sensitive;
        R2List(1,ii) = R2;
    end
    
    if strcmp(obj.startStr,'ContributionBase')
        % extract the values needed
        anova = result{ii,1}.anova;
        improve = result{ii,1}.improve;
        % save and collect these values
        anovaList{1,ii}=anova;
        improveList(1,ii) = improve;
    end
    
end

if strcmp(obj.decomposeStr,'DynamicAgregate')||strcmp(obj.decomposeStr,'DynamicAgregate_DM')
    obj.update_interaction(R2List,sensitiveList);
end

if strcmp(obj.startStr,'ContributionBase')
    obj.update_contribution(anovaList,improveList);
end
end

