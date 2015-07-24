function Ratio_LE_LO = CheckLengthEdgeOverLengthObject(contour_x,contour_y)

contour_x = [contour_x contour_x(1)];
contour_y = [contour_y contour_y(1)];
LE = 0; LO = 0;
for contour_i = 1 : length(contour_x)-1
    len_obj_edge = norm([contour_x(contour_i+1) contour_y(contour_i+1)] - [contour_x(contour_i) contour_y(contour_i)]);
    if mod(contour_i,2)==0 %even
        LO = LO + len_obj_edge;
    else % odd
        LE = LE + len_obj_edge;
        LO = LO + len_obj_edge;
    end
end
Ratio_LE_LO = LE/LO;

end