function A2 = locmaxonacc(A,iangle,idispl,a0,d0,proxthr)

n = 10;
A2 = zeros(n*size(A,1),size(A,2));
for i = 1:size(A,1)
    A2((i-1)*n+1:i*n,:) = repmat(A(i,:),[n 1]);
end

A2 = repmat(A2,[1 1 3]);

[h,s,v] = hsv(length(iangle));
for i = 1:length(iangle)
    rgb = hsv2rgb([h(i) s(i) v(i)]);
    A2([(iangle(i)-1)*n+1 iangle(i)*n],idispl(i)-proxthr:idispl(i)+proxthr,1) = rgb(1);
    A2([(iangle(i)-1)*n+1 iangle(i)*n],idispl(i)-proxthr:idispl(i)+proxthr,2) = rgb(2);
    A2([(iangle(i)-1)*n+1 iangle(i)*n],idispl(i)-proxthr:idispl(i)+proxthr,3) = rgb(3);
end
for i = 1:length(a0)
    A2([(a0(i)-1)*n+1 a0(i)*n],d0(i)-proxthr:2:d0(i)+proxthr,1) = 1;
    A2([(a0(i)-1)*n+1 a0(i)*n],d0(i)-proxthr:2:d0(i)+proxthr,2) = 1;
    A2([(a0(i)-1)*n+1 a0(i)*n],d0(i)-proxthr:2:d0(i)+proxthr,3) = 1;
end

end