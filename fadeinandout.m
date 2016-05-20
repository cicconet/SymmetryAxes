function J = fadeinandout(I,fadelength)

n = fadelength;
J = I;
for i = 0:n-1
    J(i+1,:) = i/n*J(i+1,:);
    J(size(J,1)-i,:) = i/n*J(size(J,1)-i,:);
    J(:,i+1) = i/n*J(:,i+1);
    J(:,size(J,2)-i) = i/n*J(:,size(J,2)-i);
end

end