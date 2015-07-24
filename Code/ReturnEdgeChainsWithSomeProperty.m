function [candidate_polygon, multi_colEdges]  = ReturnEdgeChainsWithSomeProperty(colEdges,P1,P2,im,human_height)
global DisplayTagGlobal
global DisplayTag
global param; 
candidate_polygon = cell(0);

multi_colEdges{1} = colEdges;
multi_colEdgesTemp{1} = [];
candidate_ctr = 1;


DisplayTag = 0;

if isempty(colEdges)
    return
end


for l_i = 1 : size(multi_colEdges{1},1)
    
    edges = [];
    for l_j = 1 : length(multi_colEdges{1}(l_i,:))
        E1P1x = P1(multi_colEdges{1}(l_i,l_j),1);
        E1P1y = P1(multi_colEdges{1}(l_i,l_j),2);
        E1P2x = P2(multi_colEdges{1}(l_i,l_j),1);
        E1P2y = P2(multi_colEdges{1}(l_i,l_j),2);
        
        edges = [edges; E1P1x E1P1y E1P2x E1P2y];
        
        if DisplayTag && DisplayTagGlobal
            sh1{l_j} = scatter(E1P1x,E1P1y,100,'r','filled');
            sh2{l_j} = scatter(E1P2x,E1P2y,100,'r','filled');
        end
    end
    
        [sorted_x, sorted_y] = FindVerticeOrderPolygon(edges);
        convex = ComputeConvexityMeasure(sorted_x,sorted_y,0);
        if convex == 0
            disp('#############################')
            disp('Warning: Convex is zero')
            disp('#############################')
        end
        if convex>param.ConvexityThresh
            multi_colEdgesTemp{1}(candidate_ctr,:) = multi_colEdges{1}(l_i,:);
            candidate_polygon{1}(candidate_ctr).sorted_x = sorted_x;
            candidate_polygon{1}(candidate_ctr).sorted_y = sorted_y;
            candidate_ctr = candidate_ctr + 1;
        end
    if DisplayTag && DisplayTagGlobal delete(sh1{1}); delete(sh2{1}); end
    if DisplayTag && DisplayTagGlobal delete(sh1{2}); delete(sh2{2}); end
end

multi_colEdges = multi_colEdgesTemp;


disp(['Lvl' ' | ' 'Edges Combinations' ' | ' 'Unique Chains']);
DisplayTag =0;
for level = 1 : param.MaxLevel
    
    if isempty(multi_colEdges{level})
        break;
    end
    combColEdges = combnk(1:size(multi_colEdges{level},1),2);
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % If the number of candidates is extremely large break
    % Change other parameters to remove redundant edges to bing this number down
    if length(combColEdges)>param.MaxCombinations
        break
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    disp([num2str(level) '  ' num2str(length(combColEdges)) ' :  ' num2str(length(multi_colEdges{level}))]);
    multi_colEdges{level+1} = [];
    candidate_ctr = 0;
    for i = 1 : size(combColEdges)
        edges = [];
        ind_1 = combColEdges(i,1);ind_2 = combColEdges(i,2);p_ind1 = multi_colEdges{level}(ind_1,:);p_ind2 = multi_colEdges{level}(ind_2,:); 


        if length(intersect(multi_colEdges{level}(ind_1,:),multi_colEdges{level}(ind_2,:)))==level

            candidate = union(multi_colEdges{level}(ind_1,:),multi_colEdges{level}(ind_2,:));
            
            
            % % Old Way slow and inefficient
            sh1 = [];sh2 = [];XPoints = [];YPoints = [];
            
            for kk = 1 : length(candidate)
                E1P1x = P1(candidate(kk),1);
                E1P1y = P1(candidate(kk),2);
                E1P2x = P2(candidate(kk),1);
                E1P2y = P2(candidate(kk),2);
                
                edges = [edges; E1P1x E1P1y E1P2x E1P2y];
                
                XPoints = [XPoints ; P1(candidate(kk),1);P2(candidate(kk),1)];
                YPoints = [YPoints ; P1(candidate(kk),2);P2(candidate(kk),2)];
                if DisplayTag && DisplayTagGlobal
                    sh1(kk) = scatter(E1P1x,E1P1y,100,'r','filled');
                    sh2(kk) = scatter(E1P2x,E1P2y,100,'r','filled');
                end
            end
            
            if DisplayTag && DisplayTagGlobal pause(.2); end

            [sorted_x, sorted_y] = FindVerticeOrderPolygon(edges);
            
            convex = ComputeConvexityMeasure(sorted_x,sorted_y,0);

            if convex >= param.ConvexityThresh
                ind = find(sum(ismember(multi_colEdges{level+1}',candidate'))==level+2);
                if isempty(ind)
                    
                    candidate_ctr = candidate_ctr +1;
                    multi_colEdges{level+1} = [multi_colEdges{level+1}; candidate];
                    candidate_polygon{level+1}(candidate_ctr).sorted_x = sorted_x;
                    candidate_polygon{level+1}(candidate_ctr).sorted_y = sorted_y;
                else
                    disp('')
                end
            end
            if DisplayTag && DisplayTagGlobal delete(sh1); delete(sh2); end
        end
    end
    
    % Eliminate candidate in level l if it occurs in level l+1
    eliminate_index = [];
    for eliminate_i = 1 : size(multi_colEdges{level},1)
        for eliminate_j = 1 : size(multi_colEdges{level+1},1)
            candid_i = multi_colEdges{level}(eliminate_i,:);
            candid_j = multi_colEdges{level+1}(eliminate_j,:);
            if nnz(ismember(candid_i,candid_j)) == length(candid_i); % if subset then 1
                eliminate_index = [eliminate_index eliminate_i];
            end
        end
    end
    multi_colEdges{level}(unique(eliminate_index),:) = [];
    candidate_polygon{level}(unique(eliminate_index)) = [];
    sum_key = 0;
    if level > 1
        for key = 1 : size(multi_colEdges{level},2)
            sum_key = sum_key + (2.^multi_colEdges{level}(:,key));
        end
        all_indices = [1 : size(multi_colEdges{level},1)];
        [C,IA,IC] = unique(sum_key);
        repetitions = setdiff(all_indices,IA);
        multi_colEdges{level}(repetitions,:) = [];
        candidate_polygon{level}(repetitions) = [];
    end
    
end
