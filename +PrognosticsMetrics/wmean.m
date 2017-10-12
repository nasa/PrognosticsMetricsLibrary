function mX = wmean(X,w)
% Compute weighted mean of matrix X with weights w. X should be (nx x n)
% and w should be a vector.

% make sure that if X is a vector, then both X and w are column vectors
if size(X,2)==1
	% then X is a column vector, make it a row vector (for the
	% multiplication)
	X = X';
end
if size(w,1)==1
	% then w is a row vector, make it a column vector
	w = w';
end

mX = X*w;