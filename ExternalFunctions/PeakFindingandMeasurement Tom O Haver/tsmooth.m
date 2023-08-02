function s=tsmooth(Y,w)

%  T. C. O'Haver, 1988.

S=conv(Y,v);
startpoint=(length(v) + 1)/2;
endpoint=length(Y)+startpoint-1;
s=S(startpoint:endpoint) ./ sum(v);