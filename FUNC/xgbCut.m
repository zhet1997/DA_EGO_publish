%2021-9-1oo
%��ȫ��ģ�ͽ���һ����Ƭ
function [y] = xgbCut(pathXGB,elite_point,variable,x)%�����variable�Ǳ������λ�õĲ�����xΪ�����ֵ
points = repmat(elite_point,[size(x,1),1]);
points(:,variable) = x;%������ֵ
y = XGBpredict(pathXGB,points);
end

