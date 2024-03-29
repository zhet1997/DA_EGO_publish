function [y] = update_players_inOpt(obj,result,updateList,startList)
% update the elite point here
player_option = obj.player_option(:,startList);
pointBox = [];
valueBox = [];
tempAll = obj.elite.point;
for ii = updateList
    temp = obj.elite.point;
    temp(1,player_option{ii}.variables) = result{ii,1}.best.point;
    tempAll(1,player_option{ii}.variables) = result{ii,1}.best.point;
    pointBox = [pointBox;temp];
    valueBox = [valueBox;result{ii,1}.best.value];
end
obj.AddGlobal(pointBox,valueBox);
obj.AddGlobal(tempAll);
obj.update_elite();
obj.update_players();
player_option = obj.player_option(:,startList);
y = player_option;
end

