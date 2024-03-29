%2019-11-16
%函数作用是加点后自动更新模型和记录
%分为：1.识别输入，判断分类；2.更新类中数据；3.更新储存数据
%在本例中在迭代过程中只加入高精度样本

function  Update(obj,x)
if isempty(x)==0
obj.Sample.addSamHigh(x);
end

%在迭代过程中模型可能会发生变化。
obj.Model = GPfamily(obj.Sample.p, obj.Sample.v,obj.option.model);

obj.get_y_min();
%obj.add_record = [obj.add_record;size(x_1,1),size(x_2,1)];
end


