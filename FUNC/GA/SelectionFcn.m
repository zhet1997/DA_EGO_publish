function Parents = SelectionFcn(MatingNum,CostValue,Pop,PopSize,Selection_Type)
Parents = [];
switch Selection_Type
    case 1
        %Selection  : Roulette Wheel Selection
        Cost_Temp = max(CostValue) - CostValue;
        PDF = Cost_Temp/sum(Cost_Temp);
        CDF = cumsum(PDF);
        for i = 1 : MatingNum
            IndexSelection = find(rand <= CDF,1,'first');
            Parents = [Parents; Pop(IndexSelection,:)];
        end
        
    case 2
        %Selection  : Rank Selection
        %         PDF = (PopSize + 1 -[1:PopSize]')/(PopSize*(PopSize + 1)/2);
        %         PDF = PDF/sum(PDF);
        %         CDF = cumsum(PDF);
        %         for i = 1 : MatingNum
        %             IndexSelection=find(rand <= CDF,1,'first');
        %             Parents= [Parents; Pop(IndexSelection,:)];
        %         end
        index = randperm(PopSize);
        index = index(:,1:MatingNum);
        Parents = Pop(index,:);
        
    case 3
        % Tournament Selection
        for i = 1 : MatingNum
            IndexSelection = randsample(PopSize,2);
            if CostValue(IndexSelection(1)) < CostValue(IndexSelection(2))
                Parents =[Parents;Pop(IndexSelection(1),:)];
            else
                Parents =[Parents;Pop(IndexSelection(2),:)];
            end
        end
        
        % stochastic acceptance
    case 4
        i = 0;
        Cost_Temp = max(CostValue) + min(CostValue) - CostValue;
        while (i<= MatingNum)
            IndexSelection = randsample(PopSize,1);
            if  rand < Cost_Temp(IndexSelection)/max(Cost_Temp)
                Parents =[Parents;Pop(IndexSelection,:)];
                i = i + 1;
                
            end
        end
        
    case 5   %Elitism
        
        for i = 1 : MatingNum
            Parents = [Parents; Pop(i,:)];
        end
end

end
