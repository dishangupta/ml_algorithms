% The Delta Rule
% Input: Labels (Y) = {1,-1}, Data(X) 
% Output: Weights (W) after training


function [ W ] = DeltaRule(Y, X)
%   W = W + deltaW
%   deltaW_i = eta*\sum_{d}(t_d - o_d)*x_(id)

d = size(X, 1); % # data points
X = [ones(d, 1) X]; % append 1 for bias

n = size(X, 2); % dimensionality (add 1 for bias)
W = zeros(n, 1); % initialize weights to zero
W_old = -Inf*ones(n, 1); % to store previous iter weights

eta = 0.0001; % learning rate
eps = 0.001; % convergence criteria
maxIter = 1000000;

for iter = 1:maxIter

    O = repmat(W', d , 1).*X;
    O = sum(O, 2);
    
    E = (Y - O);
    E = repmat(E, 1, n);
    delE = sum(E.*X, 1);

    W = W + eta*(delE)';
    
    if (sum(abs(W-W_old)) < eps)
        break;
    end
           
    W_old = W;
    
end

iter
ClassificationError(Y, W, X)

% Plot hypothesis
hypothesisPlot(Y, X(:, 2:end), W);

end

