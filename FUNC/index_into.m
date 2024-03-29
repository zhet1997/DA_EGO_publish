%2019-12-7
%本程序为测试的模板程序，适用于不同算法与不同测试函数搭配的情况
%包含如下部分：
%1.测试函数选取
%2.优化算法选取
%3.算法参数给定
%4.优化过程与结果储存
function [y] = index_into(put,pathRoot,Name)
%对参数进行设置
option = struct();
%对参数进行设置
option.pathRoot = pathRoot;%计算结果储存路径
option.date = datestr(datetime('today'),'yyyy-mm-dd');
%====================================
%nash参数
option.func_name = put{1};%测试函数名称
option.func_dim = put{2};%测试函数维度
option.subset = put{3};%输入player个数
%====================================
%player参数
%停止参数%迭代方法
player.model = 'Kriging';%'HierarchicalKriging';
player.EI = put{4};%比较关键的数据
player.max =  put{5};
%====================================
%sample参数
%初始参数
sam.initial =  put{6};%子优化初始加点数
%feasible参数

%总结部分
%=========================
player.sam = sam;
players = subPlayerOption(option, player);
option.player = player;
option.players = players;
option.Name = nameForOption(option,Name);
option.tree = setFileTree(option,Name);

y = option;
%==========================
end

function [y] = subPlayerOption(option, player)
players = cell(option.subset,1);%建立代表各个PLAYER的元胞数组
%player变量划分
n = floor(option.func_dim/option.subset);
s = linspace(n,n,option.subset);
s = s + double((1:option.subset)<=option.func_dim - n*option.subset);
t = [0,cumsum(s)];
for ii=1:option.subset
    players{ii} = player;%将共同属性输入到每个palyer中
    players{ii}.variables = (1:s(ii)) + t(ii);%具体分配方法
    players{ii}.num = ii;%设置player编号
    players{ii}.sam.num = ii;
    %上述信息在整个nash-ego优化中不发生变化
end
y =  players;
end

function [y] = setFileTree(option,Name)
tree.caseLocation = [nameForCase(option,Name),'\'];%相对位置
%tree.playerLocation =  @(subset)[tree.caseLocation, '\','PLAYER',num2str(subset),'\'];
tree.recordName =  nameForRecord(option);
tree.playerName = @(num,iter)['num',num2str(num),'%'...%player的编号
    ,'iter',num2str(iter),'.mat'];

y = tree;
end

function [file_name] = nameForOption(option,Name)
file_name = [Name,'%'...
    ,depend(option.func_name) ,'&'...
    ,num2str(option.func_dim),'&'...
    ,num2str(option.subset),'.mat'];
end

function [dir_name] = nameForCase(option,Name)
dir_name = [Name,'%'...
    ,depend(option.func_name),'%'...
    ,num2str(option.func_dim),'%'...
    ,num2str(option.subset),'%'...
    ];
end

function [file_name] = nameForRecord(option)
file_name = [option.date,'%'...
    ,depend(option.func_name),'%'...
    ,num2str(option.func_dim),'%'...
    ,num2str(option.subset),'.mat'];
end

function [nameInOption] = depend(func_name)
if strcmp(class(func_name),'double')
   nameInOption = ['CEC',num2str(func_name)]; 
else
   nameInOption = func_name;
end
end
