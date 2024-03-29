function [y] = XGBpredict(pathXGB,preSam)
t = 1;
val = NaN;
while t<30 && sum(isnan(val)) 
    %新建时间戳文件
    dirname = [datestr(datetime('now')),num2str(randi([0,9])),'\'];
    dirname = join(dirname,'');
    dirname = strrep(dirname,' ','');
    dirname = strrep(dirname,':','');
    cd(pathXGB);
    status1= mkdir(dirname);
%     dirname = [pathXGB,'\',dirname];
    status2 = copyfile(join([pathXGB,'\xgb_model.json']),join([pathXGB,'\',dirname,'\xgb_model.json']));
    status3 = copyfile(join([pathXGB,'\predict_xgb.py']),join([pathXGB,'\',dirname,'\predict_xgb.py'])); 
    status4 = copyfile(join([pathXGB,'\test.txt']),join([pathXGB,'\',dirname,'\test.txt']));  
    val =  XGBpredict_sin([pathXGB,'\',dirname],preSam); 
    try 
    rmdir(dirname,'s');
    catch   
    end
    if isnan(val)
        pause(rand()*10);
    end
end
y = val;
end

function [y] = XGBpredict_sin(pathXGB,preSam)
pathTest = [pathXGB,'\test.txt'];
pathRst = [pathXGB,'\result.txt'];
wdat(preSam,pathTest);
[res, status] =python([pathXGB,'predict_xgb.py']);
Rst = importdata(pathRst);

if sum(size(Rst(:,1:end-1))~=size(preSam))
    disp("predict of the XGB model is failed in this time.");
    y = NaN;
else
    if sum(sum(abs(Rst(:,1:end-1)-preSam)))<1e-5*numel(preSam)
        y = Rst(:,end);
    else
        y = NaN;
        disp("predict of the XGB model is failed in this time.");
        disp(num2str(sum(sum(abs(Rst(:,1:end-1)-preSam)))/numel(preSam)));
    end
end

end
