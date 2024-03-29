function [y] = XGBpredict_old(pathXGB,preSam)
t = 1;
val = NaN;
while t<30 && sum(isnan(val)) 
    val =  XGBpredict_sin(pathXGB,preSam); 
    if isnan(val)
        pause(rand()*10);
    end
end
y = val;
end

function [y] = XGBpredict_sin(pathXGB,preSam)
pathTest = [pathXGB,'test.txt'];
pathRst = [pathXGB,'result.txt'];
wdat(preSam,pathTest);
[res, status] =python([pathXGB,'predict_xgb.py']);
Rst = importdata(pathRst);

if sum(Rst(:,1:end-1)-preSam,'all')<1e-4*numel(preSam)
y = Rst(:,end);
else
y = NaN;
disp("predict of the XGB model is failed in this time.");
disp(num2str(sum(Rst(:,1:end-1)-preSam,'all')/numel(preSam)));
end

end
