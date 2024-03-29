function Update(obj)%one cycle
if strcmp(obj.surroStr,'PCE')
obj.update_PCE();
elseif strcmp(obj.surroStr,'XGB')
obj.update_XGB();
end
Update@DivideConquerBase(obj);
end
