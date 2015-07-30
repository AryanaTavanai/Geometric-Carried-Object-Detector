function [Iseg,Iedge] = ApplyQuickShiftForEdges(I)
global param
% VL_DEMO_QUICKSHIFT  Demo: Quick shift: basic functionality
DisplayTag = 0;

Iseg = zeros(size(I,1),size(I,2));
Iedge = zeros(size(I,1),size(I,2));


ratio = .5;
kernelsize = param.kernelsize;
maxdist = param.maxdist;

ndists = 10;

Iseg = vl_quickseg(I, ratio, kernelsize, maxdist);

if DisplayTag
figure(10) ; clf ;
image(Iseg);
axis equal off tight;
end



Iedge = vl_quickvis(I, ratio, kernelsize, maxdist, ndists);

if DisplayTag
figure(11)
imagesc(Iedge);
axis equal off tight;
colormap gray;
end


disp('')