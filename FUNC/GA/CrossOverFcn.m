% function [Child1 Child2] = CrossOverFcn(Dady,Momy,CostValue,NPar,PCross,VarLow,VarHigh,Iter,Crossover_Type)
function [y] = CrossOverFcn(Dady,Momy,CostValue,NPar,PCross,VarLow,VarHigh,Iter,Crossover_Type)

switch Crossover_Type
    case 1
        if rand < PCross
            % single point crossover
            CrossPoint = ceil(rand * NPar);
            Child1 = [Dady(1:CrossPoint),Momy(CrossPoint+1:NPar)];
            Child2 = [Momy(1:CrossPoint),Dady(CrossPoint+1:NPar)];
        else
            % clone the parents
            Child1 = Dady;
            Child2 = Momy;
        end
    case 2
        % two-point crossover
        if rand < PCross
            CrossPoint1 = ceil(rand * NPar);
            CrossPoint2 = ceil(rand * NPar);
            if CrossPoint1 > CrossPoint2
                temp = CrossPoint2;
                CrossPoint2 = CrossPoint1;
                CrossPoint1 = temp;
            end
            Child1 = [Dady(1:CrossPoint1) Momy(CrossPoint1+1:CrossPoint2) Dady(CrossPoint2+1:NPar)];
            Child2 = [Momy(1:CrossPoint1) Dady(CrossPoint1+1:CrossPoint2) Momy(CrossPoint2+1:NPar)];
        else
            % clone the parents
            Child1 = Dady;
            Child2 = Momy;
        end
    case 3
        % uniform crossover
%         for i = 1 : NPar
%             if  rand < PCross
%                 Child1(:,i) = Dady(i);
%                 Child2(:,i) = Momy(i);
%             else
%                 Child1(:,i) = Momy(i);
%                 Child2(:,i) = Dady(i);
%             end
%         end
        
        index1 = rand(1,NPar) < PCross;
        index1 = double(index1);
        index2 = ones(1,NPar) - index1;
        Child1 = Dady.*index1 + Momy.*index2;
        Child2 = Dady.*index2 + Momy.*index1;
        
        
    case 4
        % Arithmetic Crossover
        if  rand < PCross
            Alpha = rand;
            Child1 = Alpha*Dady + (1-Alpha)*Momy;
            Child2 = Alpha*Momy + (1-Alpha)*Dady;
        else
            % clone the parents
            Child1 = Dady;
            Child2 = Momy;
        end
        
    case 5
        % Arithmetic Crossover- Single Point
        if  rand < PCross
            CrossPoint = ceil(rand * NPar);
            Child1 = [Dady(1:CrossPoint),Momy(CrossPoint+1:NPar)];
            Child2 = [Momy(1:CrossPoint),Dady(CrossPoint+1:NPar)];
            Alpha = rand;
            TempChild1 = Alpha*Dady(1:CrossPoint) + (1-Alpha)*Momy(1:CrossPoint);
            TempChild2 = Alpha*Momy(1:CrossPoint) + (1-Alpha)*Dady(1:CrossPoint);
            Child1 = [TempChild1 Dady(CrossPoint+1:end)];
            Child2 = [TempChild2 Momy(CrossPoint+1:end)];
        else
            % clone the parents
            Child1 = Dady;
            Child2 = Momy;
        end
        
    case 6
        T0 = -(max(CostValue)-min(CostValue))/log(0.9);
        if rand < PCross
            T=T0/(Iter+1);
            mu_=10^(inv(T)*100);
            % single point crossover :  Create Neighbourse
            CrossPoint = ceil(rand * NPar);
            TempChild1 = mu_inv(2*rand(size(Dady))-1,mu_)*(VarHigh - VarLow) + Dady ;
            TempChild2 = mu_inv(2*rand(size(Momy))-1,mu_)*(VarHigh - VarLow) + Momy ;
            Child1 = [TempChild1(1:CrossPoint),TempChild2(CrossPoint+1:NPar)];
            Child2 = [TempChild2(1:CrossPoint),TempChild1(CrossPoint+1:NPar)];
        else
            % clone the parents
            Child1 = Dady;
            Child2 = Momy;
        end
        
    
end
y = [Child1;Child2] ;
end

%======================================================================
