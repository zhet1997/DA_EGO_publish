function [y1,y2] = fixGroup(func_dim, subset)
players = cell(subset,1);%建立代表各个PLAYER的元胞数绿
%player变量划分
n = floor(func_dim/subset);
s = linspace(n,n,subset);
s = s + double((1:subset)<=func_dim - n*subset);
t = [0,cumsum(s)];
for ii=1:subset
    players{ii} = (1:s(ii)) + t(ii);%具体分配方法
end
y1 =  players';
if nargout>=1
    y2 = s;
end
end

