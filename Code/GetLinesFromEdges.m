function [seglist,im_crop_size,im_crop_orig_real,im_crop_carried_object_image] = GetLinesFromEdges(Img,rect,foreground_mask,carried_object_mask,person_filter_mask)
% global DisplayTag;
global param;
global EdgeEnhance;
global DisplayTag;
global DisplayTagGlobal;

im_crop = imcrop(Img,rect);im_crop_orig_real = im_crop;im_crop_orig = rgb2gray(im_crop);im_crop1 = rgb2gray(im_crop);
im_crop_size = size(im_crop);

%% Removing pixels below a color threshold. 
% [bins, X]  =  hist(reshape(double(im_crop1),size(im_crop1,1)*size(im_crop1,2),1),20);
% ind1 = find(X<30); ind2 = find(X>=120); bins([ind1 ind2]) =0; X([ind1 ind2]) = 0; [~,ind_grad] = max(bins); 
% 
% if ind_grad==1
%     if X(ind_grad)==0 
%         ColThresh = 110; 
%     else
%         ColThresh = X(ind_grad);
%     end
% else
%     ColThresh = X(ind_grad-1);
% end
% im_crop1(im_crop1<=ColThresh)=1; im_crop1(im_crop1>ColThresh)=0;
Img = double(rgb2gray(Img));



%% Morphological operations
% im = imfill(im_crop1,'holes');se = strel('line',10,135);im1 = imdilate(im,se);im1 = imerode(im1,se);im1 = imopen(im1,se);se = strel('line',10,45);im2 = imdilate(im,se);im2 = imerode(im2,se);im2 = imopen(im2,se);im = im1 + im2;im(im>=1)=1;

%% foreground
im_crop_motion = imcrop(foreground_mask,rect);
im_person_filter_mask = imcrop(person_filter_mask,rect);

%% carried object
im_crop_carried_object_image = imcrop(carried_object_mask,rect);
se = strel('disk',10);im_crop_motion = imdilate(im_crop_motion,se);

%% Edge enhancement (not included in this demo)
% im_crop_Enhance = EdgeEnhance.image;
im_crop_Enhance = imcrop(Img,rect);

edgeim = edge(im_crop_Enhance,'canny',.1);

%% Remove edge regions
edgeim(im_crop_motion==0)=0;
edgeim(im_person_filter_mask==1)=0;
edgeim([1:5 size(edgeim,1)-5:size(edgeim,1)],:)=0;
edgeim(:,[1:5 size(edgeim,2)-5:size(edgeim,2)])=0;

%% Perform edgelinking and get linesegments
[edgelist,~] = edgelink(edgeim, 10);
tol = param.tol;
seglist = lineseg(edgelist, tol);

%% For overlaying 
%     subplot(1,2,2);
rgb = im_crop_orig_real;rgb1 = rgb(:,:,1);rgb2 = rgb(:,:,2);rgb3 = rgb(:,:,3);rgb1(im_crop_carried_object_image==1)=1;rgb3(im_crop_carried_object_image==1)=1;rgbnew(:,:,1) = rgb1;rgbnew(:,:,2) = rgb2;rgbnew(:,:,3) = rgb3;
rgb = imoverlay(rgbnew, edgeim, [0 1 0]);

if DisplayTag && DisplayTagGlobal 
    imshow(rgb);
end
   
end









