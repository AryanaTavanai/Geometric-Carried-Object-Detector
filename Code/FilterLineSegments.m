function [AllLines, LengthLine ] = FilterLineSegments(edgelist,human_height,Nedge,im,im_crop_orig)
global DisplayTagGlobal
global DisplayTag
global param
%% Obtain Line Segments
newedgelist = cell(0);
edgelistNei = [];
newctr = 0;
ctr =0;
for i = 1 : Nedge
    if size(edgelist{i},1) > 1
        for j = 1 : size(edgelist{i},1)-1
            newctr = newctr + 1;
            newedgelist{newctr} = edgelist{i}(j:j+1,:);
            
            if size(edgelist{i},1)==2
                edgelistNei(newctr,1) = 0;
            else
                if j==1 || j==size(edgelist{i},1)-1
                    if isequal(edgelist{i}(1,:),edgelist{i}(end,:))
                        edgelistNei(newctr,1) = 2;
                    else
                        edgelistNei(newctr,1) = 1;
                    end
                else
                    edgelistNei(newctr,1) = 2;
                end
            end
        end
    else
        newctr = newctr + 1;
        newedgelist{newctr} = edgelist{i}(j,:);
        edgelistNei(newctr,1) = 0;
    end
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Filter out vertical and short line segments.
edgelist = newedgelist;
Nedge = length(edgelist);
colourmp = hsv(Nedge);

AllLines = cell(0); LengthLine = [];

for I = 1:Nedge
    nl = norm(edgelist{I}(end,:) - edgelist{I}(1,:));


    %% If length of edge is too short
    if (nl/human_height)*100 < param.LenShortThresh   && edgelistNei(I)~=2 %angleout>=0 %&& angleout <= 89
        if DisplayTag && DisplayTagGlobal
            line(edgelist{I}(:,2), edgelist{I}(:,1),...
                'LineWidth', 1, 'Color', 'b');
        end
        continue
    end
    
    x1=edgelist{I}(1,2);
    x2=edgelist{I}(2,2);
    y1=edgelist{I}(1,1);
    y2=edgelist{I}(2,1);
    
    %% If edge is a person edge (Not included in the demo)
%     PersonEdge = GetEdgeOfPerson(TopRegion,x1,x2,y1,y2);
%     if PersonEdge ==1
%         if DisplayTag && DisplayTagGlobal
%             line(edgelist{I}(:,2), edgelist{I}(:,1),...
%                 'LineWidth', 3, 'Color', 'c');
%         end
%         continue
%     end   
    
    
    %% If edge is in the middle of an object/clothes and not on boundary
    ContrastMeasure= GetContrastMeasure(im,x1,x2,y1,y2);
    if ContrastMeasure<param.ContrastThresh
        if DisplayTag && DisplayTagGlobal
            line(edgelist{I}(:,2), edgelist{I}(:,1),...
                'LineWidth', 1, 'Color', 'w');
        end
    else
        if DisplayTag && DisplayTagGlobal
            line(edgelist{I}(:,2), edgelist{I}(:,1),...
                'LineWidth', 1, 'Color', 'r');
            line(edgelist{I}(:,2), edgelist{I}(:,1),...
                'LineWidth', 2, 'Color', 'k','linestyle','--');
        end
        
        ctr = ctr + 1;
        AllLines{ctr} = [edgelist{I}([1 end],1) edgelist{I}([1 end],2)];
        LengthLine(ctr) = nl;
        pt = (edgelist{I}(1,:) + edgelist{I}(end,:))/2;
    end

end

% disp(LengthLine);
[s,sind] = sort(LengthLine,'descend');
NewAllLines = cell(0);
if length(sind) >  param.ThreshHighNoEdges
    for  i = 1 : 1000
        NewAllLines{i} = AllLines{sind(i)};
        if DisplayTag && DisplayTagGlobal
            line(NewAllLines{i}(:,2), NewAllLines{i}(:,1),...
                'LineWidth', 2, 'Color', 'r');
        end
    end
    AllLines = NewAllLines;
else
    for  i = 1 : length(AllLines)
        if DisplayTag && DisplayTagGlobal
            line(AllLines{i}(:,2), AllLines{i}(:,1),...
                'LineWidth', 2, 'Color', 'r');
        end
    end
end

end


function distance = distancePointToLineSegmentV(p, a, b)
    % p is a matrix of points
    % a is a matrix of starts of line segments
    % b is a matrix of ends of line segments

    pa_distance = sqrt(sum((a-p).^2));
    pb_distance = sqrt(sum((b-p).^2));

    %logical index vector for cases where p is closer to a than b
    idx=pa_distance<pb_distance;

    %assign empty vectors for d and distance
    d=zeros(size(idx));
    distance=zeros(size(idx));

    %compute d for each point
    d(idx)=dot(unit(p(:,idx)-a(:,idx)), unit(b(:,idx)-a(:,idx)));
    d(~idx)=dot(unit(p(:,~idx)-b(:,~idx)), unit(a(:,~idx)-b(:,~idx)));

    %calculate distance
    distance=pb_distance;
    distance(idx)=pa_distance(idx);
    distance(d>0)=distance(d>0).*sqrt(1-d(d>0).^2);
end

function unit_vectors = unit(V)
    % unit computes the unit vectors of a matrix
    % V is the input matrix
    norms = sqrt(sum(V.^2));
    unit_vectors = zeros(size(V));
    normsIndex=norms>eps;
    unit_vectors(:,normsIndex) = V(:,normsIndex)./repmat(norms,size(V,1),1);
end

function distance = distancePointToLineSegment(p, a, b)
% p is a point
% a is the start of a line segment
% b is the end of a line segment

pa_distance = sum((a-p).^2);
pb_distance = sum((b-p).^2);

unitab = (a-b) / norm(a-b);

if pa_distance < pb_distance
    d = dot((p-a)/norm(p-a), -unitab);
    
    if d > 0
        distance = sqrt(pa_distance * (1 - d*d));
    else
        distance = sqrt(pa_distance);
    end
else
    d = dot((p-b)/norm(p-b), unitab);
    
    if d > 0
        distance = sqrt(pb_distance * (1 - d*d));
    else
        distance = sqrt(pb_distance);
    end
end
end
