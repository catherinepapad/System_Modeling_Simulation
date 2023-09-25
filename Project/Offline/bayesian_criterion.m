function BIC = bayesian_criterion(y,y_est,N,p)
%implementetion of bayesian information criterion

I = 0;
for j=1:1:N
    I = I + (y(j)-y_est(j))^2;
end
I_norm = I / N;

BIC = N*log(I_norm) + log(N)*p;

end