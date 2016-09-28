function [ ] = Bounds( )


n = 1:100;

%Bounds
markov = 2/5 ;
chebyshev = 16./(9.*n);
hoeffeding = 2*exp(-n.*(9/50));

%True Binomial Probability
binProb = 1 - binocdf(floor(0.5.*n-0.5), n, 0.2);

plot(n, markov,'-', n, chebyshev,'r--', n, hoeffeding, 'b:', n, binProb, 'g-');

xlabel('n');
ylabel('Probability Bounds');



end

