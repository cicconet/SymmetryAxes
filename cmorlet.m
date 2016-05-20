function [mr,mi] = cmorlet(sigma,freq,angle,halfkernel)

% ref: http://arxiv.org/pdf/1203.1513.pdf, page 2

support = 2.5*sigma;

xmin = -support;
xmax = -xmin;
ymin = xmin;
ymax = xmax;
xdomain = xmin:xmax;
ydomain = ymin:ymax;

[x,y] = meshgrid(xdomain,ydomain);

xi = freq*[sin(angle); cos(angle)];

envelope = exp(-0.5*(x.*x+y.*y)/sigma^2); 
carrier = exp(1i*(xi(1)*x+xi(2)*y));

% makes sum of args = 0
C2 = sum(sum(envelope.*carrier))/sum(sum(envelope));

% makes sum of args*conj(args) = 1
arg = (carrier-C2).*envelope;
normfact = sum(sum(arg.*conj(arg)));
C1 = sqrt(1/normfact);

psi = C1*(carrier-C2).*envelope;

if halfkernel
    condition = ((xi(1)*x+xi(2)*y) <= 0);
    mr = real(psi).*condition;
    mi = imag(psi).*condition;
else
    mr = real(psi);
    mi = imag(psi);
end

end