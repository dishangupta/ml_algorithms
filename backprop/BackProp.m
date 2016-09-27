% The Backpropagation algorithm for NN training
% Input: Labels (Y) = {1,-1}, Data(X) 
% Output: Weights (W) after training

function [Wji, Wkj] = BackProp (Y, X)

% Data parameters
D = size(X, 1); % # data points
X = [ones(D, 1) X]; % append 1 for bias
N = size(X, 2); % # features

% Construct NN
I = 2; % # neurons in input layer
J = 32; % # neurons in hidden layer
K = 2; % # neurons in output layer

% Initialize weights randomly between 0 and 1
Wji = rand(J, I + 1); % +1 for bias
Wkj = rand(K, J + 1); % +1 for bias

% Store weights for previous iteration
Wji_old = -Inf*ones(J, I + 1); 
Wkj_old = -Inf*ones(K, J + 1); 

% Learning parameters
eta = 0.01; % learning rate
eps = 0.005; % convergence criteria
maxIter = 10000;

for iter = 1:maxIter
    for d = 1:D

        % Peform Feed-Forward Pass
        Zj = Wji*X(d, :)';
        Aj = 1./(1 + exp(-Zj));
        Aj = [1; Aj]; % append 1 for bias
        Zk = Wkj*Aj;
        Yk = 1./(1 + exp(-Zk));


        % Perform error backpropagation 
        T = size(K, 1); % true output desired at output layer 
        if (Y(d) == 1)
            T = [1;0];
        else 
            T = [0;1];
        end

        delK = Yk - T;  
        delJ = Aj.*(1-Aj).*((Wkj)'*delK);

        % Update weights
        Wkj = Wkj - eta*(delK*Aj');
        Wji = Wji - eta*(delJ(2:end)*X(d, :));

    end
    
    sum(sum(abs(Wji - Wji_old))) + sum(sum(abs(Wkj - Wkj_old)))
    % Check convergence
    if (sum(sum(abs(Wji - Wji_old))) + sum(sum(abs(Wkj - Wkj_old))) < eps)
        break;
    end
    
    % Update previous iteration weights
    Wji_old = Wji;
    Wkj_old = Wkj;
    
end

iter

pct_err = ClassificationError(Y, X, Wji, Wkj)

end

