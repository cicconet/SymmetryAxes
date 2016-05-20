function J = padimage(I,padlength,imtype,padtype)

if strcmp(imtype,'real')
    J = zeros(size(I,1)+2*padlength,size(I,2)+2*padlength);
elseif strcmp(imtype,'complex')
    J = complex(zeros(size(I,1)+2*padlength,size(I,2)+2*padlength));
end
r0 = round(size(J,1)/2-size(I,1)/2);
c0 = round(size(J,2)/2-size(I,2)/2);
J(r0+1:r0+size(I,1),c0+1:c0+size(I,2)) = I;

if strcmp(padtype,'replicate')
    J(r0+1:r0+size(I,1),1:c0) = repmat(J(r0+1:r0+size(I,1),c0+1),[1 c0]);
    J(r0+1:r0+size(I,1),c0+size(I,2)+1:size(J,2)) = repmat(J(r0+1:r0+size(I,1),c0+size(I,2)),[1 c0]);
    
    J(1:r0,:) = repmat(J(r0+1,:),[r0 1]);
    J(r0+size(I,1)+1:size(J,1),:) = repmat(J(r0+size(I,1),:),[r0 1]);
end

end