function iniContr(obj)
temp1 = obj.sensitive.Total;
minNot0 = min(temp1(temp1>0));
[~,temp2,~] = obj.allSample();
temp2 = mean(temp2) - min(temp2);
if isempty(minNot0)
    temp1 = temp1+1;
else
    temp1(~temp1) = minNot0;
end
obj.contribution = temp2*temp1'/sum(temp1);
end
