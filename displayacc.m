function A2 = displayacc(A,iangle,idispl)

n = 10;
A2 = zeros(n*size(A,1),size(A,2));
for i = 1:size(A,1)
    A2((i-1)*n+1:i*n,:) = repmat(A(i,:),[n 1]);
end

A2 = repmat(A2,[1 1 3]);

if ~isempty(iangle)
    for i = 1:length(iangle)
        A2([(iangle(i)-1)*n+1 iangle(i)*n],idispl(i)-5:idispl(i)+5,1:2) = 1;
        A2([(iangle(i)-1)*n+1 iangle(i)*n],idispl(i)-5:idispl(i)+5,3) = 0;
    end
end

end