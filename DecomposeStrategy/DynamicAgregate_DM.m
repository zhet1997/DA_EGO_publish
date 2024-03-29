function [y1,y2] = DynamicAgregate_DM(func_dim,interaction,sensitive)
%% initial with cofirmed interaction
subsetPlayer = mat2cell(1:func_dim,1,linspace(1,1,func_dim));
% the first line is the index of design variable
% the second line is the location of cell where the variable is now
playerIndex = repmat(1:func_dim,[2,1]);
varIdx = get_idx(func_dim);

for ii = 1:size(varIdx,1)
    if interaction(ii,:)==1
        temp1 = varIdx(ii,1);
        temp2 = varIdx(ii,2);
        
        temp1 = playerIndex(2,temp1);
        temp2 = playerIndex(2,temp2);
        
        if temp1~=temp2 %make sure that 2 variables are not in one group yet.
            subsetPlayer{1,temp1} = [subsetPlayer{1,temp1},subsetPlayer{1,temp2}];
            subsetPlayer{1,temp2} = [];
            playerIndex(2,temp2)= temp1;
        end
    end
end

%% Nomination by PCE
order1 = sensitive.AllOrders{1,1};
order2 = sensitive.AllOrders{1,2};
ind2 = sensitive.VarIdx{2,1};

temp = rand([size(order1,1)+size(order2,1),1]);
temp = temp/sum(temp);
coef = 0.1;
% add a little random perturbation
%order1 =  order1*(1-coef) + temp(1:size(order1,1))*coef;
order2 =  order2*(1-coef) + temp(size(order1,1)+1:end)*coef;
NomList = [0;0];
% the first line is the index of design variable nominated.
% the second line is the group which the variable belong.
[order2,I] = sort(order2,'descend');
ind2 = ind2(I,:);
for ii = 1:size(ind2,1)
    temp1 = ind2(ii,1);% index of variable
    temp2 = ind2(ii,2);
    temp1 = playerIndex(2,temp1);% which subplayer the varibale in now.
    temp2 = playerIndex(2,temp2);
    if size(subsetPlayer{1,temp1},2) + size(subsetPlayer{1,temp2},2)>6
        % do not put more than 5 variables into one group
        continue;
%     elseif ismember(temp1,NomList(2,:))||ismember(temp2,NomList(2,:))
%         % only one nominater is add in one group in every cycle.
%         continue;
    elseif temp1==temp2
        % sometimes this two variable is grouped already.
        continue;
    else
        subsetPlayer{1,temp1} = [subsetPlayer{1,temp1},subsetPlayer{1,temp2}];
        subsetPlayer{1,temp2} = [];
        playerIndex(2,temp2)= temp1;
        % add this nominater into NomList
        Nom = [ind2(ii,2);temp1];
        NomList = [NomList,Nom];
    end
    
    if size(NomList,2)>func_dim/2+1 || order2(ii,1)<0.0005
        break;
    end
end
y1 =  subsetPlayer;
y1(cellfun(@isempty,y1))=[];

y2 = [];
for ii = 2:size(NomList,2)
    subIdx = NomList(2,ii);
    y2 = [y2,subsetPlayer{1,subIdx}];
end

end

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
