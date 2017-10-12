function [C,Cx,Cy] = convergence(t,M)
% C = convergence(t,M)
%	C is convergence metric
%	Cx,Cy are coordinates of centroid
%	t is time points
%	M is M(t), where M is metric

% note: could make this take function handle M and any additional args it
% needs...


% Compute area
A = 0;
for i=1:length(t)-1
	Ai = (t(i+1)-t(i))*M(i);
	A = A + Ai;
end

% Compute centroid-x
Cx = 0;
for i=1:length(t)-1
	Ai = (t(i+1)-t(i))*M(i);
	Cxi = t(i)+(t(i+1)-t(i))/2;
	Cx = Cx + Cxi*Ai;
end
Cx = Cx/A;

% Compute centroid-y
Cy = 0;
for i=1:length(t)-1
	Ai = (t(i+1)-t(i))*M(i);
	Cyi = M(i)/2;
	Cy = Cy + Cyi*Ai;
end
Cy = Cy/A;

% Compute convergence
C = sqrt((Cx-t(1))^2+Cy^2);




