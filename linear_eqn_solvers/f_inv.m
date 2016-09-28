function [ x ] = f_inv( A,b )
    
% Filler code - replace with your code
x = zeros(size(A,1),1);

InvA = inv(A);

x = InvA*b;
end

