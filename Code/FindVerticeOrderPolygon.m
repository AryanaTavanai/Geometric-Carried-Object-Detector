function [sorted_x, sorted_y] = FindVerticeOrderPolygon(edges)
% close all;

DisplayTag =0;

sorted_x = [];
sorted_y = [];
if DisplayTag
    figure(10);
    set(gca,'YDir','reverse');hold on;
end
% axis([0 1 0 1]); hold on;
% edges = [];
% for i = 1 : 5
%     [x(1) y(1)] =  ginput(1);
%     plot(x(1),y(1),'r*');
%     [x(2) y(2)] =  ginput(1);
%     plot(x(2),y(2),'g*');
%     edges = [edges ; [x(1) y(1) x(2) y(2)]];
%     line(edges(i,[1 3]),edges(i,[2 4]));
% end

if DisplayTag
    for i = 1 : size(edges,1)
        
        plot(edges(i,1),edges(i,2),'r*');
        plot(edges(i,3),edges(i,4),'g*');
        line(edges(i,[1 3]),edges(i,[2 4]),'color','b');
    end
end

edgex = [];
edgey = [];
edge_index = [];
for i = 1 : size(edges,1)
    edge_index = [edge_index i i ];
    edgex = [edgex edges(i,[1 3])];
    edgey = [edgey edges(i,[2 4])];
end
meanx = mean(edgex);
meany = mean(edgey);

if DisplayTag
    plot(meanx,meany,'ko');
    
end

randX = edgex(1);
randY = edgey(1);

linebase = [meanx meany randX  randY];
v1 = [linebase([2 1]) - linebase([4 3])];
x1 = v1(1);
y1 = v1(2);

m = (randY - meany)/(randX-meanx);
m_orth = -1/m;
C = meany - m_orth*meanx;
x_orth = max(edgex);
y_orth = m_orth*x_orth + C;

if y_orth>max(edgey) || y_orth<min(edgey)
    y_orth = max(edgey);
    x_orth = (y_orth-C)/m_orth;
end
    
linebaseI = [meanx meany x_orth  y_orth];
v1I = [linebaseI([2 1]) - linebaseI([4 3])];

if DisplayTag
    line([meanx x_orth], [meany, y_orth],'linewidth',2,'color','m');
    line(linebase([1 3]),linebase([2 4]),'linewidth',3,'color','r');
end

all_angles(1) = 0;
for i = 1 : length(edgex)
    linenew = [meanx meany edgex(i) edgey(i)];
    if DisplayTag
        line(linenew([1 3]),linenew([2 4]),'color','g');
    end
    v2 = [linenew([2 1]) - linenew([4 3])];
    
    x2 = v2(1);
    y2 = v2(2);

    %% OLD USELESS METHOD
%     angleout = atan2(norm(cross([v1 0],[v2 0])),dot([v1 0],[v2 0]));
%     angleout_h = (180/pi) *(angleout);
    
    
%     angleout = atan2(norm(cross([v1I 0],[v2 0])),dot([v1I 0],[v2 0]));
%     angleout_v = (180/pi) *(angleout);
%     if m<0
%         if angleout_v > 90 && angleout_h > 90 angleout_h = 360-angleout_h; end
%         if angleout_v > 90 && angleout_h <= 90 angleout_h = angleout_h; end
%         if angleout_v <= 90 && angleout_h > 90 angleout_h = 360-angleout_h; end
%         if angleout_v <= 90 && angleout_h <= 90 angleout_h = 360-angleout_h; end
%     end
%     if m>0
%         if angleout_v > 90 && angleout_h > 90 angleout_h = angleout_h; end
%         if angleout_v > 90 && angleout_h <= 90 angleout_h = 360-angleout_h; end
%         if angleout_v <= 90 && angleout_h > 90 angleout_h = angleout_h; end
%         if angleout_v <= 90 && angleout_h <= 90 angleout_h = angleout_h; end
%     end
    
%     if DisplayTag
%         text(linenew(3),linenew(4),['ha: ' num2str(round(angleout_h)) ' va: ' num2str(round(angleout_v))], 'fontsize',13);
%     end

    %% NEW METHOD

    angleout_h = mod(atan2(x1*y2-x2*y1,x1*x2+y1*y2),2*pi)*(180/pi);
    if DisplayTag
        text(mean(linenew([1 3])),mean(linenew([2 4])),num2str(angleout_h));
    end
    
    all_angles(i) = angleout_h;
end

inZero = find(all_angles==0);
all_angles(inZero(2:end))=360;

all_anglesInEdges = reshape(all_angles,2,size(edges,1))';

% Alledges = [reshape(edges(1,:),2,2)';reshape(edges(2,:),2,2)'];
Alledges = zeros(size(edges,1)*2,2);
for i = 1: size(edges,1)
    
    Alledges(2*i-1:2*i,:) = reshape(edges(i,:),2,2)';
    
end 

