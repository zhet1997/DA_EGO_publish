%���㲿�ֻ�ȫ������ĺ���
function [y] = get_sigma_sing(obj,label_l)
%�����˺�miuһ�µ������ʽ
if isempty(label_l)%��ȫ�־�ֵ�����
    label_l = [];
end
obj.l = size(label_l,2);
obj.p = obj.dimension-obj.l;
label_p = obj.l2p(label_l);%��label_l��label_p
distIdx = obj.get_idx(obj.num);
%A�ļ���
[Aii,Aij] = obj.get_B(label_l);
%B�ļ���
%[Bii,Bij] = obj.get_B(label_p);
B = obj.get_B(label_p);
Bii = B.*B;%�����Ѿ�ƽ����
Bij = B(distIdx(:,1)).*B(distIdx(:,2));
%V�ļ���
V = obj.R\(obj.values-ones(obj.num,1)*obj.alpha);
Vii = V.*V;%�����Ѿ�ƽ����
Vij = V(distIdx(:,1)).*V(distIdx(:,2));
%����
a0 = obj.get_miu_sing([]);%����a0��ֵ
temp1 = Vii.*Aii.*Bii;
temp1 = sum(temp1(:));
temp2 = Vij.*Aij.*Bij;
temp2 = sum(temp2(:))*2;
y = -(a0-obj.alpha)^2 + temp1 + temp2;%�ؼ���ʽ
end

