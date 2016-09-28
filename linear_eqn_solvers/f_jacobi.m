function [x] = f_jacobi(A,b,nIter,x0)

% Filler code - replace with your code
x = zeros(size(A,1),1);
D = zeros(size(A));
E = zeros(size(A));

% Construct D and E
for i = 1:size(A, 1)
    for j = 1:size(A, 2)
        D(i, i) = A(i, i); 
        if (i ~= j)
            E(i, j) = A(i, j);
        end
    end
end

% Initialize x
x = x0;

for i = 1:nIter
    x = -inv(D)*(E)*x + inv(D)*b;
end

end