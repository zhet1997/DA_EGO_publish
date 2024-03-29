function [y] = get_miu_sing(obj,all)
%all��һ��2*m�ľ���
%��һ����ȷ���Ĳ�����λ�ã�
%�ڶ�����ȷ���Ĳ�����ȡֵ��
if isempty(all)%��ȫ�־�ֵ�����
    label_l = [];
    value_l = [];
else
    label_l = all(1,:);
    value_l = all(2,:);
end
obj.l = size(value_l,2);
obj.p = obj.dimension-obj.l;
label_p = obj.l2p(label_l);
%A�ļ���
A = obj.get_A(label_l,value_l);
%B�ļ���
B = obj.get_B(label_p);
%V�ļ���
V = obj.R\(obj.values-ones(obj.num,1)*obj.alpha);
%����
s = V.*A.*B;
y = obj.alpha + sum(s(:));
end