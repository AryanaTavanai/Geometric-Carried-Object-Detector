function main

% This program is used to obtain carried object detections. It is a basic 
% version of the work described in the papers [1,2] below and does not include
% many of the functionalities described within it. As a result this code should
% not be used to replicate the results in the paper. However, feel free to use, 
% modify and extend this code
% 
% Author: Aryana Tavanai
% Email: fy06at@leeds.ac.uk
% 
%
% Uploaded Version: July 2015
%
%
% If you use this code in your work, please cite the following paper:
%
% [1] Tavanai, Sridhar, Chinellato, Cohn, and Hogg. "Joint Tracking and 
% Event Analysis for Carried Object Detection".
% British Machine Vision Conference (BMVC) 2015.
%
% [2] Tavanai, Sridhar, Gu, Cohn, Hogg . “Carried object detection and 
% tracking using geometric shape models and spatio-temporal consistency,”
% International Conference on Computer Vision Systems (ICVS) 2013.
%
%
% COPYRIGHT
% This source file is the copyright property of the University of Leeds.
%
% Permission to use, copy, modify, and distribute this source file for
% educational, research, and not-for-profit purposes, without fee and
% without a signed licensing agreement, is hereby granted, provided that
% the above copyright notice, this paragraph and the following three
% paragraphs appear in all copies, modifications, and distributions.
%
% In no event shall The University be liable to any party for direct,
% indirect, special, incidental or consequential damages, including lost
% profits, arising out of the use of this software and its documentation.
%
% The software is provided without warranty. The University has no
% obligation to provide maintenance, support, updates, enhancements, or
% modifications.
%
% This software was written by Aryana Tavanai, Computer Vision Group,
% School of Computing, University of Leeds, UK. The code and use
% thereof should be attributed to the author where appropriate
% (including demonstrations which rely on it's use).



addpath('Code/')
addpath(genpath('3rdParty_Toolbox/'))

global sz_im;
global rectcolor;
global DisplayTagGlobal;
global DisplayTag;
global ColArray; 
global param

close all


%% Setup Directories
ObjectDetection = 'ObjectDetection/';

%% Set DisplayTagGlobal to 1 or 0 to Turn on or off displays entirely.
DisplayTagGlobal = 1;

%% Set DisplayTag to 1 or 0 to enable/disable viewing the results at each step.
% (some functions do not have a global DisplayTag and must be set manually)
DisplayTag = 1;


ColArray = rand(5000,3);
rectcolor = rand(100,3);
dres = [];
dresCount = 1;


img = imread('Data/eg1.png');foreground_mask = imread('MotionMask/eg1.png');
sz_im = size(img);


if DisplayTag && DisplayTagGlobal
    MonitorPos = get(0,'MonitorPositions');
    figure('Position',MonitorPos(1,:));
    subplot(1,2,1);
    imshow(img)
    title('\fontsize{16} Create a bounding box to find the object in')
end

%% Set a bounding box to look for an object (should be repalced by detections in person tracks)
rect = getrect();
if DisplayTag && DisplayTagGlobal;rectangle('position', rect, 'edgecolor', 'b');end


%% Load additional information
LoadParameters                                        % VERY IMPORTANT CHECK THE PARAMETERS IN THIS SCRIPT
foreground_mask = imresize(foreground_mask,[sz_im(1),sz_im(2)]);
human_height = param.human_height;
carried_object_mask = zeros(size(img,1),size(img,2)); % Object prior obtained by removing person region from forground
                                                      % region. As this is not included in this demo we give a matrix of zeros.
                                          
person_filter_mask = zeros(size(img,1),size(img,2));  % Remove areas from edge detection based on certain body parts i.e head or feet. 
                                                      % Pose estimation not included in this demo. 


%% Obtain Line segments from edges
[edgelist,im_crop_size,im_crop,im_crop_obj_prior] = GetLinesFromEdges(img, rect,foreground_mask,carried_object_mask,person_filter_mask);

%%%%%%%%%%%%%%%%%%
DisplayMessageAndWaitForButtonPress('Edge Detection (mouse click to continue)')
%%%%%%%%%%%%%%%%%%

if isempty(edgelist) return; end
Nedge = length(edgelist);
if DisplayTag && DisplayTagGlobal;hold on;end

%% Filter Line segments with some property. (Does not include person edge filtering)
[AllLines, LengthLine] = FilterLineSegments(edgelist,human_height,Nedge,im_crop);

if isempty(LengthLine) return; end
% Check whether we need to expand bounds
minx = 1; miny = 1;maxx = im_crop_size(2); maxy = im_crop_size(1);
for I = 1:Nedge; minx = min(min(edgelist{I}(:,2)),minx); miny = min(min(edgelist{I}(:,1)),miny); maxx = max(max(edgelist{I}(:,2)),maxx); maxy = max(max(edgelist{I}(:,1)),maxy); end

%%%%%%%%%%%%%%%%%%
DisplayMessageAndWaitForButtonPress('Accepted Edge Lines (Red) (mouse click to continue)')
%%%%%%%%%%%%%%%%%%

%% Get all pairs of edges that satisfy a property
[colEdges,P1,P2]  = GetPairOfLinesWithDistanceAngleProperty(AllLines,human_height);

%%%%%%%%%%%%%%%%%%
DisplayMessageAndWaitForButtonPress('Candidate Edge Lines Chains (Yellow) (mouse click to continue)')
if  DisplayTag && DisplayTagGlobal
    title('\fontsize{16} Performing level-wise mining, please wait ...')
    pause(.1);
end
%%%%%%%%%%%%%%%%%%

%% Return Edge Group with some Property
[candidate_polygon, multi_colEdges]  = ReturnEdgeChainsWithSomeProperty(colEdges,P1,P2,im_crop,human_height);

DisplayTag = 1;
%% Compute Edge Group Probability and return the final candidate polygon.
all_candidate_polygons = [];
[all_candidate_polygons] = ComputeEdgeChainProbability(multi_colEdges, candidate_polygon,P1,P2,im_crop_obj_prior);

%%%%%%%%%%%%%%%%%%
DisplayMessageAndWaitForButtonPress('Final Detection Chains (mouse click to continue)')
%%%%%%%%%%%%%%%%%%

if  DisplayTag && DisplayTagGlobal
    subplot(1,2,2);
    imshow(im_crop)
end

if ~isempty(all_candidate_polygons)
    for cand_i = 1 : length(all_candidate_polygons)
        modifiedHumanRect=rect;
        realHumanRect = rect;
        frame_num = 54;
        personID  =1;
        dres = GetObjectProperties(dres,all_candidate_polygons,im_crop,cand_i,dresCount,frame_num,modifiedHumanRect,realHumanRect,personID);
        dresCount = dresCount + 1;
        
        if  DisplayTag && DisplayTagGlobal

            hold on
            p = all_candidate_polygons(cand_i).prob;
            %                                 title(num2str(p))
            
            new_x = all_candidate_polygons(cand_i).sorted_x;
            new_y = all_candidate_polygons(cand_i).sorted_y;
            
            plot([new_x new_x(1)],[new_y new_y(1)],'r','linewidth',3)
            
            %%%%%%%%%%%%%%%%%%
            d(1) = plot([new_x new_x(1)],[new_y new_y(1)],'g','linewidth',3);
            title('Carried Object Detection Chains')
            pause(1);
            delete(d);
            %%%%%%%%%%%%%%%%%%
            
        end
    end
end

title('\fontsize{16} Carried Object Detection Chains - Program Finished!!')
save([ObjectDetection '/dres.mat'],'dres')

if  DisplayTag && DisplayTagGlobal
    pause(0.1);
end

    

end
