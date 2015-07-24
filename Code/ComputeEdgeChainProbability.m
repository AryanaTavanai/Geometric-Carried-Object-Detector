function [all_candidate_polygons] = ComputeEdgeChainProbability(multi_colEdges, candidate_polygon,P1,P2,im_crop_CarObj_mask)
global DisplayTagGlobal
global DisplayTag
global ColArray; 
global param;

all_candidate_polygons = [];
cand_ctr = 0;
conv_ctr = 0;

for level = param.FirstLevel :length(multi_colEdges)
    if ~isempty((multi_colEdges{level}))
        for cand = 1 : size(multi_colEdges{level},1)
            
            
            Ratio_LE_LO = CheckLengthEdgeOverLengthObject(candidate_polygon{level}(cand).sorted_x,candidate_polygon{level}(cand).sorted_y);
            
            edge_overlap_with_contour_prob = Ratio_LE_LO;
            
            CandidMotionCount = 0;
            if Ratio_LE_LO > param.CircumferenceRatioThresh
                conv_ctr = conv_ctr + 1;
                colVect = ColArray(conv_ctr,:);
                candidate = multi_colEdges{level}(cand,:);
                for cand_i = 1 : length(candidate)
                    E1P1x = P1(candidate(cand_i),1);
                    E1P1y = P1(candidate(cand_i),2);
                    E1P2x = P2(candidate(cand_i),1);
                    E1P2y = P2(candidate(cand_i),2);
                    
                    if im_crop_CarObj_mask(E1P1y,E1P1x)==1 && im_crop_CarObj_mask(E1P2y,E1P2x)
                        CandidMotionCount = CandidMotionCount+1;
                    end
                end
                
                overlap_motion_mask = CandidMotionCount./length(candidate);
                carried_object_motion_mask_prob = normpdf(overlap_motion_mask,1,.5);
                
                cand_ctr = cand_ctr + 1;
                all_candidate_polygons(cand_ctr).prob = edge_overlap_with_contour_prob*carried_object_motion_mask_prob;
                all_candidate_polygons(cand_ctr).sorted_x = candidate_polygon{level}(cand).sorted_x;
                all_candidate_polygons(cand_ctr).sorted_y = candidate_polygon{level}(cand).sorted_y;
                
                for cand_i = 1 : length(candidate)
                    E1P1x = P1(candidate(cand_i),1);
                    E1P1y = P1(candidate(cand_i),2);
                    E1P2x = P2(candidate(cand_i),1);
                    E1P2y = P2(candidate(cand_i),2);
                    if DisplayTag && DisplayTagGlobal
                        if CandidMotionCount==length(candidate)
%                             line([E1P1x ;E1P2x],[E1P1y;E1P2y],'LineWidth', 7, 'Color', [.99 .99 .99]);
                            line([E1P1x ;E1P2x],[E1P1y;E1P2y],'LineWidth', 10, 'Color', colVect);
                        else
                            line([E1P1x ;E1P2x],[E1P1y;E1P2y],'LineWidth', 7, 'Color', colVect);
                        end
                    end
                end
                
                %                 title(['\fontsize{16}' num2str(candidate) ' - ' num2str(Ratio_LE_LO)])
                
                %                     if DisplayTag && DisplayTagGlobal;pause(0.00001);end
            end
            
        end
    end
    
end