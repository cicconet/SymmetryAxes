function displaystep(I,Out,Out1,Out2,outerangle,innerdist,innerangle)

imshow([normalize(I) 0.5*ones(size(I,1),5) normalize(Out.*conj(Out)) 0.5*ones(size(I,1),5) Out1 0.5*ones(size(I,1),5) Out2])
title(sprintf('outerangle: %f, innerdist: %f, innerangle: %f', outerangle, innerdist, innerangle));        
pause

end