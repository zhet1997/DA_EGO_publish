function [y] = CBstart(subsetPlayer, contrubution)
%% set the parameters
subset = size(subsetPlayer,2);
gamma = 3;
dimMax =  10;
contriInSubset = zeros(1,subset);
optList= zeros(1,subset);

%% calculate the convert contribution
for ii = 1:subset
    variables = subsetPlayer{1,ii};
    dim = size(variables,2);
    con = 0;
    for jj = 1:dim
        dimIndex = variables(1,jj);
        temp = contrubution(:,dimIndex);
        temp(temp == -1)=[];% get rid of cycles not start;
        index = max(size(temp,1)-gamma,0)+1;        
        temp = mean(temp(index:end,1));
        con = con + temp;
    end
    contriInSubset(1,ii) = con/dim;
end

%% choose the players
[~,varSort] = sort(contriInSubset,'descend');
dimStart = 0;
for ii = 1:subset
    optList(1,varSort(ii))=1;
    variables = subsetPlayer{1,varSort(ii)};
    dimStart = dimStart +  size(variables,2);
    if dimStart > dimMax
        break;
    end
end

y = optList;
end

