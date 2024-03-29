function [taskCurrent,caseNum] = readList(pathRoot,caseMax)
if length(caseMax)==1
  caseRound = 1:caseMax;
else
  caseRound = caseMax; 
end

if exist([pathRoot,'optionList.txt'],'file')
    optionList = importdata([pathRoot,'optionList.txt']);
else
    error('optionList file is not found! CHECK PLEASE!')
end

if isempty(optionList)%当列表空时
    optionList = importdata([pathRoot,'optionList_ini.txt']);%重写列表
    wdat(optionList(1:end,:),[pathRoot,'optionList.txt']);
    caseNum = importdata([pathRoot,'caseNum.txt']);
    caseNum = caseNum(1);
    wdat(caseNum+1,[pathRoot,'caseNum.txt']);
    caseNum = importdata([pathRoot,'caseNum.txt']);
    caseNum = caseNum(1);
else
    caseNum = importdata([pathRoot,'caseNum.txt']);
    caseNum = caseNum(1);
end

caseNum = mod(caseNum,length(caseRound));
if caseNum==0
        caseNum = length(caseRound);
end
caseNum = caseRound(caseNum);

taskCurrent = optionList{1,:};%读取第一个名字
wdat(optionList(2:end,:),[pathRoot,'optionList.txt']);%去掉第一个名字之后重新保存
end

