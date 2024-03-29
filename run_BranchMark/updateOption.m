function [y] = updateOption(pathRoot,taskCurrent,caseNum,pathSam)
load([pathRoot,taskCurrent],'option');%读入option
%修改路径
option.pathRoot = pathRoot;
%修改文件名
if ~isempty(caseNum)
option.tree.caseLocation = [option.tree.caseLocation(1:end-1),'case',num2str(caseNum),'/'];
end
%载入初始样本
if ~isempty(pathSam)&&~isempty(caseNum)
IniSam = importdata([pathSam,'IniSam_',num2str(option.func_dim),'D_',num2str(caseNum),'.dat']);
option.IniSam = IniSam;
option.IniVal = [];
else
option.IniSam = [];
option.IniVal = [];
end

y = option;
end

