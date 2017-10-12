function Pxx = wcov(X,w,alpha,beta)
% Pxx = wcov(X,w,alpha,beta)
% weighted covariance calculation
% if alpha/beta are given, then the data is assumed to be sigma points, and the
% 1/(1-sum(w.^2)) factor will not be applied.
% 
% X should be (nx x n) and w should be (n x 1). If X is a vector, 
% then X and w may be either row or column vectors.

% make sure that if X is a vector, then both X and w are row vectors
if size(X,2)==1
	% then X is a column vector, make it a row vector
	X = X';
end
if size(w,2)==1
	% then w is a column vector, make it a row vector
	w = w';
end

import PrognosticsMetrics.*

mX = wmean(X,w);
Pxx = 0;
for i=1:size(X,2)
	Pxx = Pxx + w(i)*(X(:,i)-mX)*(X(:,i)-mX)';
end

if nargin<3
	Pxx = Pxx/(1-sum(w.^2));
else
	Pxx = Pxx + (1-alpha^2+beta)*(X(:,1)-mX)*(X(:,1)-mX)';
end
