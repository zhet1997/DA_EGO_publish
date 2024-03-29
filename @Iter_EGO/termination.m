%2019-11-19
%终止条件部分
function [y] = termination(obj,type)
switch type
    case 'eimax'
        y= eimax(obj);
    case 'sla'
        if size(obj.Database,1)>=2*obj.Sample.dimension
            y= sla(obj);
        else
            y=0;
        end
        
    case 'iter'
        if size(obj.Database,1)>=obj.option.max
            y= 1;
        else
            y=0;
        end
    case 'cost'
        y= cost(obj);
        
end
end


%EI最大值小于一定范围
function  bool = eimax(obj)
if obj.eimax<obj.option.EI
    disp("根据EI条件停止迭代")
    bool = 1;
else
    bool= 0;
end

end

%sla标准
function bool=sla(obj)
a_number = 2*(obj.Sample.dimension);
if obj.sla<=a_number
    bool=0;
else
    disp("根据sla条件停止迭代")
    bool = 1;
end
end

%当加点数超过一定数量停止
function  bool = cost(obj)
if obj.Database(3,end)>obj.option.cost
    disp("根据折合加点数停止迭代")
    bool = 1;
else
    bool= 0;
end
end
