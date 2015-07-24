function dres = GetObjectProperties(dres,all_candidate_polygons,im_crop,cand_i,dresCount,frame_num,human_rect,real_human_rect,PID)
nBins = 256;

[~,ObjPoly]= roifill(rgb2gray(im_crop), all_candidate_polygons(cand_i).sorted_x,all_candidate_polygons(cand_i).sorted_y);

rgb = im_crop;
rgb1 = rgb(:,:,1); R = rgb1(ObjPoly==1);rHist = imhist(R, nBins);
rgb2 = rgb(:,:,2); G = rgb2(ObjPoly==1);gHist = imhist(G, nBins);
rgb3 = rgb(:,:,3); B = rgb3(ObjPoly==1);bHist = imhist(B, nBins);

colourHist = [rHist' gHist' bHist'];
colourHist = colourHist./norm(colourHist);

if human_rect(1)<1
    human_rect(1)=1;
end

new_x = all_candidate_polygons(cand_i).sorted_x + abs(human_rect(1));
new_y = all_candidate_polygons(cand_i).sorted_y + abs(human_rect(2));

all_candidate_polygons(cand_i).prob;

dres.x(dresCount,1)= min(new_x);
dres.y(dresCount,1) = min(new_y);
dres.w(dresCount,1) = max(new_x) - min(new_x);
dres.h(dresCount,1) = max(new_y) - min(new_y);
dres.r(dresCount,1) = all_candidate_polygons(cand_i).prob;
dres.fr(dresCount,1) = frame_num;
dres.PRect(dresCount,:) = real_human_rect;
dres.PID(dresCount,1) = PID;
dres.chist(dresCount,:) = colourHist;
dres.polyX{dresCount,1} = [new_x new_x(1)];
dres.polyY{dresCount,1} = [new_y new_y(1)];


STATS = regionprops(ObjPoly, 'Centroid','Orientation','Solidity','ConvexArea','MinorAxisLength','MajorAxisLength','Eccentricity');

if isempty(STATS)
   return 
end

FieNam = fieldnames(STATS);

for i = 1:length(FieNam)
    dres.(FieNam{i})(dresCount,:) = getfield(STATS, FieNam{i});
end