A = [all_anglesInEdges];
B = [ [1:size(all_anglesInEdges,1)]'+.1 [1:size(all_anglesInEdges,1)]'+.2];
C = reshape(A',size(all_anglesInEdges,1)*size(all_anglesInEdges,2),1);
D = reshape(B',size(all_anglesInEdges,1)*size(all_anglesInEdges,2),1);
[sC,indC] = sort(C);
E = D(indC);

SEdges = Alledges(indC,:);
edgeCtr=1;
arr = [];
while 1
    if isempty(sC)
        break; 
    end
    [~,Smallest]= min(D);
    f = sC(1); 
    ind = find(ceil(E(Smallest))==ceil(E));
    arr = [arr; sC(ind)'];
    
    if ((sC(1)==0 && sC(ind(2))>=180)) || ((sC(ind(2))==360) && (sC(ind(1))<180))
        xs = SEdges(ind,1)';
        ys = SEdges(ind,2)';
        sorted_x = [sorted_x xs(2) xs(1)];
        sorted_y = [sorted_y ys(2) ys(1)];
    else
        sorted_x = [sorted_x SEdges(ind,1)'];
        sorted_y = [sorted_y SEdges(ind,2)'];
    end
    
    if DisplayTag
        text(sorted_x(end-1),sorted_y(end-1),num2str(edgeCtr),'FontSize',18);
        edgeCtr = edgeCtr+1;
        text(sorted_x(end),sorted_y(end),num2str(edgeCtr),'FontSize',18); 
        edgeCtr = edgeCtr+1;
    end
    
    sC(ind) = []; 
    E(ind) = [];
    D(ind) = [];
    indC(ind) = [];
    SEdges(ind,:) = [];
end    


if DisplayTag
    close 10
end
















% 
% Reverse=0;
% for i = 1 : size(edges,1)
%     if i == 1
%         ind = find(i==edge_index);
%         if all_angles(ind(2))  > 180
%             edge_angle(i,:) = [all_angles(ind(2)) all_angles(ind(1))];
%             edge_angle_index(i,:) = [2 1];
%         else
%             ind = find(i==edge_index);
%             [edge_angle(i,:) edge_angle_index(i,:)] = sort(all_angles(ind));
%         end
%     else
%         ind = find(i==edge_index);
%         [edge_angle(i,:) edge_angle_index(i,:)] = sort(all_angles(ind));
%     end
% 
%     if i == 1
%         ind = find(i==edge_index);
%         if all_angles(ind(2))  > 180
%             Reverse=1;
%         end
%     end
% 
%     ind = find(i==edge_index);
%     [edge_angle(i,:) edge_angle_index(i,:)] = sort(all_angles(ind));
%     
% end
% 
% 
% if Reverse==1
%     [s,ind] = sortrows(-edge_angle);
%     s = -s; 
% else
%     [s,ind] = sortrows(edge_angle);
% end
% 
% all_anglesInEdgesIndexToPoint = zeros(size(all_anglesInEdges,1),size(all_anglesInEdges,2));
% for i = 1:size(all_anglesInEdges,1)
%     
%     
%     [sortedAngles all_anglesInEdgesIndexToPoint(i,:)] = sort(all_anglesInEdges(i,:));
%     all_anglesInEdges(i,:) = sortedAngles;
%     
%     if i==1 && all_anglesInEdges(i,2)>180
%         all_anglesInEdgesIndexToPoint(i,:) = [2 1];
%     else
%         all_anglesInEdges(i,:) = sortedAngles;
%     end
% 
% 
% end
% 
% [all_anglesInEdges,ind] = sortrows(all_anglesInEdges,1);
% all_anglesInEdgesIndexToPoint = all_anglesInEdgesIndexToPoint(ind,:);
% 
% for i = 1 : length(ind)
%     if isequal(all_anglesInEdgesIndexToPoint(ind(i),:),[1 2])
%         sorted_x = [sorted_x edges(ind(i),1) edges(ind(i),3)];
%         sorted_y = [sorted_y edges(ind(i),2) edges(ind(i),4)];
%     elseif isequal(all_anglesInEdgesIndexToPoint(ind(i),:),[2 1])
%         sorted_x = [sorted_x edges(ind(i),3) edges(ind(i),1)];
%         sorted_y = [sorted_y edges(ind(i),4) edges(ind(i),2)];
%     end
%     if DisplayTag
%         text(sorted_x(end-1),sorted_y(end-1),[num2str(2*i-1)]);
%         text(sorted_x(end),sorted_y(end),[num2str(2*i)]); 
%     end
% end


% edges(ind(i),edge_angle_index(ind(i),1)) edges(ind(i),edge_angle_index(ind(i),1)+1) edges(ind(i),edge_angle_index(ind(i),2)) edges(ind(i),edge_angle_index(ind(i),2)+1)
% unique_points  = unique([sorted_x' sorted_y'],'rows','stable');
% sorted_x = unique_points(:,1);
% sorted_y = unique_points(:,2);




