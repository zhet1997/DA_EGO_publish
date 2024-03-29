%2019-11-16
%记录函数，用于记录迭代中每次迭代的一些数据结果%只记在这里，外面只放及时信息
%记录在一个矩阵里（table）
%按迭代记录的数据有：
%1.最优值 2.EI最大值 3.消耗样本数（高精度） 
function  record(obj)
database = zeros(3,1);
%输入基本数据
database(1,1) =obj.Sample.y_min_h;
database(2,1) =obj.EI_max;
database(3,1) =size(obj.Sample.samples_h,1);
%保存基本数据
obj.Database = [obj.Database,database];
%处理衍生数据%在result中
end

