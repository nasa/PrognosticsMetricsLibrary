function skew = wskew(x,w)
% Compute weighted skew of vector x with weights w.
% I don't know if there is a real weighted skew formula or not.

import PrognosticsMetrics.*;

mx = wmean(x,w);

m2 = 0;
m3 = 0;
for i=1:length(x)
	m2 = m2 + w(i)*(x(i)-mx)^2;
	m3 = m3 + w(i)*(x(i)-mx)^3;
end

skew = m3/(m2^(3/2));
