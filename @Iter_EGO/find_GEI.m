function [xx,yy]=find_GEI(obj,gmax)%把选点过程与聚类过程分开

x=zeros(gmax+1,obj.Sample.dimension);
y0=zeros(gmax+1,1);
gei = cell(gmax+1,1);
fgei = cell(gmax+1,1);
for ii=1:gmax+1
    gg=ii-1;
    gei{ii,1}=@(x)GEI(obj,x,gg);
    fgei{ii,1} = @()ga(gei{ii,1},obj.Sample.dimension,[],[],[],[],obj.border(:,1),obj.border(:,2));
end
clear('gg');
parfor ii=1:gmax+1
    [a{ii,1},b{ii,1}]= fgei{ii,1}();
end
a = cell2mat(a);
b = cell2mat(b);
c = obj.Model.predict(a);

if obj.Sample.dimension==1
 s=find(b==0);
 a(s,:)=[];
 c(s,:)=[];
end

obj.EI_max=-min(b);%把九个EI中值最大的一个储存起来
xx = a;
yy = c;
end

function yy=GEI(obj,x,gg)%这里gg代表了GEI中g的大小
[y,mse2] = obj.Model.predict(x);
s=sqrt(abs(mse2));

if mse2<=1e-10%这里可以调节
    yy=0;
    %disp('s==0');
else
    u=(obj.y_min-y)/s;
    T(1)=normcdf(u,0,1);%这里的T（1）代表公式中的T0，以下同理
    T(2)=-normpdf(u,0,1);
    for i=3:1:gg+1
        k=i-1;
        T(i)=-u^(k-1)*normpdf(u,0,1)+(k-1)*T(i-2);
    end
    sum=0;
    if(gg==0)
        yy=T(1);
    else
        for i=1:gg+1
            k=i-1;
            sum=sum+(-1)^(k)*nchoosek(gg,k)*u^(gg-k)*T(i);%2019-7-1做出改动，之前都错了
        end
        yy=(sum*s^gg)^(1/gg);
    end
    yy=-yy;
end
end