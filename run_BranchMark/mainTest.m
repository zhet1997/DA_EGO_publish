%2021-7-7
%简陋并行+多次重复版的主函数
function mainTest(option,algo)
warning('off');
%make sure there is no parpool is running before the optimization begain.
MyPar = gcp('nocreate');
if ~isempty(MyPar)
    delete(MyPar);
end

opt = algo(option);
if isfield(option,'coreNum')
opt.coreNum = option.coreNum;  
else
opt.coreNum = 10;
end

for i=1:1000
    opt.Update();
    dl = load(opt.record);
    if sum(dl.record.cost)>=3500
        disp('The number of samples is reach the terminated comdition~')
        save([option.pathRoot,option.tree.caseLocation,'Result',option.tree.recordName],'opt');
        break;
    else
        disp(['The number of samples has been added is ',num2str(sum(dl.record.cost))]);
        save([option.pathRoot,option.tree.caseLocation,'Result',option.tree.recordName],'opt');
    end
end

end




