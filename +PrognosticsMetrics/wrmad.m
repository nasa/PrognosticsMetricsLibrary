function m = wrmad(X,w)
% wrmad(X)
%	Computes relative mean absolute deviation of X (expressed as a
%	percentage).
%	X should be (nx x n) and w should be (n x 1). If X is a vector, then 
%	X and w may be either row or column vectors.

% make sure that if X is a vector, then both X and w are column vectors
if size(X,2)==1
	% then X is a row vector, make it a column vector
	X = X';
end
if size(w,2)==1
	% then w is a row vector, make it a column vector
	w = w';
end

import PrognosticsMetrics.*

wAD = abs(X-wmean(X,w))*w';
m = 100*wAD/wmean(X,w);
