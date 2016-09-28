function [x] = f_steepest(A,b,x0,nIter)

% Filler code - replace with your code
x = zeros(size(A,1),1);

% Initialize x
x = x0;

for i = 1:nIter
    alpha = - (((A*x - b)')*(A*x - b))/(((A*x - b)')*(A)*(A*x - b)) ;
    x = x + alpha*(A*x - b);
end

end