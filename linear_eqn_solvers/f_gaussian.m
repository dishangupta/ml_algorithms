function [ x, Atri ] = f_gaussian( A,b )

% Filler code - replace with your code
x = zeros(size(A,1),1);
Atri = zeros(size(A));

% Create upper triangle matrix
for i = 1:(size(A,1)-1)
	elim_var = A(i, i);
	mult_factor = A((i+1):end, i)./elim_var;
    mult_factor = repmat(mult_factor, 1, size(A, 2));
    A((i+1):end, :) = A((i+1):end, :) - mult_factor.*(repmat(A(i, :), size(A,1) - i, 1));
    b((i+1):end) = b((i+1):end) - mult_factor(:,1).*repmat(b(i), size(b, 1) - i, 1);
end

A(abs(A)<1e-5) = 0; % Turn really small values to zero
Atri = A;

% Convert to row echelon form
for i = 1:size(A,1)
    Atri(i, :) = Atri(i, :)/A(i, i);
end

% Do back substitution
for j = 0:(size(A,1)-2)
    i = size(A, 1) - j;
	elim_var = A(i, i);
	mult_factor = A(1:(i-1), i)./elim_var;
    mult_factor = repmat(mult_factor, 1, size(A, 2));
    A(1:(i-1), :) = A(1:(i-1), :) - mult_factor.*(repmat(A(i, :), i-1, 1));
    b(1:(i-1)) = b(1:(i-1)) - mult_factor(:,1).*repmat(b(i), i-1, 1);
end

A(abs(A)<1e-5) = 0;

% Compute x
for i = 1:size(A,1)
    b(i) = b(i)/A(i, i);
end

x = b;

end

