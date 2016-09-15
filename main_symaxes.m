% -------------------------
% load image
% -------------------------
I = double(imread('Images/Im4.png'))/255;
% imshow(I), size(I), max2(I), pause
if size(I,3) > 1
    I = double(rgb2gray(I));
else
    I = double(I);
end

% -------------------------
% set parameters
% -------------------------
sigma = 2; % scale
innerangles = [-pi/4 0 pi/4]; % inner angles, measured according to stencil
inndstres = 3; % inner distance resolution
innerdistsfactors = [0 0.5]; % controls length of stencil
angproxthr = 0; % actuall value is this times pi/res
dispproxthr = 10; % for local maxima location
res = 32; % resolution of angles of stencil
outerangles = 0:pi/res:pi-pi/res; % should be in [0,pi); symmetry is this angle + pi/2
noutputs = 5;
sqvotes = 1;

% -------------------------
% find symmetry axes
% -------------------------
accwidth = 2*round(sqrt(size(I,1)^2+size(I,2)^2));
A = f_main_symaxes(I,accwidth,sigma,outerangles,innerangles,inndstres,innerdistsfactors,sqvotes);

[angle,displ,iangle,idispl] = locmaxacc(A,outerangles,accwidth,noutputs,angproxthr,dispproxthr);

A2 = locmaxonacc(A,iangle,idispl,[],[],dispproxthr);

% -------------------------
% display lines
% -------------------------
imshow(A2), title('voting space')

[h,s,v] = hsv(length(angle));
J = 0.75*repmat(I,[1 1 3]);
midpoint = zeros(length(angle),2);
seglen = zeros(1,length(angle));
for i = 1:length(angle)
    [J,midpoint(i,:)] = paintline(J,angle(i),displ(i),hsv2rgb([h(i) s(i) v(i)]));
end

% -------------------------
% find end poitns
% -------------------------
K = 0.75*repmat(I,[1 1 3]);
proxs = zeros(1,length(angle));
for i = 1:length(angle)
    [midpoint(i,:),seglen(i),proxs(i)] = f_endpoints(I,sigma,angle(i),midpoint(i,:),'run');
    K = paintsegment(K,midpoint(i,:),angle(i),seglen(i),hsv2rgb([h(i) s(i) v(i)]));
end

% -------------------------
% show results
% -------------------------
figure
subplot(1,2,1)
imshow(J), title('lines')
subplot(1,2,2)
imshow(K), title('segments')