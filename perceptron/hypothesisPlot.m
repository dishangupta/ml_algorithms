% Function that plots the hypothesis/data points
%  Input: Labels (Y) = {1,-1}, Data(X), Weights (W) 
% Output: Scatter plot with hypothesis

function [] = hypothesisPlot( Y, X, W )

% y = mx + c
m = -W(2)/W(3); % slope of hypthosis
c = -W(1)/W(3); % intercept of hypothesis

Xhyp = [0,-c/m]; % X intercept 
Yhyp = [c,0];    % Y intercept

figure;
gscatter(X(:,1),X(:,2), Y)
hold on
line(Xhyp,Yhyp, 'LineWidth', 2);
xlabel('X1');
ylabel('X2');


end

