%2020-12-19
%新的ANOVA类，这个尽量需要独立一点，不要包含在其他的类中，也不要有过于复杂的输入的限制
%要求能准确的计算均值和方差
%包括出图的功能
%能接受各类函数的输入
%可以支持均匀分布和高斯分布两种形式
%关于高斯分布，概率密度是按照维度来加的
classdef ANOVA<handle
    properties
        Model%直接使用已完成的响应面
        distribute = 0;
        dense = 0.01;
    end
    
    properties(Dependent)%从Kriging类中提取的原始数据
        points%所有样本坐标
        values%所有样本值
        dimension%坐标维度
        num%样本个数
        
        R%相关系数矩阵
        alpha%回归值
        theta%计算相关系数的超参数
    end
    
    properties(Hidden)%计算函数的相关数据
        l%确定变量的维度
        p%不确定变量的维度 %p+l=n
        %x%确定坐标的输入%以l*2的格式输入%左列为参数序号，右列为具体值
        miu
    end
    
    properties
        curves = []
        sensitive = []
        colors = []
    end
    
    methods
        function obj = ANOVA(model)%construct function
            if isa(model,'CoKriging')==0&&isa(model,'Kriging')==0&&isa(model,'HighDimensionKriging')==0
                error("输入的不是合法的代理模型对象，请仔细检查。");%暂时只支持上述三类
            end
            obj.Model = model;
        end%construct function
        %==================================================================
        %dependent
        %==================================================================
        %样本信息
        function values = get.values(obj)
            values = obj.Model.getValues();
        end
        
        function points =get.points(obj)
            points = obj.Model.getSamples();
        end
        
        function dimension =get.dimension(obj)
            dimension = size(obj.points,2);
        end
        
        function num = get.num(obj)
            num = size(obj.points,1);
        end
        % 模型信息
        function R = get.R(obj)
            R = full(obj.Model.C*obj.Model.C');
        end
        
        function alpha = get.alpha(obj)
            alpha =obj.Model.alpha;
        end
        
        function theta =get.theta(obj)
            theta = 10.^obj.Model.getHyperparameters;
        end
        
        %==================================================================
        %calcular
        %==================================================================
        [y] = get_A(obj,label_l,x,theta,points)%序号放在label里%都是行向量
        
        [y,y2] = get_B(obj,label_p,theta,points)%B的计算
        
        [y] = get_miu_sing(obj,all)
        
        [y] = get_miu_mult(obj,all)
        
        [y] = contribution(obj)
        
        [y] = senCurves(obj)
        
        drawPie(obj)
        
        drawCurves(obj)
        
        [y] = findPoint(obj)
        
        function [y] = l2p(obj,label_l)
            label_p = 1:obj.dimension;
            for ii=1:obj.l
                label_p = label_p(label_p~=(label_l(ii)));
            end
            y = label_p;
        end
    end
    methods(Static)
        function [y] = get_idx(dim)
            nSam = 1:dim;
            idx = nSam(ones(dim, 1),:);
            a = tril( idx,-1 ); % idx  %抽取下三角矩阵，不含对角线
            b = triu( idx,1 )'; % idx  %抽取上三角矩阵
            a = a(a~=0); % remove zero's
            b = b(b~=0); % remove zero's
            y = [a b];
        end
        
        function [y] = norm(x)
            y = normpdf(x,0.5,1/6);
        end
        
        function [y] = makeLabel(index)
            num = size(index,2);
            if num==1
                label = ['x',num2str(index)];
            elseif num==2
                label = ['x',num2str(index(1)),'/','x',num2str(index(2))];
            end
            y = label;
        end
        
        
        [y] = linspecer(num)
    end
end

