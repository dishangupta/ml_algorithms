% Plots the 3D error surface and arrows in the
% direction of steepest descent on it for 3 points
% Input: Labels (Y) = {1,-1}, Data(X) 
% Output: Error surface plot with gradient 

function [] = ErrorSurface(Y, X)

% Error function = (1/2)*sum(t_d -o_d)^2

d = size(X, 1); % # data points
X = [ones(d, 1) X]; % append 1 for bias

[w1 w2] = meshgrid(-1:0.01:1);
E = zeros(size(w1));

% Compute error at different weights 
for i = 1:size(w1, 1)
    i
    for j = 1:size(w2, 2)
    
    w = [1; w1(i, j); w2(i, j)];  
        
    O = repmat(w', d , 1).*X;
    O = sum(O, 2);
      
    E(i, j) = (1/2)*sum((Y-O).^2);
    
    end
end

assignin('base', 'E', E);
%plot(W(end, :), E);
surf(w1(1,:), w2(:, 1), E);

