function [angle,displ,cnfdc,iangle,idispl] = locmaxacc2(A,outerangles,accwidth,nlocmax,proxthr)

angle = zeros(1,nlocmax);
displ = zeros(1,nlocmax);
cnfdc = zeros(1,nlocmax);
iangle = zeros(1,nlocmax);
idispl = zeros(1,nlocmax);

A0 = A;
% pA0 = A0;

for i = 1:nlocmax
    [m,im] = max(A0,[],2);
    [m2,im2] = max(m);
    
    a = outerangles(im2)+pi/2;
    if a > pi
        a = a-pi;
    end
    d = im(im2)-accwidth/2;
    
    angle(i) = a;
    displ(i) = d;
    
    iangle(i) = im2;
    idispl(i) = im(im2);
    
    cnfdc(i) = m2;
    
    A0(im2,im(im2)-proxthr:im(im2)+proxthr) = 0;
    
%     imshow([pA0; A0])
%     pause
    
%     pA0 = A0;
end



end