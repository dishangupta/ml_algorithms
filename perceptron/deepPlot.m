function [output_args] = deepPlot( Y, X,W )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here



%W=[-2 0.3794 0.1243];

w0=W(1);
w1=W(2);
w2=W(3);

m=-w1/w2;
c=-w0/w2;
%p1=[0,c];
%p2=[-c/m,0];

Xhyp=[0,-c/m];
Yhyp=[c,0];

d = size(X, 1); % # data points
%bias = ones(d, 1);
output_args=1;
%scatter3(X(:,1),X(:,2),bias,8,Y)

scatter(X(:,1),X(:,2),8,Y)
hold on
line(Xhyp,Yhyp);

%fill3(a,b,[1 10],'r');
%grid on
%alpha(0.3)

%plot(a,b)
end

