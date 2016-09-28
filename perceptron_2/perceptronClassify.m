function [ c ] = perceptronClassify( XTest, w)

%filler code - replace with your code
c = ones(size(XTest,1),1);
nTest = size(XTest,1);

for i = 1:nTest
	if(sum((XTest(i,:)').*w) > 0)
		c(i) = 1;
	else
		c(i) = -1;
end

end

