function Update(obj)%one cycle
%% update parameters
obj.iter = obj.iter + 1;

%% update decomposition strategy
obj.update_decompose();
if strcmp(obj.borderStr,'Reduce')&&obj.iter>=3
    obj.update_border();
end
obj.update_start();
%% update the sub-optimizer parameter
obj.update_players();

%% running the sub-optimizer
result = obj.runSubOptimizer();

%% deal with the result
obj.resultCollect(result);
obj.AddGlobal(obj.player_location);
obj.update_localPoints();
obj.update_elite();

%% Record this cycle
obj.Record();
end
