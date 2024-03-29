%�������е�AΪ�˼�����Ǻ��ĵ��е�A��һ�µġ�
%�ĵ��е�A��Ӧ�����V
function [y] = get_A(obj,label_l,value_l,theta,points)%��ŷ���label��%����������
%l_labelȷ��������ά��

%theta������
%points��������
if nargin==3
   theta = obj.theta;
   points = obj.points;
end

%ug-xg
if isempty(value_l)
    y=ones(size(points,1),1);%���Ǽ��������ֵ�����
else
    temp = ones(size(points,1),obj.l).*value_l-points(:,label_l);%ȫ������
    temp = temp.*temp;%ƽ��
    temp = temp.*theta(:,label_l);%���Գ�����
    y = exp(-sum(temp,2));%ָ����
end
end
