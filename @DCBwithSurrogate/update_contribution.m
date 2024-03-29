function update_contribution(obj,anoResult,improveList)
% the startList record which player is carry out in this cycle.
% the playerResult record the resiult of all players.
% the contribution is how too divide , in a  mutiple dimnesion layer
%% get the improve
startList = 1:obj.subset;
startList = startList(obj.player_start==1);
playerResult = obj.player_result;% make sure the data is update already.
FitnessNew = zeros(1,obj.func_dim)-1;

%% treat anoResult
for ii =1:obj.subset
    if ~isempty(anoResult{1,ii})
        temp = anoResult{1,ii};
        temp = temp.AllOrders{1,1};
        if sum(temp<=0)% if there are any minus in temp
            temp = temp*0 + 1;
        end
        temp = temp/sum(temp);
        anoResult{1,ii} = temp;
    end
end
%% get the contribution
for ii = startList
    variables = obj.subsetPlayer{1,ii};
    dim = size(variables,2);
%     improve = obj.elite.value - playerResult(1,ii);
    improve = improveList(1,ii);
    if dim>1
        con = anoResult{1,ii}*improve;
        for jj = 1:dim
            FitnessNew(1,variables(1,jj)) = con(jj);
        end
    else
        FitnessNew(1,variables(1,1)) = improve;
    end
end

obj.contribution = [obj.contribution; FitnessNew];
end

