function [y] = runSubOptimizer(obj)
% change the player_option with the startList
startList = 1:obj.subset;
startList = startList(obj.player_start==1);
result = cell(obj.subset,1);
%startNum = sum(obj.player_start);
%player_option_start = player_option(:,);
% do the sub-optimization
result_start = obj.runSubOptimizer@DivideConquerBase(startList);
result(startList,:) = result_start;

y = result;
end

