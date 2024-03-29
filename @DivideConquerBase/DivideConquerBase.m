%2022-1-11
%关于nash-EGO算法的主优化类
classdef DivideConquerBase<handle
    properties % object imformation
        func_name
        func_dim
        Func
        decomposeStr
        borderStr = 'const';
        subOptimizer
    end
    
    properties
        SAVE_MODE = 0;
        DEBUG_MODE = 0;
    end
    
    properties % update in each cycle
        iter = 1
        
        subset
        subsetPlayer = [];
        elite
        border
        border_global
    end
    
    properties(Hidden) % about curent subPlayers
        player_template
        player_start
        player_result
        player_option
        player_location
    end
    
    properties
        option
        record
        record_Debug
        pointsLocal
        valuesLocal
        pointsGlobal
        valuesGlobal
    end
    
    properties(Hidden)
        elite_change
        subsetMax;
        coreNum = 10;
    end
    
    
    
    methods
        function obj = DivideConquerBase(option)%建立函数
            %mkdir
            obj.option = option;
            mkdir([option.pathRoot,option.tree.caseLocation]);
            % get the parameters
            obj.func_name = option.func_name;%测试函数名称
            obj.func_dim = option.func_dim ;%测试函数维度
            obj.subset = option.subset ;%输入player个数
            obj.decomposeStr = option.decomposeStr;
            obj.subOptimizer = option.subOptimizer;
            
            if isfield(option,'borderStr')
                obj.borderStr = option.borderStr;
            end
            
            if isfield(option,'SAVE_MODE')
                obj.SAVE_MODE = option.SAVE_MODE;
            end
            
            if isfield(option,'DEBUG_MODE')
                obj.DEBUG_MODE = option.DEBUG_MODE;
            end
            
            if obj.subset>0
                obj.subsetMax = obj.subset;
            else
                obj.subsetMax = obj.func_dim;
            end
            
            obj.border = repmat([0,1],[obj.func_dim,1]);% set the initial boundary
            obj.border_global = obj.border;
            obj.Func = @(x) Testmodel_player(x,option.func_name);
            obj.iniSam(option);
            %把建立的路径分别记录到子优化级中
            obj.player_template = option.player;
            obj.player_template.name =option.tree.playerName;
            obj.player_template.path =[option.pathRoot,option.tree.caseLocation];
            obj.player_template.sam.path =[option.pathRoot,option.tree.caseLocation];
            
            %输入参数
            obj.record = [option.pathRoot,option.tree.caseLocation,'Record',option.tree.recordName];
            obj.Record();
        end%construct
        
        iniElite(obj, option)
        iniSam(obj, option)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Update(obj)
        update_decompose(obj)
        update_border(obj);
        update_start(obj)
        update_elite(obj)
        update_localPoints(obj)
        update_players(obj)
        [y] = update_players_inOpt(obj,result,updateList,startList)
        
        resultCollect(obj,result)
        [y] = runSubOptimizer(obj,startList)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Record(obj)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function AddGlobal(obj,p,v)
            if nargin==2
                v = Testmodel_player(p,obj.func_name);
            end
            
            if  isempty(obj.pointsGlobal)
                obj.pointsGlobal = cell(obj.iter,1);
                obj.valuesGlobal = cell(obj.iter,1);
            end
            
            if  size(obj.pointsGlobal,1)<obj.iter
                obj.pointsGlobal{obj.iter,1} = [];
                obj.valuesGlobal{obj.iter,1}= [];
            end
            obj.pointsGlobal{obj.iter,1} = [obj.pointsGlobal{obj.iter,1};p];
            obj.valuesGlobal{obj.iter,1} = [obj.valuesGlobal{obj.iter,1};v];
        end
    end
end

