% This function computes the classification error
% Input: Y, W, X
% Output: Percentage classfication error

function [ pct_err ] = ClassificationError( Y, W, X )

d = size(X, 1);

% Check if 1 is appended
if (size(W, 1) > size(X, 2))
    X = [ones(d, 1) X];
end

O = repmat(W', d , 1).*X;
O = sum(O, 2);
O(find(O > 0)) = 1;
O(find(O <= 0)) = -1;

pct_err = Y-O ;
pct_err = abs(pct_err);
pct_err = (1/d)*(1/2)*sum(pct_err, 1);

end

