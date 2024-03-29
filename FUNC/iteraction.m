%2021-4-19
%calculate the interaction degrees between all variables
%based on the Kriging surrogate
function [y] = iteraction(mod,boundary)
num = 10000;
h = 0.0001;

lower = boundary(:,1)';
upper = boundary(:,2)';


sam = mod.getSamples();
inDim = size(sam,2);%the dimension of surrogate
design = lhsdesign(num,inDim);
design = design.*(upper - lower)+lower;

%prepare for all the sample data
%sample with 2 variables %num*dim*(dim-1)/2
resultBox= zeros(inDim,inDim-1);
sampleBox2 = cell(inDim,inDim-1);
for i = 2:inDim
for j = 1:i-1
sam = design;
sam(:,i) = sam(:,i)+h;
sam(:,j) = sam(:,j)+h;
sampleBox2{i,j} = mod.predict(sam);
end
end
%sample with 1 variable %num*dim
sampleBox1 = cell(inDim,1);
for i = 1:inDim
sam= design;
sam(:,i) = sam(:,i)+h;
sampleBox1{i,1} = mod.predict(sam);
end
%sample without perturbation %num
sampleBox0 = cell(1,1);
sam = design;
sampleBox0{1,1} = mod.predict(sam);

%calculate the Hij value
for i = 2:inDim
for j = 1:i-1
temp = sampleBox2{i,j} - sampleBox1{i,1} - sampleBox1{j,1} + sampleBox0{1,1};
resultBox(i,j) = sum(temp);
end
end

y = resultBox/(max(sampleBox0{1,1})-min(sampleBox0{1,1}))/num/h/h;
end