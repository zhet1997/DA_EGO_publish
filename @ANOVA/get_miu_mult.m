function [y] = get_miu_mult(obj,all)
if isempty(all)
    label_l = [];
    x = [];
else
    label_l = all(1,:);
    x = all(2,:);
end


obj.l = size(x,2);
obj.p = obj.dimension-obj.l;

if obj.l>=obj.n||obj.l~=size(label_l,2)
    error("输入的x参数不规范，请检查");
end
label_p = 1:obj.dimension;
for ii=1:obj.l
    label_p = label_p(label_p~=(label_l(ii)));
end

%A的计算
a1 = obj.get_A(label_l,x,obj.theta(1,:),obj.points{1,1});
a2 = obj.get_A(label_l,x,obj.theta(1,:),obj.points{2,1});
a3 = obj.get_A(label_l,x,obj.theta(2,:),obj.points{2,1});

A = [a1,zeros(size(a1));a2,a3];
%B的计算
b1 = obj.get_B(label_p,obj.theta(1,:),obj.points{1,1});
b2 = obj.get_B(label_p,obj.theta(1,:),obj.points{2,1});
b3 = obj.get_B(label_p,obj.theta(2,:),obj.points{2,1});

B = [b1,zeros(size(b1));b2,b3];

C = [obj.rho*obj.sigma_c2*ones(obj.Sample.number_l,1),zeros(obj.Sample.number_l,1)...
    ;obj.rho^2*obj.sigma_c2*ones(obj.Sample.number_h,1),obj.sigma_d2*ones(obj.Sample.number_h,1)];

V = obj.R\(cell2mat(obj.ys)-ones(obj.n,1)*obj.beta);
s = A.*B.*C;
y = obj.beta + V'*sum(s,2);
end
