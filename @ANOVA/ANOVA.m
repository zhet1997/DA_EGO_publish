%2020-12-19
%�µ�ANOVA�࣬���������Ҫ����һ�㣬��Ҫ���������������У�Ҳ��Ҫ�й��ڸ��ӵ����������
%Ҫ����׼ȷ�ļ����ֵ�ͷ���
%������ͼ�Ĺ���
%�ܽ��ܸ��ຯ��������
%����֧�־��ȷֲ��͸�˹�ֲ�������ʽ
%���ڸ�˹�ֲ��������ܶ��ǰ���ά�����ӵ�
classdef ANOVA<handle
    properties
        Model%ֱ��ʹ������ɵ���Ӧ��
        distribute = 0;
        dense = 0.01;
    end
    
    properties(Dependent)%��Kriging������ȡ��ԭʼ����
        points%������������
        values%��������ֵ
        dimension%����ά��
        num%��������
        
        R%���ϵ������
        alpha%�ع�ֵ
        theta%�������ϵ���ĳ�����
    end
    
    properties(Hidden)%���㺯�����������
        l%ȷ��������ά��
        p%��ȷ��������ά�� %p+l=n
        %x%ȷ�����������%��l*2�ĸ�ʽ����%����Ϊ������ţ�����Ϊ����ֵ
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
                error("����Ĳ��ǺϷ��Ĵ���ģ�Ͷ�������ϸ��顣");%��ʱֻ֧����������
            end
            obj.Model = model;
        end%construct function
        %==================================================================
        %dependent
        %==================================================================
        %������Ϣ
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
        % ģ����Ϣ
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
        [y] = get_A(obj,label_l,x,theta,points)%��ŷ���label��%����������
        
        [y,y2] = get_B(obj,label_p,theta,points)%B�ļ���
        
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
            a = tril( idx,-1 ); % idx  %��ȡ�����Ǿ��󣬲����Խ���
            b = triu( idx,1 )'; % idx  %��ȡ�����Ǿ���
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

