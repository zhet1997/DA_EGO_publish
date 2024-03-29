%B的计算
function [y,y2]= get_B(obj,label_p,theta,points)
%label_p不确定变量的维度
%theta超参数
%points样本坐标
if nargin==2
   theta = obj.theta;
   points = obj.points;
end
oNum = size(label_p,2);

if isempty(label_p)
    if nargout==1
    y=ones(size(points,1),1);%考虑计算整体方差的情况
elseif nargout==2
    y=ones(size(points,1),1);%考虑计算整体方差的情况
    distIdx = obj.get_idx(obj.num);
    y2=ones(size(distIdx,1),1);%考虑计算整体方差的情况    
    end  
else
x=0:obj.dense:1;
normy = obj.norm(x);
inteX = zeros(1,1,size(x,2));
inteX(1,1,:) = x;
if obj.distribute==0%均匀分布
  inteY = zeros(1,1,size(x,2));
  inteY(1,1,:) = linspace(1/size(x,2),1/size(x,2),size(x,2));
  dist = repmat(inteY,[obj.num,oNum,1]);%这里的第二维度应该是p
elseif obj.distribute==1%高斯分布
  inteY = zeros(1,1,size(x,2));
  inteY(1,1,:) = normy/size(x,2);
  dist = repmat(inteY,[obj.num,oNum,1]);
end
num= size(points,1);%输入的样本的个数
b = zeros(num,oNum,size(x,2));
%相比于A这里的张量多了一个用于积分的维度
temp = ones(num,oNum,size(x,2)).*inteX - ones(num,oNum,size(x,2)).*points(:,label_p);
temp = temp.*temp;
temp = temp.*theta(:,label_p);

if nargout==1
    b =exp(-temp);
    b = b.*dist;%添加分布系数
    sb = sum(b,3);
    %sb = sum(b,3)/size(x,2);%积分直接用加和表示
    y = prod(sb,2);
elseif nargout==2
    b =exp(-temp*2);
    b = b.*dist;%添加分布系数
    sb = sum(b,3);
    %sb = sum(b,3)/size(x,2);%积分直接用加和表示
    y = prod(sb,2);
    
    distIdx = obj.get_idx(obj.num);%在里面需要相加的是变量的轴不是维度的轴
    distij = repmat(inteY,[size(distIdx,1),oNum,1]);
    bij = temp(distIdx(:,1),:,:)+ temp(distIdx(:,2),:,:);
    bij = exp(-bij);
    bij = bij.*distij;%添加分布系数
    sbij = sum(bij,3);
    %sbij = sum(bij,3)/size(x,2);%积分直接用加和表示
    y2 = prod(sbij,2);
end
end
end





