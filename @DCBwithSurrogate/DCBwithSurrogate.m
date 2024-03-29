classdef DCBwithSurrogate<DivideConquerBase
    properties
        modGlobal
        sensitive
        interaction
        contribution
        
    end
    properties
        surroStr = []
        pathXGB = [];
        startStr = [];
    end
    
    methods
        function obj = DCBwithSurrogate(option)%建立函数
            obj = obj@DivideConquerBase(option);
            if isfield(option,'startStr')
                obj.startStr = option.startStr;
            end
            if isfield(option,'surroStr')
                obj.surroStr = option.surroStr;
                
                if strcmp(obj.surroStr,'XGB')
                    filep = mfilename('fullpath');
                    [pathstr,~] = fileparts(filep);
                    obj.pathXGB = [pathstr,'/../FUNC/XGB/'];%XGB路径是一个相对位置
                end
            end
            obj.interaction = zeros(obj.func_dim*(obj.func_dim-1)/2,1);            
        end%construct
        
        Update(obj)
        update_PCE(obj)
        update_decompose(obj)
        update_start(obj)
        update_interaction(obj,R2List,sensitiveBox)       
        update_contribution(obj,anoResult,improveList)
        
        iniContri(obj)
        
        [y] = runSubOptimizer(obj)
        resultCollect(obj,result)       
    end
    
    methods(Static)
        function [y] = get_idx(x)       
            dim = length(x);
            if dim==1
                nSam = 1:x;
                dim = x;
            else
                nSam = sort(x);
            end
            
            idx = repmat(nSam,[dim, 1]);
            a = tril( idx,-1 ); % idx  %抽取下三角矩阵，不含对角线
            b = triu( idx,1 )'; % idx  %抽取上三角矩阵
            a = a(a~=0); % remove zero's
            b = b(b~=0); % remove zero's
            y = [a b];
        end
    end
end

