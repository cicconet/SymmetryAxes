% -------------------------
% load image
% -------------------------
imindex = 4; % 1:7
I = imread(sprintf('Images/Im%d.png',imindex));

% -------------------------
% set parameters
% -------------------------
sigma = 1; % scale
innerangles = [-pi/4 0 pi/4]; % inner angles, measured according to stencil
inndstres = 3; % inner distance resolution
innerdistsfactors = [0 0.5]; % controls length of stencil
proxthr = 10; % for local maxima location
noutputs = 5; % number of outputs
res = 32; % resolution of angles of stencil
outerangles = 0:pi/res:pi-pi/res; % should be in [0,pi); symmetry is this angle + pi/2

% -------------------------
% find symmetry axes
% -------------------------
[I2,A2,padlength,angle,displ,cnfdc] = f_main_symaxes(...
    I,sigma,outerangles,innerangles,inndstres,innerdistsfactors,noutputs,proxthr);

% -------------------------
% display lines
% -------------------------
imshow(A2), title('voting space')
J = repmat(0.75*I2,[1 1 3]);
for i = 1:length(angle)
    [J,p0] = paintline(J,angle(i),displ(i),[0 0 cnfdc(i)]);
end
figure
imshow(J), title('output')