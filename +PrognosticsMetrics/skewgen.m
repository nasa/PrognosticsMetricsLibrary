function n = skewgen(mu,var,skew,N)

scale = sqrt(var);

sigma = skew/sqrt(1+skew^2);

r = randn(2*N,1);

u0 = r(1:N);
v = r(N+1:2*N);

u1 = sigma*u0 + sqrt(1-sigma^2)*v;
u1 = sign(u0).*u1*scale + mu;

n = u1;

% correcting the mean... not sure about this part
n = n + (mu-mean(n));
% n = n + (mu-median(n));