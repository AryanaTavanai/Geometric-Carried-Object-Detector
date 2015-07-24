function ContrastMeasure= GetContrastMeasure(im,x1,x2,y1,y2)

mE = (y2 - y1)/(x1-x2);

if mE==-inf
    mE=10000000;
    
elseif mE==inf
    mE=-10000000;
end

cE = y2-mE*x1;

c1E= cE-6;
c2E= cE+6;

winSize = 4;
if x2~=x1 && mE>-3 && mE<3
    y1c1 = mE*x1+c1E;
    y2c1 = mE*x2+c1E;
    y1c2 = mE*x1+c2E;
    y2c2 = mE*x2+c2E;
    [~,BW] = roifill(double(rgb2gray(im)),[x1 x2  x2 x1],[y2c1-3 y1c1-3 y1c2+3 y2c2+3]);
else 
    y1c1 = y1;
    y2c1 = y2;
    y1c2 = y1;
    y2c2 = y2;
    [~,BW] = roifill(double(rgb2gray(im)),[x1-winSize x2-winSize  x2+winSize x1+winSize],[y1c1 y2c1 y2c2 y1c2]);
end

%             indBW = BW==1;
im1 = im(:,:,1);RGBValues(:,1) = im1(BW==1);
im2 = im(:,:,2);RGBValues(:,2) = im2(BW==1);
im3 = im(:,:,3);RGBValues(:,3) = im3(BW==1);

ContrastMeasure = norm(std(double(RGBValues)));

end
