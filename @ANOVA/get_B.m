%B�ļ���
function [y,y2]= get_B(obj,label_p,theta,points)
%label_p��ȷ��������ά��
%theta������
%points��������
if nargin==2
   theta = obj.theta;
   points = obj.points;
end
oNum = size(label_p,2);

if isempty(label_p)
    if nargout==1
    y=ones(size(points,1),1);%���Ǽ������巽������
elseif nargout==2
    y=ones(size(points,1),1);%���Ǽ������巽������
    distIdx = obj.get_idx(obj.num);
    y2=ones(size(distIdx,1),1);%���Ǽ������巽������    
    end  
else
x=0:obj.dense:1;
normy = obj.norm(x);
inteX = zeros(1,1,size(x,2));
inteX(1,1,:) = x;
if obj.distribute==0%���ȷֲ�
  inteY = zeros(1,1,size(x,2));
  inteY(1,1,:) = linspace(1/size(x,2),1/size(x,2),size(x,2));
  dist = repmat(inteY,[obj.num,oNum,1]);%����ĵڶ�ά��Ӧ����p
elseif obj.distribute==1%��˹�ֲ�
  inteY = zeros(1,1,size(x,2));
  inteY(1,1,:) = normy/size(x,2);
  dist = repmat(inteY,[obj.num,oNum,1]);
end
num= size(points,1);%����������ĸ���
b = zeros(num,oNum,size(x,2));
%�����A�������������һ�����ڻ��ֵ�ά��
temp = ones(num,oNum,size(x,2)).*inteX - ones(num,oNum,size(x,2)).*points(:,label_p);
temp = temp.*temp;
temp = temp.*theta(:,label_p);

if nargout==1
    b =exp(-temp);
    b = b.*dist;%��ӷֲ�ϵ��
    sb = sum(b,3);
    %sb = sum(b,3)/size(x,2);%����ֱ���üӺͱ�ʾ
    y = prod(sb,2);
elseif nargout==2
    b =exp(-temp*2);
    b = b.*dist;%��ӷֲ�ϵ��
    sb = sum(b,3);
    %sb = sum(b,3)/size(x,2);%����ֱ���üӺͱ�ʾ
    y = prod(sb,2);
    
    distIdx = obj.get_idx(obj.num);%��������Ҫ��ӵ��Ǳ������᲻��ά�ȵ���
    distij = repmat(inteY,[size(distIdx,1),oNum,1]);
    bij = temp(distIdx(:,1),:,:)+ temp(distIdx(:,2),:,:);
    bij = exp(-bij);
    bij = bij.*distij;%��ӷֲ�ϵ��
    sbij = sum(bij,3);
    %sbij = sum(bij,3)/size(x,2);%����ֱ���üӺͱ�ʾ
    y2 = prod(sbij,2);
end
end
end





