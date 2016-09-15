function A = f_main_symaxes(I,accwidth,sigma,outerangles,innerangles,inndstres,innerdistsfactors,sqvotes)

% I should be double, in [0,1]
freq = 1/sigma;

maxdim = max(size(I));

innerdists = innerdistsfactors(1)*maxdim:inndstres:innerdistsfactors(2)*maxdim;

padlength = round(innerdists(end)/3);
I = fadeinandout(I,20);
I0 = I;
I = padimage(I,padlength,'real','');

accheight = length(outerangles);
A = zeros(accheight,accwidth);

[Unique0piAngles,UniqueAngIndices,UniqueAngSigns] = uniqueangles(outerangles,innerangles);
UniqueConvs = complex(zeros(size(I,1),size(I,2),length(Unique0piAngles)));
for i = 1:length(Unique0piAngles)
    [mr,mi] = cmorlet(sigma,freq,Unique0piAngles(i),0);
    UniqueConvs(:,:,i) = padimage(conv2(I0,mr+1i*mi,'same'),padlength,'complex','');
end

% X: lines, Y: columns
[Y,X] = meshgrid(1:size(I0,2),1:size(I0,1));
for oai = 1:length(outerangles)
%     fprintf('.');
    AccOut = complex(zeros(size(I)));
    outerangle = outerangles(oai);
    for idi = 1:length(innerdists)
        innerdist = innerdists(idi);
        for iai = 1:length(innerangles)
            if UniqueAngSigns(oai,iai,1) == 1
                Conv1 = UniqueConvs(:,:,UniqueAngIndices(oai,iai,1));
            else
                Conv1 = conj(UniqueConvs(:,:,UniqueAngIndices(oai,iai,1)));
            end
            if UniqueAngSigns(oai,iai,2) == 1
                Conv2 = UniqueConvs(:,:,UniqueAngIndices(oai,iai,2));
            else
                Conv2 = conj(UniqueConvs(:,:,UniqueAngIndices(oai,iai,2)));
            end
            
%             [Out,Out1,Out2] = symconv(Conv1,Conv2,sigma,outerangle,innerdist);
%             displaystep(I,Out,Out1,Out2,outerangle,innerdist,innerangles(iai));
%             Kernel = symconvkernel(I,sigma,freq,outerangle,innerangles(iai),innerdist);
%             imshow(Kernel), pause

            [Out,~,~] = symconv(Conv1,Conv2,sigma,outerangle,innerdist);
            AccOut = AccOut+Out;
        end
    end

    if sqvotes
        T = AccOut.*conj(AccOut);
    else
        T = abs(AccOut);
    end
    T = T(padlength+1:padlength+size(I0,1),padlength+1:padlength+size(I0,2));
    
    LocDispl = locdispl(outerangle,X,Y,accwidth);
    for i = 1:size(T,1)
        for j = 1:size(T,2)
            c0 = round(LocDispl(i,j));
            c1 = c0+sign(LocDispl(i,j)-c0);
            f1 = abs(LocDispl(i,j)-c0);
            f0 = 1-f1;
            c01 = [c0 c1];
            f01 = [f0 f1];
            for k = 1:2
                c = max(min(c01(k),accwidth),1);
                A(oai,c) = A(oai,c)+f01(k)*T(i,j);
            end
        end
    end
end
% fprintf('\n');

for i = 1:size(A,1)
    A(i,:) = smooth(A(i,:));
end

A = normalize(A);

end