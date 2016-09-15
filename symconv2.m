function [Out,Out1,Out2] = symconv2(Conv1,Conv2,sigma,outerangle,innerdist)

O1T = Conv1;
O2T = Conv2;

support = 2.5*sigma; % same as in cmorlet.m
r = round(innerdist/2+support);

[nr,nc] = size(Conv1);

% domain for kernel 1
r0 = max(round(r+r*cos(outerangle)),1);
c0 = max(round(r+r*sin(outerangle)),1);
r1 = r0+nr-2*r;
c1 = c0+nc-2*r;

O1 = Conv1(r0:r1,c0:c1);
Out1 = zeros(nr,nc);
Out1(r0:r1,c0:c1) = O1T(r0:r1,c0:c1);

% domain for kernel 2
r0 = max(round(r+r*cos(outerangle+pi)),1);
c0 = max(round(r+r*sin(outerangle+pi)),1);
r1 = r0+nr-2*r;
c1 = c0+nc-2*r;

O2 = Conv2(r0:r1,c0:c1);
Out2 = zeros(nr,nc);
Out2(r0:r1,c0:c1) = O2T(r0:r1,c0:c1);

O12 = exp(-(O1-O2).^2);
% O12 = conv2(O12,qkernel,'same');
% imshow(normalize(abs(O12)))
% pause

% CO12 = conv2(O12,qkernel,'same');
% imshow([normalize(abs(O12)) normalize(abs(CO12))])
% pause

Out = zeros(nr,nc);
Out(r:nr-r,r:nc-r) = O12;


end