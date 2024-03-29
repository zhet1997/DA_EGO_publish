function resultCollect(obj,result)
%1.best_p
%2.best_v
%3.borderNew

% get the startList
startList = 1:obj.subset;startList = startList(obj.player_start==1);
poiList = obj.elite.point;%initialed here if some subplayers are not optimized.
valList = zeros(1,obj.subset);
borderList = zeros(obj.func_dim,2);

for ii = startList%要考虑是否有计算过
    index = obj.player_option{ii}.variables;
    % extract the values needed
    best = result{ii,1}.best;
    poi = best.point;
    val = best.value;    
    % collect these values
    poiList(1,index)=poi;
    valList(1,ii) = val;

    if strcmp(obj.borderStr,'Reduce')
        if strcmp(obj.subOptimizer,'PLAYER_MXSR')
            borderNew = result{ii,1}.borderNewMM;
            borderList(index,:)=borderNew;
        else
            borderNew = result{ii,1}.borderNew;
            borderList(index,:)=borderNew;
        end 
    end
    
end

%save these result
obj.player_location = poiList;
obj.player_result = valList;
if strcmp(obj.borderStr,'Reduce')
    obj.border = borderList;
end
end

