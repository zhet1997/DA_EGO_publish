function  update_interaction(obj,R2List,sensitiveBox)
varIdxAll = obj.get_idx(obj.func_dim);
Senbox = varIdxAll(:,1)*0-1;
for ii = 1:obj.subset
    variables = obj.player_option{ii}.variables;
    if R2List(1,ii)>0.8 && size(variables,2)>1
        sensitive = sensitiveBox{1,ii};
        num = size(variables,2);
        index1 =  obj.get_idx(num);
        index2 =  obj.get_idx(variables);
        location = findInAll(index2, varIdxAll);     
        for jj = 1:size(index1,1)
            Inter = obj.interaction(location(jj),:);
            val = abs(sensitive(index1(jj,2),index1(jj,1)));
            Senbox(location(jj),1) = val;
            if  Inter==0&& val>0.3
                obj.interaction(location(jj),:)=1;
            elseif Inter==1&& val<0.005
                obj.interaction(location(jj),:)=0;
            end
            
        end
    end
end

if obj.DEBUG_MODE==1
    obj.RecordDebug(Senbox,'sensitive');
end
end

function [y] = findInAll(x, varIdxAll)
y = x(:,1)*0;
for ii = 1:size(x,1)
    temp1 = find(varIdxAll(:,1)==x(ii,1));
    temp2 = find(varIdxAll(:,2)==x(ii,2));
    y(ii,1) = intersect(temp1,temp2);
end
end
