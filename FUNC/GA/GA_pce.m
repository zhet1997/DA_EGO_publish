%2021-6-1
function [BestCost,BestSolution] = GA_pce(name,Seed,MaxT,Range)
%S_GA Summary of this function goes here
%=================================================================
% Parameter initialization
%Etime=0;
tic;
Selection_Type = 2;               % Selection type:
Crossover_Type = 3;               % Crossover type:
PCross = 0.9;                       % Crossover probability, in the range [0 1]
pmut = 0.1;                       % Mutation probability, in the range [0 1]
MaxGeneration = 10000;              % Number of Iteration  (Generation)
Mating = 0.9;               % Mating Percent: how many percent of the individuals are created by Crossover (in New Population)
%=====================================================================
NPar =size(Seed,2);                        % Number of optimization variables
PopSize = size(Seed,1);                     % Total population size
%=====================================================================
if nargin<=3
    Range = repmat([0,1],[NPar,1]);
    if nargin<=2
        MaxT = 60;
    end
end
VarLow = Range(:,1);                     % Variable limits: Low Boundary
VarHigh = Range(:,2);                     % Variable limits: High Boundary
%---------------------------------------------------
MatingNum = round(PopSize*Mating*0.5)*2;        % how many of the individuals are created by Crossover (in New Population)
% if mod(MatingNum,2) ~=0
%     MatingNum = MatingNum-1;% it must be a single number
% end
RecomNum = PopSize - MatingNum;      % #population members that survive
MutatNum = round(pmut*PopSize);       % #population members that mutate
%====================================================================
%% Create the initial population
Pop = Seed;                 % Pop = unifrnd(VarLow, VarHigh,PopSize,NPar);
CostValue = feval(name,Pop);              % calculates population cost using objective function                  % calculates population cost using objective function
[CostValue, inx] = sort(CostValue,'ascend');                          % Sort objective function in descending order
Pop = Pop(inx,:);                                                     % Sort Initial Population in descending order of its objective function
BestCost = CostValue(1);
BestSolution = Pop(1,:);
%=====================================================================
%% Begin the evolution loop
%Iter=0;
%MinCost = BestCost;
%--------------------------------------
%sumSeed=unique(Seed,'rows');
%Pbest=BestCost;
%%%%%%%%%%%%%%%
for Iter=1:MaxGeneration
    % Iter=Iter+1;%??
    %     Dad = [];
    %     Mom = [];
%     Child = [];
    Parents = SelectionFcn(MatingNum,CostValue,Pop,PopSize,Selection_Type);
    %-------------------------------------------------
    %     for i = 1 : 2: MatingNum
    %         Dad = [Dad; Parents(i,:)];
    %         Mom = [Mom; Parents(i+1,:)];
    %     end
    temp = 1:2:MatingNum;
    Dad = Parents(temp,:);
    Mom = Parents(temp+1,:);
    %clear('temp');
    %-------------------------------------------
    %     for i = 1 : MatingNum/2
    %         [Child1, Child2] = CrossOverFcn(Dad(i,:),Mom(i,:),CostValue,NPar,PCross,VarLow,VarHigh,Iter,Crossover_Type);
    %         Child = [ Child; Child1; Child2];
    %     end
     %-------------------------------------------
%     Dad = mat2cell(Dad,ones(size(Dad,1),1),size(Dad,2));
%     Mom = mat2cell(Mom,ones(size(Mom,1),1),size(Mom,2));
%     cellNum = size(Dad,1);
%     cellEpt = num2cell(ones(cellNum,1));
%     %     cellone = num2cell(ones(cellNum,1));
%     Child = cellfun(@CrossOverFcn,Dad,Mom,...
%         cellEpt,num2cell(NPar*ones(cellNum,1)),num2cell(PCross*ones(cellNum,1)),...
%         cellEpt,cellEpt,cellEpt,num2cell(Crossover_Type*ones(cellNum,1)),...
%         'UniformOutput',false);
%     
%     Child = cell2mat(Child);
    %-------------------------------------------
        index1 = rand(size(Dad,1),NPar) < PCross;
        index1 = double(index1);
        index2 = ones(1,NPar) - index1;
        Child1 = Dad.*index1 + Mom.*index2;
        Child2 = Dad.*index2 + Mom.*index1;
        Child = [Child1;Child2];
    %---------------------------------------------
    %Mutation
    %     for i = 1 :  MutatNum
    %         k = randi([1 size(Child,1)]);% mutate this child sample or not
    %         for j = 1 : NPar
    %             if rand <= pmut% mutate this varibale sample or not
    %                 Child (k,j) = VarLow + (VarHigh - VarLow )*rand;%how much
    %             end
    %         end
    %     end
    
    k = randperm(size(Child,1));
    Child = Child(k,:);
    
    temp = rand([MutatNum,NPar]);
    index = find(temp<=pmut);
    temp(index)=1;
    temp(setdiff(1:MutatNum*NPar,index))=0;
    randBox = rand([MutatNum,NPar]);
    Child(1:MutatNum,:) ...
        = (ones(MutatNum,NPar)-temp).*Child(1:MutatNum,:)...
        +temp.*(randBox.*repmat(VarHigh'-VarLow',[MutatNum,1])+repmat(VarLow',[MutatNum,1]));
    %---------------------------------------------
    %    for i=1:size(Child,1)
    %         %%%%%%%%%%%%%%%Child1判断
    %         sumSeed=unique(sumSeed,'rows');
    %         a=size(sumSeed,1);
    %         sumSeed=[sumSeed;Child(i,:)];
    %         sumSeed=unique(sumSeed,'rows');
    %         if size(sumSeed,1)==a+1
    %            Pbest=[Pbest;min(min(Pbest),feval(name,Child(i,:)))];
    %         end
    %     end
    %---------------------------------------
    %% Recombination
    RecomPop = Pop(1:RecomNum,:);
    Pop = [Child;RecomPop];%the new pop
    
    %-------------------------------------------
    CostValue = feval(name,Pop);          % calculates population cost using objective function
    [CostValue, inx] = sort(CostValue,'ascend');                    % Sort objective function in descending order
    Pop = Pop(inx,:);                                                                                                                                                                                    % Sort Initial Population in descending order of its objective function
    %-------------------------------------------------
    if (CostValue(1) < BestCost)
        BestCost = CostValue(1) ;
        BestSolution = Pop(1,:);
    end
    
    if toc>=MaxT
        return
    end
    %     MinCost = [MinCost;BestCost];
    %     if size(Pbest,1)>MaxE
    %         Pbest(MaxE+1:size(Pbest,1),:)=[];
    %         return;
    %     end
end
end


