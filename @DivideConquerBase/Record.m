function Record(obj)%playerResult
if obj.iter==1   
    [~,~,record.cost(obj.iter,:)] = obj.allSample();
    record.player_v{obj.iter,:} = zeros(1,obj.subset)+obj.elite.value;
else
    ld = load(obj.record);
    record = ld.record;
    [~,~,costAll] = obj.allSample();
    
    costIncrease =  costAll - sum(record.cost(1:obj.iter-1));
    record.cost(obj.iter,:) = costIncrease;
    record.player_v{obj.iter,:} = obj.player_result;
end
record.elite_p(obj.iter,:) = obj.elite.point;
record.elite_v(obj.iter,:) = obj.elite.value;
record.subsetPlayer{obj.iter,:} = obj.subsetPlayer;
%record.modGlobal{obj.iter,1} = obj.modGlobal;

save(obj.record,'record');
end