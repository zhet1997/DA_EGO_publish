function [y] = randomGroup(func_dim, subset)
newSort = randperm(func_dim);
[~,s] = fixGroup(func_dim, subset);
subsetPlayer = mat2cell(newSort,1,s);

y = subsetPlayer; 
end

