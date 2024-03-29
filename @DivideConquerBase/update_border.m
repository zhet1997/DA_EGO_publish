function  update_border(obj)
for ii = 1:obj.subset
    temp = obj.elite_change;
    temp(:,obj.subsetPlayer{1,ii})=[];
    x = sqrt(temp*temp');
    ratio = trans(obj.func_dim,x);
    border = obj.border(obj.subsetPlayer{1,ii},:);

    mid = 0.5*(border(:,1)+border(:,2));
    rnd = 0.5*(border(:,2)-border(:,1));
    rnd = max(0.05, rnd);
    
    
    border(:,1) = max(mid-ratio*rnd,0);
    border(:,2) = min(mid+ratio*rnd,1);
    
    obj.border(obj.subsetPlayer{1,ii},:) = border;
end

if obj.DEBUG_MODE==1
    obj.RecordDebug(obj.border,'border');
    obj.RecordDebug(obj.interaction,'interaction');
end

SRnum = 600;
[pointsAll,valuesAll,num] = obj.allSample(); 
SRnum = min(SRnum,num);
[~,index] = sort(valuesAll,'ascend');
index = index(1:SRnum);
designSelect = pointsAll(index,:);
lowerNew = min(designSelect,[],1);
upperNew = max(designSelect,[],1);
obj.border_global = [lowerNew',upperNew'];

for ii = 1:obj.func_dim
obj.border_global(ii,1) = min(obj.border_global(ii,1),obj.border(ii,1));
obj.border_global(ii,2) = max(obj.border_global(ii,2),obj.border(ii,2));
end

end

function [y] = trans(dim,x)
maxRatio = 3;
y = 1+(maxRatio-1)*x/sqrt(dim);
end