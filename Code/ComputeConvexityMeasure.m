function Convexity = ComputeConvexityMeasure(x,y,DisplayTag)

DisplayTag = 0;
% [x y ] = GetPoints;
% tic
x = [x x(1)]; y = [y y(1)];
k = convhull(x,y);
xx = x(k);
yy = y(k);

if DisplayTag
    figure(22)
    plot(xx,yy,'g');
    hold on
    plot(x,y,'b');
end

A = polyarea(x,y);
AA =  polyarea(xx,yy);
Convexity = A/AA;
% toc
if DisplayTag
    text(30,30,['Convexity: ' num2str(Convexity)],'fontsize',17);
    close 22
end
disp('');

