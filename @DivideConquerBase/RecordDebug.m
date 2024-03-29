function RecordDebug(obj,data,type)
%record how the variables aggregate and decompose
if ~isfield(obj.record_Debug,type)
    eval(['obj.record_Debug.',type, '= cell(1,1);']);
end
    %record the interaction value in every cycle
switch type
    case 'interaction'
        obj.record_Debug.interaction{obj.iter,1} = data;
    case 'sensitive'
        obj.record_Debug.sensitive{obj.iter,1} = data;
    case 'border'
        obj.record_Debug.border{obj.iter,1} = data;
end
%record the decomposition in every cycle
end

