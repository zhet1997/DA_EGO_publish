%2019-9-25
%此类代表一个Nash-EGO的子优化任务
%此类还用来传递一些需要在多次迭代中传递的信息
classdef Iter_EGO<handle
    properties
        Sample
        Model
        option
    end
    
    properties
        border
        y_min_co
        y_min%样本点中最小值
        y_min_res%响应面的最小值
    end
    
    properties %record
        EI_max
        Database
        ano_ax
        ano_a0
    end
    
    properties(Dependent,Hidden)
        eimax
        sla
    end
    properties(Dependent,Hidden)%analysis
        best
        borderNew
        sensitive
        R2
        anova
        improve
    end
    properties %record
        borderNewMM%only for KT-EGO
    end
    methods
        
        function obj = Iter_EGO(option)
            %输入一个包含主元素的option
            %1.测试函数(具体匿名函数)2.停止条件
            obj.option = option;%记录条件
            
            %确定边界
            if isfield(option,'border')
                obj.border=option.border;
            else
                g_down=zeros(obj.Sample.dimension,1);
                g_up=ones(obj.Sample.dimension,1);
                obj.border=[g_down,g_up];%这个范围只和搜索有关
            end
            
            option.sam.border=obj.border;
            obj.Sample = Sam_EGO(option.sam);%设定加点数据
            if strcmp(option.model,'HierarchicalKriging')%&&isexist(option.globalfunc)
                obj.Model = GPfamily( obj.Sample.p, obj.Sample.v ,option.model,option.globalfunc);%一开始就直接建立HK模型
            else
                obj.Model = GPfamily( obj.Sample.p, obj.Sample.v ,option.model);
            end
            
            %===========================
            obj.get_y_min;%计算复杂参数
            %设置ano
        end
        %================================================================================
        %迭代函数（加入新的样本点并更新模型状态）
        Update(obj,x_1)%
        Update_HK(obj,x_1,surface)%直接加入代理模型
        %==================================================================================================
        %参数计算
        function get_y_min(obj)
            func = @(x)obj.Model.predict(x);
            %[obj.y_min_co,obj.y_min_res] = ga(func,obj.Sample.dimension,[],[],[],[],obj.border(:,1),obj.border(:,2));
            Seed = lhsdesign(obj.Sample.dimension*500,obj.Sample.dimension);
            MaxT = obj.Sample.dimension;
            [obj.y_min_res,obj.y_min_co] = GA_pce(func,Seed,MaxT,obj.border);
            obj.y_min  = obj.Sample.y_min_h;
        end
        
        %==================================================================================================
        %选择加点函数
        %GEI方法
        [xx,yy]=find_GEI(obj,gmax)
        %EI方法
        [xx,yy]=find_EI(obj,EIborder)
        %==================================================================================================
        %停止条件函数
        [y]=termination(obj,type)
        %num1
        function [y] = get.eimax(obj)
            y = obj.EI_max;
        end
        %num2
        function [y] = get.sla(obj)
            s = obj.Database(3,:);
            t = size(s,1);
            ii = 0;
            if t==1
                y = 0;
            else
                while ii<t-1&&s(t-ii)==s(t-ii-1)
                    ii = ii+1;
                end
                y = ii;
            end
        end
        %===================================================================================================
        %记录函数%自动记录迭代过程中一些有价值的值
        record(obj)
        %=======================================================================================
        %后处理函数%对优化完成后的算法进行后处理与分析
        %计算最优值
        function [y] =get.best(obj)   %get the best value and its location
            y.value = obj.Sample.y_min_h;
            temp = obj.Sample.samples_h==y.value;%记录条件
            temp = repmat(temp(:,obj.Sample.dimension+1),1,obj.Sample.dimension);
            y.point = obj.Sample.samples_h(:,1:obj.Sample.dimension).*temp;
            y.point(temp(:,1)==0,:)=[];
            y.point = y.point(1,:);
        end
        %计算新边界
        function [y] =get.borderNew(obj)
            ratio = 0.5;
            y = spaceReduce(@(x)obj.Model.predict(x),obj.border,ratio);
        end
        
        %计算敏感度(摄动法)
        function [y] =get.sensitive(obj)
            if obj.Sample.dimension==1
                y=[];
            else
                y = iteraction(obj.Model,obj.borderNew);
            end
        end
        %计算模型精度
        function [y] =get.R2(obj)
            list = LooCV(obj.Model);
            y= list.R2;
        end
        %计算贡献度
        function [y] =get.anova(obj)
            if obj.Sample.dimension==1
                y=[];
            else
                ano= ANOVA(obj.Model);
                temp = ano.contribution();
                %             temp = temp.AllOrders{1,1};
                %             if sum(temp<=0)% if there are any minus in temp
                %                 temp = temp*0 + 1;
                %             end
                %             temp = temp/sum(temp);
                y = temp';
            end
        end
        %计算提升
        function [y] =get.improve(obj)
            y = obj.Database(1,1)-obj.Database(1,end);
        end
        %计算
        %=======================================================================================
    end
end

