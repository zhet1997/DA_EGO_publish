function update_players(obj)
for ii=1:obj.subset%对子优化的参数进行更新
    obj.player_option{1,ii} = obj.player_template;
    obj.player_option{1,ii}.variables = obj.subsetPlayer{1,ii};    
    obj.player_option{1,ii}.sam.func = @(x)Testmodel_player(x,obj.func_name,obj.elite.point,obj.player_option{ii}.variables);%修改子函数
    obj.player_option{1,ii}.elite = obj.elite.point(obj.player_option{ii}.variables);%修改精英坐标
    obj.player_option{1,ii}.sam.elite = obj.player_option{ii}.elite;
    obj.player_option{1,ii}.iter = obj.iter;
    obj.player_option{1,ii}.start = obj.player_start(ii);
    obj.player_option{1,ii}.num = ii;
    obj.player_option{1,ii}.border = obj.border(obj.subsetPlayer{1,ii},:);
    if strcmp(obj.subOptimizer,'PLAYER_MXSR')
        if strcmp(obj.surroStr,'PCE')
            obj.player_option{1,ii}.globalfunc = @(x) pceCut(obj.modGlobal,obj.elite.point,obj.player_option{1,ii}.variables,x);%将切片后的全局模型输入
        elseif strcmp(obj.surroStr,'XGB')
            obj.player_option{1,ii}.globalfunc = @(x) xgbCut(obj.pathXGB,obj.elite.point,obj.player_option{1,ii}.variables,x);%将切片后的全局模型输入
        end
    end
end
end

