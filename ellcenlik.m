function A = ellcenlik(I,sigma,outerangles,innerangles,inndstres,innerdistrange)

% I should be double, in [0,1]
freq = 1/sigma;

innerdists = innerdistrange(1):inndstres:innerdistrange(2);

padlength = round(innerdists(end));
I0 = I;
I = padimage(I,padlength,'real','');

[Unique0piAngles,UniqueAngIndices,UniqueAngSigns] = uniqueangles(outerangles,innerangles);
UniqueConvs = complex(zeros(size(I,1),size(I,2),length(Unique0piAngles)));
for i = 1:length(Unique0piAngles)
    [mr,mi] = cmorlet(sigma,freq,Unique0piAngles(i),0);
    UniqueConvs(:,:,i) = padimage(conv2(I0,mr+1i*mi,'same'),padlength,'complex','');
end

A = zeros(size(I0));
for oai = 1:length(outerangles)
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

            [Out,~,~] = symconv(Conv1,Conv2,sigma,outerangle,innerdist);
            AccOut = AccOut+Out;
        end
    end

    T = AccOut.*conj(AccOut);
    A = A+T(padlength+1:padlength+size(I0,1),padlength+1:padlength+size(I0,2));
end

A = normalize(A);

end