function [colEdges,P1,P2] = GetPairOfLinesWithDistanceAngleProperty(AllLines,human_height)
global DisplayTagGlobal
global DisplayTag
global param

colEdges = [];

NoEdges = 100000;
% Get edge centres for triangles
P1 = [];
for i = 1:min(NoEdges,length(AllLines))
    P1 = [P1; mean(AllLines{i}(1,2)) mean(AllLines{i}(1,1))];
end
P2 = [];
for i = 1:min(NoEdges,length(AllLines))
    P2 = [P2; mean(AllLines{i}(2,2)) mean(AllLines{i}(2,1))];
end


combEdges = combnk(1:min(NoEdges,length(AllLines)),2);

%% Get all convex lines
for i =1:size(combEdges,1)
    
    E1P1x = P1(combEdges(i,1),1); E1P1y = P1(combEdges(i,1),2); E1P2x = P2(combEdges(i,1),1); E1P2y = P2(combEdges(i,1),2);
    E2P1x = P1(combEdges(i,2),1); E2P1y = P1(combEdges(i,2),2); E2P2x = P2(combEdges(i,2),1); E2P2y = P2(combEdges(i,2),2);
    P = [P1([combEdges(i,1) combEdges(i,2)],:); P2([combEdges(i,1) combEdges(i,2)],:)];
    
    %     if DisplayTag && DisplayTagGlobal
    %         scatter(E1P1x,E1P1y,40,[1 1 1],'filled');
    %         scatter(E2P1x,E2P1y,40,[1 1 1],'filled');
    %     end
    
    OrigP = GetIntersectionPointBetweenTwoLines(E1P1x,E1P1y,E1P2x,E1P2y,E2P1x,E2P1y,E2P2x,E2P2y);
    
    OrDist1 = norm([OrigP(1) OrigP(2)] - [E1P1x E1P1y]);
    OrDist2 = norm([OrigP(1) OrigP(2)] - [E1P2x E1P2y]);
    OrDist3 = norm([OrigP(1) OrigP(2)] - [E2P1x E2P1y]);
    OrDist4 = norm([OrigP(1) OrigP(2)] - [E2P2x E2P2y]);
    
    if OrDist1>OrDist2
        v1 = [OrigP(2) OrigP(1)]-[E1P1y E1P1x];
    else
        v1 = [OrigP(2) OrigP(1)]-[E1P2y E1P2x];
    end
    
    if OrDist3>OrDist4
        v2 = [OrigP(2) OrigP(1)] - [E2P1y E2P1x];
    else
        v2 = [OrigP(2) OrigP(1)] - [E2P2y E2P2x];
    end

    Angle = mod(atan2( det([v1;v2;]) , dot(v1,v2) ), 2*pi );
    angleout = (180/pi)*(Angle);
    if angleout>180 angleout=360-angleout; end

    if angleout>param.AngleBetweenTwoEdges
        
        dist1 = norm([E1P1x E1P1y] - [E2P1x E2P1y]);
        dist2 = norm([E1P1x E1P1y] - [E2P2x E2P2y]);
        dist3 = norm([E1P2x E1P2y] - [E2P1x E2P1y]);
        dist4 = norm([E1P2x E1P2y] - [E2P2x E2P2y]);
        
        len1 = norm([E1P1x E1P1y] - [E1P2x E1P2y]);
        len2 = norm([E2P1x E2P1y] - [E2P2x E2P2y]);
        
        [dist2lines, inddist]  = sort([dist1 dist2 dist3 dist4]);
        
        if human_height*dist2lines(1)/1000 < param.DistBetweenTwoEdges
            
            
            colEdges = [colEdges; [combEdges(i,1) combEdges(i,2)]];
            
            if DisplayTag && DisplayTagGlobal
                line([E1P1x E1P2x], [E1P1y E1P2y],'LineWidth', 3, 'Color', 'y');
                line([E2P1x E2P2x], [E2P1y E2P2y],'LineWidth', 3, 'Color', 'y');
            end
            
        else
            disp('')
        end

    end
end
