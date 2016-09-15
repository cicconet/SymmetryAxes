function [midpointI,seglenI,proximity] = f_endpoints(I,sigma,angleI,midpointI,mode)

[nr,nc] = size(I);

imcent = round([nr nc]/2);
d = imcent-midpointI;
I = imtranslate(I,[d(2) d(1)]);
I = imrotate(I,-180*angleI/pi,'crop');

freq = 1/sigma;
index = 0;
anglerange = [-pi/3 -pi/6 0 pi/6 pi/3];
Convs = complex(zeros(nr,nc,length(anglerange)));
for langle = pi/2+anglerange
    index = index+1;
    [mr,mi] = cmorlet(sigma,freq,langle,0);
    J = conv2(I,mr+1i*mi,'same');
    Convs(:,:,index) = J;
end

hnc = floor(nc/2);
SS = zeros(nr,hnc);
for i = 1:index
   L = Convs(:,1:hnc,i);
   R = Convs(:,end-hnc+1:end,length(anglerange)+1-i);

   R = fliplr(R);
   S = abs(L.*conj(R));

   SS = max(SS,S);
end

proximity = sum(sum(SS)); % proximity between half images

SortS = normalize(sort(SS,2,'descend'));
SortS = SortS(:,1:5);

s = sum(SortS,2);

l = 10;
k1 = [ones(1,l) -ones(1,l)];
s1 = conv(s,k1,'same');
if strcmp(mode,'debug')
    plot(s,'linewidth',2), hold on
    plot(s1,'linewidth',2)
end
[pks,lcs] = findpeaks(s1,'NPeaks',1,'MinPeakHeight',0);
i0 = lcs;
if strcmp(mode,'debug')
    plot(i0,pks,'ok','linewidth',2)
end
[pks,lcs] = findpeaks(-flipud(s1),'NPeaks',1,'MinPeakHeight',0);
i1 = length(s)-lcs+1;
if strcmp(mode,'debug')
    plot(i1,-pks,'ok','linewidth',2), hold off, axis off
end

if strcmp(mode,'debug')
    figure
    imshow([normalize(SS) SortS I])
    pause
    close all
end

ep0 = [i0 round(nc/2)];
ep1 = [i1 round(nc/2)];

R = [cos(angleI) -sin(angleI); sin(angleI) cos(angleI)];
ep0 = round(R*(ep0-imcent)'+imcent'-d');
ep1 = round(R*(ep1-imcent)'+imcent'-d');

midpointI = round(0.5*(ep0+ep1))';
seglenI = norm(ep1-ep0);

end