%2019-10-1
%这个程序的作用是为nash-EGO的子优化提供初始加点
%1：forrester函数
%2：branin函数
%3hartmann-3D  y_min=-3.86278 at(0.114614,0.555649,0.852547)
%4colville    y_min=0 at(1,1,1,1)
%5shekel    m=5 y_min=-10.1532 at（4,4,4,4）
classdef Sam_EGO<handle
    properties%本对象加点来源
        func %测试函数名称
        dimension %测试函数维度
        ini_number
        elite
        type
        border
        option
    end
    
    properties %样本库%用于存放历史加点信息
        samples_l
        samples_h
    end
    
    properties(Dependent,Hidden)
      y_min_l
      y_min_h
      p
      v
    end
    
    properties%feasible 相关
        fea_num
        fea_index
    end
    
    %===============================================================================
    methods
        %===============================================================================
        function obj=Sam_EGO(option)%%construct
            %接受所需参数
            obj.func = option.func;%需要计算的函数直接以匿名函数的形式导入
            obj.dimension = size(option.elite,2);
            obj.elite = option.elite;
            obj.ini_number = option.initial;%如果有两个就是以数列形式输入
            obj.option = option;%保存option
            
             if isfield(option,'border')
             obj.border=option.border;
             else
            g_down=zeros(obj.dimension,1);
            g_up=ones(obj.dimension,1);
            obj.border=[g_down,g_up];%这个范围只和搜索有关
             end
            
            obj.DoE('initial_all');%正常情况下的初始加点
            
        end%construct
        
        function [y] = readin(obj,source)%用于直接读入外界的样本值%但不直接储存到samples
            dim = obj.dimension;
            if dim==size(source,2)%points only
                y = [source,obj.evaluate(source)];
            elseif dim==size(source,2)-1 %points & values;
                y = source;
            else
                error("输入的样本格式错误")
            end
        end
        
        function [y] = evaluate(obj,points) %输入样本分布与取值匿名函数
%             num = size(points,1);            
            b = obj.func(points);%动态低精度
            y = b;
        end
        
        %初始分布函数
        DoE(obj,DoE_type)
        
        %update
        function addSamHigh(obj,add)
            obj.samples_h = [obj.samples_h;obj.readin(add)];
            %进行判断防止重复加点
            obj.samples_h = unique(obj.samples_h,'rows');%去除重复加点%这样可能少样本
        end
        
        function addSamLow(obj,add)
            obj.samples_l = [obj.samples_l;obj.readin(add)];
            %进行判断防止重复加点
            obj.samples_l = unique(obj.samples_l,'rows');%去除重复加点%这样可能少样本
        end
        
        function y_min_h = get.y_min_h(obj)
            y_min_h = min(obj.samples_h(:,obj.dimension + 1));
        end
        
        function y_min_l = get.y_min_l(obj)
            y_min_l = min(obj.samples_l(:,obj.dimenson + 1));
        end
        
        function [y] = get.p(obj)
        if isempty(obj.samples_l)==1
            y = obj.samples_h(:,1:obj.dimension);
        else
            y{1,1}=obj.samples_l(:,1:obj.dimension);
            y{2,1}=obj.samples_h(:,1:obj.dimension);
        end
        end
        
        function [y] = get.v(obj)
        if isempty(obj.samples_l)==1
            y = obj.samples_h(:,obj.dimension+1);
        else
            y{1,1}=obj.samples_l(:,obj.dimension+1);
            y{2,1}=obj.samples_h(:,obj.dimension+1);
        end
        end
        
        
        
    end
end


