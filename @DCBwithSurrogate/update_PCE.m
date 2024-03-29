function update_PCE(obj)
[pointsAll,valuesAll,num] = obj.allSample();
if strcmp(obj.borderStr,'Reduce')
    index1 = repmat(obj.border_global(:,1)',[num,1])<pointsAll;
    index2 = repmat(obj.border_global(:,2)',[num,1])>pointsAll;
    index = prod([index1,index2],2);
    for ii =num:-1:1
        if ~index(ii)
            pointsAll(ii,:) = [];
            valuesAll(ii,:) = [];
        end
    end
    [obj.modGlobal,obj.sensitive] = subsetOfPCE(pointsAll,valuesAll,obj.border_global);
else
    [obj.modGlobal,obj.sensitive] = subsetOfPCE(pointsAll,valuesAll);
end

if obj.iter==1&&strcmp(obj.startStr,'ContributionBase')
    obj.iniContr();
end
% [~,y_min_co] = obj.findYminGlobal(obj.modGlobal,obj.func_dim,20,obj.y_location);
% obj.AddGlobal(y_min_co);
end

function [y1,y2] = findYminGlobal(mod,dim,MaxT,seed)
model = @(x) uq_evalModel(mod,x);
design = lhsdesign(1000,dim);
if nargin>2
    design(size(seed,1),:) = seed;
end

[y_min_res, y_min_location] = GA_pce(model,design,MaxT);
y1 = y_min_res;
y2 = y_min_location;
end

