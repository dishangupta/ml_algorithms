function [ output_args ] = plotDirection( W )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
output_args=0;
%B=W(:,end-2);
X=W(:,end-1); 
Y=W(:,end) ;
hold on
  for i = 1:2:size(X)    % here we increament to 2 
quiver3(X(i),  Y(i),1, X(i+1), Y(i+1),1);
 hold on
  end
