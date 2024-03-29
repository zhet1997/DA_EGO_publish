%2022-3-4
function [y] = setOption(taskName,option)
if contains(taskName,'_BS_')
    option.algo = @(x) DivideConquerBase(x);
    option.decomposeStr = 'randomGroup';
    option.subOptimizer = 'PLAYER_SF';
elseif contains(taskName,'_NS_')
    option.algo = @(x) DivideConquerBase(x);
    option.decomposeStr = 'fixGroup';
    option.subOptimizer = 'PLAYER_SF';
elseif contains(taskName,'_KT_')
    option.algo = @(x) DCBwithSurrogate(x);
    option.decomposeStr = 'randomGroup';
    option.subOptimizer = 'PLAYER_MF';
elseif contains(taskName,'_SRKT_')
    option.algo = @(x) DCBwithSurrogate(x);
    option.decomposeStr = 'randomGroup';
    option.borderStr = 'Reduce';
    option.subOptimizer = 'PLAYER_MXSR';
elseif contains(taskName,'_TF_')
    option.algo = @(x) DCBwithSurrogate(x);
    option.decomposeStr = 'fixGroup';
    option.borderStr = 'Reduce';
    option.subOptimizer = 'PLAYER_MXSR';
elseif contains(taskName,'_DA_')
    option.algo = @(x) DCBwithSurrogate(x);
    option.decomposeStr = 'DynamicAgregate';
    option.subOptimizer = 'PLAYER_SF';
    option.subset = -1;
elseif contains(taskName,'_FIDA_')
    option.algo = @(x) DCBwithSurrogate(x);
    option.decomposeStr = 'DynamicAgregate';
    option.subOptimizer = 'PLAYER_SF';
    option.startStr = 'ContributionBase';
    option.subset = -1;
elseif contains(taskName,'_SRDA_')
    option.algo = @(x) DCBwithSurrogate(x);
    option.decomposeStr = 'DynamicAgregate';
    option.subOptimizer = 'PLAYER_SF';
    option.borderStr = 'Reduce';
    option.subset = -1;
elseif contains(taskName,'_SRDADM_')
    option.algo = @(x) DCBwithSurrogate(x);
    option.decomposeStr = 'DynamicAgregate_DM';
    option.subOptimizer = 'PLAYER_SF';
    option.borderStr = 'Reduce';
    option.subset = -1;
elseif contains(taskName,'_FISRDA_')
    option.algo = @(x) DCBwithSurrogate(x);
    option.decomposeStr = 'DynamicAgregate';
    option.subOptimizer = 'PLAYER_SF';
    option.startStr = 'ContributionBase';
    option.borderStr = 'Reduce';
    option.subset = -1;
else
    error('wrong task name');
end
y = option;
end

