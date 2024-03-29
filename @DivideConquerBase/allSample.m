%2021-4-13
function [y1,y2,num] = allSample(obj)%output the point and value list after unique and the all number
%将pointsLocal和pointsGlobal里的所有样本合并

pointsLocal = [];
valuesLocal = [];

if ~isempty(obj.pointsLocal)
    for ii = 1:obj.subsetMax
        pointsLocal = [pointsLocal; cell2mat(obj.pointsLocal(:,ii))];
        valuesLocal = [valuesLocal; cell2mat(obj.valuesLocal(:,ii))];
    end
end
    pointsBox = [cell2mat(obj.pointsGlobal);pointsLocal];
    valuesBox = [cell2mat(obj.valuesGlobal);valuesLocal];   


[C, ia, ~] = unique(pointsBox,'rows');
pointsAll = C;
valuesAll =valuesBox(ia,:);

num = size(valuesAll,1);
y1 = pointsAll;
y2 = valuesAll;