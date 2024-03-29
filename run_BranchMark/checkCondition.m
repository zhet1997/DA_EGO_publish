function [y] = checkCondition(option)
 if ~exist([option.pathRoot,...
            option.tree.caseLocation,'Result',...
            option.tree.recordName],'file')        
      y = 'unexecuted';  
 else  
     ld = load([option.pathRoot,option.tree.caseLocation,'Record',option.tree.recordName]);
     if sum(ld.record.cost)>=1500
        y = 'finished';
     else
         y = 'unfinished';
         costAll = sum(ld.record.cost);
         disp(['The number of samples is ',num2str(costAll)]);      
     end
 end
end

