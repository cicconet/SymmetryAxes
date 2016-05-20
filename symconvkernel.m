function Kernel = symconvkernel(Input,sigma,freq,outerangle,innerangle,innerdist)

[K1r,K1i] = cmorlet(sigma,freq,outerangle+innerangle,0);
[K2r,K2i] = cmorlet(sigma,freq,outerangle-innerangle+pi,0);
K1 = K1r+1i*K1i;
K2 = K2r+1i*K2i;

O1 = conv2(Input,K1,'same');
O2 = conv2(Input,K2,'same');
% O1 = O1.*(O1 > 0);
% O2 = O2.*(O2 > 0);

O1T = normalize(O1.*conj(O1));
O2T = normalize(O2.*conj(O2));

support = 2.5*sigma; % same as in cmorlet.m
r = round(innerdist/2+support);

% visualize kernel
Kernel1 = zeros(2*r,2*r);
Kernel2 = zeros(2*r,2*r);
row = round(r+innerdist/2*cos(outerangle)-size(K1,1)/2);
col = round(r+innerdist/2*sin(outerangle)-size(K1,2)/2);
row = min(max(row,0),2*r-size(K1,1));
col = min(max(col,0),2*r-size(K1,2));
Kernel1(row+1:row+size(K1,1),col+1:col+size(K1,2)) = K1i;%.*conj(K1);
row = round(r+innerdist/2*cos(outerangle+pi)-size(K2,1)/2);
col = round(r+innerdist/2*sin(outerangle+pi)-size(K2,2)/2);
row = min(max(row,0),2*r-size(K2,1));
col = min(max(col,0),2*r-size(K2,2));
Kernel2(row+1:row+size(K2,1),col+1:col+size(K2,2)) = K2i;%.*conj(K2);
Kernel = normalize(Kernel1+Kernel2);

end