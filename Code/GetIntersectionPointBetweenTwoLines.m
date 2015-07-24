function P = GetIntersectionPointBetweenTwoLines(L1_x1,L1_y1,L1_x2,L1_y2,L2_x1,L2_y1,L2_x2,L2_y2)
warning off
DisplayTag = 0;

%Plot the lines
if DisplayTag
    figure(22)
    plot([L1_x1 L1_x2], [L1_y1 L1_y2])
    hold on
    plot([L2_x1 L2_x2], [L2_y1 L2_y2])
end

% Compute several intermediate quantities
Dx12 = L1_x1-L1_x2;
Dx34 = L2_x1-L2_x2;
Dy12 = L1_y1-L1_y2;
Dy34 = L2_y1-L2_y2;
Dx24 = L1_x2-L2_x2;
Dy24 = L1_y2-L2_y2;

% Solve for t and s parameters
ts = [Dx12 -Dx34; Dy12 -Dy34] \ [-Dx24; -Dy24];

% Take weighted combinations of points on the line
P = ts(1)*[L1_x1; L1_y1] + (1-ts(1))*[L1_x2; L1_y2];
% Q = ts(2)*[L2_x1; L2_y1] + (1-ts(2))*[L2_x2; L2_y2];

% Plot intersection points
if DisplayTag 
    
    plot(P(1), P(2), 'ro')
    plot(Q(1), Q(2), 'bo')
    hold off
    close 22
end