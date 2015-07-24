function EP = GetEdgeOfPerson(TopRegion,x1,x2,y1,y2)

DisplayTag = 0;

if DisplayTag
   figure(22)

end

EP = 0;

mE = (y2 - y1)/(x1-x2);

if mE==-inf
    mE=10000000;
    
elseif mE==inf
    mE=-10000000;
end

cE = y2-mE*x1;

c1E= cE-6;
c2E= cE+6;

changeY = 4;
changeX = 4;
if mE<-1.6 || mE>1.6
    if x2<x1
        [~,BW] = roifill(double(TopRegion),[x1+changeX x2+changeX  x2-changeX x1-changeX],[y1 y2 y2 y1]);
    else
        [~,BW] = roifill(double(TopRegion),[x1-changeX x2-changeX  x2+changeX x1+changeX],[y1 y2 y2 y1]);
    end
else 
    y1c1 = y1;
    y2c1 = y2;
    y1c2 = y1;
    y2c2 = y2;
    [~,BW] = roifill(double(TopRegion),[x1 x2  x2 x1],[y1c1-changeY y2c1-changeY y2c2+changeY y1c2+changeY]);
end

%             indBW = BW==1;
RGBValues = TopRegion(BW==1);
BinVal = hist(RGBValues,[0 1 2]);
if BinVal(1)>10 && BinVal(3)>10 && BinVal(1)+BinVal(3)>.75*BinVal(2)
    EP=1;
elseif BinVal(1)>=0 && BinVal(3)>=0 && BinVal(2)==0
    EP=1;
end

if DisplayTag
    hist(RGBValues,[0 1 2])
    figure(23)
    imagesc(BW)
    hold on
    scatter(x1,y1)
    scatter(x2,y2)
    close 22
    close 23
end

end