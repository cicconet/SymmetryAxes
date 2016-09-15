I = normalize(double(imread('Images/Cells.png')));
I = imresize(I,0.5);
I = adapthisteq(I);

sigma = 3; % scale
innerangles = 0;%[-pi/4 0 pi/4]; % inner angles, measured according to stencil
inndstres = 5; % inner distance resolution
innerdistrange = [70 90]; % controls length of stencil
res = 32; % resolution of angles of stencil
outerangles = 0:pi/res:pi-pi/res; % should be in [0,pi)

A = ellcenlik(I,sigma,outerangles,innerangles,inndstres,innerdistrange);
A = normalize(imfilter(A,fspecial('gaussian',[8 8],2)));

bw = imregionalmax(A).*(A > 0.5);

imshow([I A bw])