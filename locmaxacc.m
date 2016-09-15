function [angle,displ,iangle,idispl] = locmaxacc(A,outerangles,accwidth,nlocmax,angproxthr,dispproxthr)

% ag = [];
% dp = [];
% ia = [];
% id = [];
% pk = [];
% 
% for i = 1:size(A,1)
%     r = A(i,:);
%     [pks,lcs] = findpeaks(r);
%     
% %     plot(r), hold on
% %     plot(lcs,pks,'o'), hold off
% %     pause
%     
%     a = outerangles(i)+pi/2;
%     if a > pi
%         a = a-pi;
%     end
%     for j = 1:length(lcs)
%         d = lcs(j)-accwidth/2;
%         ag = [ag a];
%         dp = [dp d];
%         ia = [ia i];
%         id = [id lcs(j)];
%         pk = [pk pks(j)];
%     end
% end
% 
% [~,i] = sort(pk,'descend');
% ag = ag(i);
% dp = dp(i);
% ia = ia(i);
% id = id(i);
% angle = ag(1:nlocmax);
% displ = dp(1:nlocmax);
% iangle = ia(1:nlocmax);
% idispl = id(1:nlocmax);


angle = zeros(1,nlocmax);
displ = zeros(1,nlocmax);
iangle = zeros(1,nlocmax);
idispl = zeros(1,nlocmax);

A0 = A;

for i = 1:nlocmax
    [m,im] = max(A0,[],2);
    [~,im2] = max(m);
    
    a = outerangles(im2)+pi/2;
    if a > pi
        a = a-pi;
    end
    d = im(im2)-accwidth/2;
    
    angle(i) = a;
    displ(i) = d;
    
    iangle(i) = im2;
    idispl(i) = im(im2);
    
%     A0(im2,im(im2)-proxthr:im(im2)+proxthr) = 0;
    a0 = max(im2-angproxthr,1);
    a1 = min(im2+angproxthr,size(A0,1));
    A0(a0:a1,im(im2)-dispproxthr:im(im2)+dispproxthr) = 0;
    
%     imshow(A0)
%     pause
end

end