function [ w ] = kernelWeights( XTrain, yTrain, nIter, d )

% filler code - replace with your code
nTrain = size(XTrain,1);
w = zeros(nTrain,1);

result = 0;

for j = 1:nIter
	for i = 1:nTrain
		result = yTrain(i)*((w')*(sum((repmat(XTrain(i, :), nTrain, 1).*(XTrain)), 2).^d));
			if(result > 0)
				continue;
			else
				w(i) = w(i) + yTrain(i);
	end
end

end