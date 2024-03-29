function update_XGB(obj)
[pointsAll,valuesAll,~] = obj.allSample();
XGBtrain(obj.pathXGB,[pointsAll,valuesAll])
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

