function [ w ] = weightsP( XTrain, yTrain, nIter)

%filler code - replace with your code
nTrain = size(XTrain,1);
nFeat = size(XTrain,2);
w = zeros(nFeat,1);

ui = zeros(nFeat, 1);
result = 0;

for j = 1:nIter
	for i = 1:nTrain 
		ui = (yTrain(i) * XTrain(i, :))';
		result = sum(ui.*w);
		if(result > 0)
			continue;
		else
			w = ui + w;
	end		
end

end



