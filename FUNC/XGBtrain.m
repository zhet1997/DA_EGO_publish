%2023-3-16
function [t] = XGBtrain(pathXGB,trainSam)
X = trainSam(:,1:end-1);
y = trainSam(:,end);

pathSam = [pathXGB,'samples.txt'];
pathVal = [pathXGB,'values.txt'];

wdat(X,pathSam);
wdat(y,pathVal);
[res, status] =python([pathXGB,'train_xgb.py']);

t = 1;
end

