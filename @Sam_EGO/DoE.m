 %2019-11-8
%用于完成Sam_nash中初始分布的函数
%比较复杂，涉及多种加点方式选择
function DoE(obj,DoE_type)
%%分析问题类型
switch DoE_type
    case 'initial_all'
        obj.addSamHigh(obj.elite);%输入核心点样本
        points = extendSam(obj.dimension,obj.ini_number,obj.elite,obj.border);
        obj.addSamHigh(points);%进入samples
    case 'initial_TFA'
        obj.addSamHigh(obj.elite);%输入核心点样本
        points = extendSam(obj.dimension,obj.fea_num,obj.elite);
        obj.addSamHigh(points);%进入samples
    case 'extend_unnested'%对应HK
        %需要补足其余的初始加点
        points = extendSam(obj.dimension,obj.ini_number,obj.samples_h(:,1:obj.dimension));
        obj.addSamHigh(points);%进入samples
    case 'extend_nested'%对应CoKriging
        sourceFile = load([obj.fea_index],'opt');%直接读取传递的文件名
        obj.addSamLow(sourceFile.opt.Sample.samples_h);%加载到samples_l中
        clear('sourceFile');%用完就删
        
        %选择目标初始加点
        points = nestedSam(obj.dimension,obj.ini_number-obj.fea_num,obj.samples_l,2);
        obj.addSamHigh(points);%进入samples       
end

end

%%获得样本分布
%1.无信息，直接获取
function [y] = optimalLHS(dim,num,border)
%构造优化LHS样本集
ad=3;
lower = border(:,1)';
upper = border(:,2)';
points = lhsdesign(num*ad, dim);%输出为n*m的矩阵
points = points.*(upper-lower)+lower;
for i=1:num*(ad-1)
    y = pdist(points,'euclid');
    z = linkage(y,'single');
    p1 = z(1,1);%两个最接近的样本点之一
    p2 = z(1,2);%两个最接近的样本点之一
    d1 = sum((points(p1,:) - linspace(0.5,0.5,dim)).^2);
    d2 = sum((points(p2,:) - linspace(0.5,0.5,dim)).^2);
    if d1<d2%选择距离中心远的那一个去除
        points(p2,:) = [];
    else
        points(p1,:) = [];
    end
end
y = points;%输出为描述样本分布的矩阵
end

%2.有信息，有条件获取
function [y] = nestedSam(dim,num,source,addtype)
%infiling base on source%这里认为source同时包含point和value
%输入检验
if dim~=size(source,2)&&dim~=size(source,2)-1
    error("输入源无法进行匹配");
end
if num>size(source,1)
    error("高精度初始样本点个数多于低精度样本，无法进行选择！！！！")
end

%开始选择  1.按距离随机 2.按距离对比 3.按值对比
points_h = source(:,1:dim);
values_h = source(:,dim+1);

for i=1:size(source,1)-num
    %==================================================
    y = pdist(points_h,'euclid');
    z = linkage(y,'single');
    p1 = z(1,1);%两个最接近的样本点之一
    p2 = z(1,2);%两个最接近的样本点之一
    d1 = sum((points_h(p1,:) - linspace(0.5,0.5,dim)).^2);
    d2 = sum((points_h(p2,:) - linspace(0.5,0.5,dim)).^2);
    switch addtype
        case 1
            if d1>d2%选择距离中心近的那一个去除
                p = p2;
            else
                p = p1;
            end
        case 2
            if values_h(p1)<= values_h(p2)%选择tip值大的那一个去除
                p = p2;
            else
                p = p1;
            end
        case 3
            p=find(values_h==max(values_h));%找到最大的一个
            p=p(1);%可能有多个，只保留一个
            
    end
    values_h(p,:) = [];
    points_h(p,:) = [];%去除第p个点
end
[y] = points_h;%最终获得，新的样本分布
end

function [y] = extendSam(dim,num,existedPoint,border)
%在已经有部分样本的情况下继续加点
if dim~=size(existedPoint,2)&&dim~=size(existedPoint,2)-1
    error("输入源无法进行匹配");
end
pointsAll = optimalLHS(dim,num,border);% + size(existedPoint,1));
points = pointsAll;
delList = zeros(1,size(existedPoint,1));
for ii = 1:size(existedPoint,1)
 %吸附法
[~, delList(ii)] = min(sum((points - existedPoint(ii,:)).^2, 2));%去掉距离最近的一个
points(delList(ii),:) = [];
end
%points(delList,:)=[];
y = points;%最终结果不包含existedPoint数据
end

