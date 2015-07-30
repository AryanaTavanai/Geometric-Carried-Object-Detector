global param


%% Choose type of edge detector
param.EdgeDetect = 'Canny';

% param.EdgeDetect = 'QuickShift'; % You will need  do download the vlfeat toolbox:
% param.kernelsize=10;             % https://github.com/vlfeat/vlfeat to use quick  make sure
% param.maxdist=100;               % to addpath the vlfeat directory in the main function.
                                   % Parameters below may need tweaking.
                                
                                 
%% Important Parameters that may need changing based on dataset.
param.LenShortThresh = 5; % Threshold to filter very short edges (FilterLineSegments function)

param.DistBetweenTwoEdges = 5; % This threshold only allows edges that are close to
                               % eachother to form a chain. (GetPairOfLinesWithDistanceProperty function)

param.AngleBetweenTwoEdges = 20; % Edges that have angle more than this threshold are allowed to
                                 % form a chain. (GetPairOfLinesWithDistanceProperty function).

param.ConvexityThresh = 0.95; % Any edge chains that do not have a convexity measure as high as this
                              % threshold will be filtered out and removed from the level-wise mining.                                 
                              % (ReturnEdgeChainsWithSomeProperty function)
                              
param.FirstLevel = 4; % This threshold allows the detector to accept chains as detections that consist of more 
                      % than a certain number of edges within them. If this threshold value is N, it translates
                      % to all chains produced after the Nth level in the level wise mining i.e chains that have
                      % a length of N+1 edges. (ComputeEdgeChainProbability function)
        
param.CircumferenceRatioThresh= 0.55; % The CircumferenceRatio ratio is obtained based on the the circumference
                                      % of the edge chain over the circumference of their convex hull. This threshold
                                      % filters chains that are not closed. The closer this value is to 1, chains must
                                      % more closed in order to be acceted as detections. (ComputeEdgeChainProbability function)

param.QuickShiftThresh = 20; % Threshhold used to remove weak edges provided by the quick shift algorithm
                                      
%% Parameters that don't heavily change the results.
param.human_height = 400; % Height of the person used to threshold  very short edges.(FilterLineSegments function)

param.tol = 3; % tolerence on whether to create one edge line or divide it into two
               % due to a bend. If the bend is higher than the "tol" value in pixels
               % it will create two short edge lines rather than one. (GetLinesFromEdges function)

param.ContrastThresh = 20; % If an edge is the same colour as its surroundings we threshold it (thin white edge lines).
                          % This is useful for removing edges that are on not on a boundary i.e edges 
                          % in the middle of clothes or surfaces. (FilterLineSegments function)
                          
                          
param.ThreshHighNoEdges = 1000; % If there are too many edges, This threshold is used to take
                                 % in the top longest param.ThreshHighNoEdges edges and filter
                                 % out any of the smaller ones. (FilterLineSegments function)

param.MaxLevel = 10; % How many levels should be used in the level wise mining. If chains around the objects
                     % consist of a large number of edges this value should be larger and vice versa.
                     % (ReturnEdgeChainsWithSomeProperty function)
                     
param.MaxCombinations = 300000; % If there are too many combinations of edge the system will break in the level wise mining.
                                % Above parameters must be changed to remove redundant edges to bring the number of combinations of edges down
                                % so that this threshold is not used. If computation and time is not a problem increase this threshold.
                     