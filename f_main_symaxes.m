function [I,A2,padlength,angle,displ,cnfdc] = f_main_symaxes(I,sigma,outerangles,innerangles,inndstres,innerdistsfactors,noutputs,proxthr)

% I should be double, in [0,1]
if size(I,3) > 1
    I = double(rgb2gray(I))/255;
else
    I = double(I)/255;
end
freq = 1/sigma;

maxdim = max(size(I));

innerdists = innerdistsfactors(1)*maxdim:inndstres:innerdistsfactors(2)*maxdim;

padlength = round(innerdists(end)/3);
I = fadeinandout(I,20);
I0 = I;
I = padimage(I,padlength,'real','');

accwidth = 2*round(sqrt(size(I,1)^2+size(I,2)^2)); % displacement
accheight = length(outerangles); % angle
A = zeros(accheight,accwidth);

[Unique0piAngles,UniqueAngIndices,UniqueAngSigns] = uniqueangles(outerangles,innerangles);
UniqueConvs = complex(zeros(size(I,1),size(I,2),length(Unique0piAngles)));
for i = 1:length(Unique0piAngles)
    [mr,mi] = cmorlet(sigma,freq,Unique0piAngles(i),0);
    UniqueConvs(:,:,i) = padimage(conv2(I0,mr+1i*mi,'same'),padlength,'complex','');
end

% X: lines, Y: columns
[Y,X] = meshgrid(1:size(I,2),1:size(I,1));
h = waitbar(0,'computing...');
for oai = 1:length(outerangles)
    waitbar(oai/length(outerangles),h,'computing...')
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

    T = AccOut.*conj(AccOut);
    
    AStep = zeros(size(A));
    
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
                AStep(oai,c) = AStep(oai,c)+f01(k)*T(i,j);
            end
        end
    end
    
    A = A+AStep;
end
close(h)

for i = 1:size(A,1)
    A(i,:) = smooth(A(i,:));
end

A = normalize(A);
[angle,displ,cnfdc,iangle,idispl] = locmaxacc(A,outerangles,accwidth,noutputs,proxthr);

A2 = displayacc(A,iangle,idispl);

end