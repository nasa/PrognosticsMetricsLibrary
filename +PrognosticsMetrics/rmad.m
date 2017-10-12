function m = rmad(X,opt)
% rmad(X,opt)
%	Computes relative mean/median absolute deviation of X (expressed as a
%	percentage).
%	Absolute deviation is computed using median as location of central
%	tendency.
%	opt is an optional string argument specifying whether to take mean 
%	absolute deviation (opt='mean', default) or median absolute devaition
%	(opt='median').

if nargin<2
	opt = 'mean';
end

AD = abs(X-median(X));

switch opt
	case 'mean'
		m = 100*mean(AD)/mean(X); %?
	case 'median'
		m = 100*median(AD)/median(X);
	otherwise
		error('Bad value of opt. Must be ''mean'' or ''median''');
end