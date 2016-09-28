function [ c ] = kernelPerceptronClassify( XTrain, XTest, w, d )

% filler code - replace with your code
nTest = size(XTest,1);
nTrain = size(XTrain,1);
c = ones(nTest,1);

result = 0;
for i = 1:nTest
	result = (w')*(sum((XTrain.*(repmat(XTest(i, :), nTrain, 1))), 2).^d);
	if(result > 0)
		c(i) = 1;
	else
		c(i) = -1;
end

end
