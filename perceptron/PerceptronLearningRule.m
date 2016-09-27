% Perceptron Learning Rule implementation
% Input: Labels (Y) = {1,-1}, Data(X) 
% Output: Weights (W) after training

function [W] = PerceptronLearningRule(Y, X)
%   W = W + deltaW
%   deltaW = eta(t-o)x

d = size(X, 1); % # data points
X = [ones(d, 1) X]; % append 1 for bias

n = size(X, 2); % dimensionality (add 1 for bias)
W = zeros(n, 1); % initialize weights to zero
W_old = -Inf*ones(n, 1); % to store previous iter weights

eta = 0.001; % learning rate
eps = 0.0001; % convergence criteria
maxIter = 1000000;

for iter = 1:maxIter
    for j = 1:d
        o = (W'*(X(j, :))'); 

        % perceptron output
        if (o > 0)
            o = 1;
        else 
            o = -1;
        end
        
        t = Y(j);

        % weight update
        W = W + eta*(t-o)*(X(j,:)');
        
    end
    
    %ClassificationError(Y, W, X)
       
    if (sum(abs(W-W_old)) < eps)
        break;
    end
    
    W_old = W;
end

iter
% calculate error
ClassificationError(Y, W, X)

% Plot hypothesis
hypothesisPlot(Y, X(:, 2:end), W);
end

