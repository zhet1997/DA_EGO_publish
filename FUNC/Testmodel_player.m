%2019-11-5
%����������ȡ������nash-EGO�Ĳ��Ժ���
function [y] = Testmodel_player(x,testfunction,elite,subset)
global initial_flag; % the global flag used in test suite
if nargin==2
    x_all = x;
elseif nargin==4
    x_all = repmat(elite,[size(x,1),1]);
    x_all(:,subset) =  x;
end
%����Ϊ��һ��֮��Ĳ���
%��xȡ��elite�ж�Ӧλ��
if   strcmp(testfunction,'Engineer')
Rst = EngSimulation(x_all);
elseif isa(testfunction,'double')||isa(testfunction,'int64')
initial_flag = 0;%���initial_flagΪȫ�ֺ���
Rst = benchmark_func(x_all, testfunction);  
else
Rst = Testmodel_nash(x_all,testfunction);
end


if size(Rst,2)==1
y = Rst;
else
y = mult2sin(Rst,'7Blade'); 
end
end