function [y] = load_opt(option)
if ~exist([option.pathRoot,option.tree.caseLocation,'Result',option.tree.recordName],'file')
error('The result file is not exist ')
end
if ~exist([option.pathRoot,option.tree.caseLocation,'Result',option.tree.recordName],'file')
error('The record file is not exist ')
end
load([option.pathRoot,option.tree.caseLocation,'Result',option.tree.recordName],'opt');
%update the pathRoot in player_template;
opt.player_template.path =[option.pathRoot,option.tree.caseLocation];
opt.player_template.sam.path =[option.pathRoot,option.tree.caseLocation];
opt.option = option;
opt.record = [option.pathRoot,option.tree.caseLocation,'Record',option.tree.recordName];
y = opt;
end

