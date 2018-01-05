    function obstacle_location = extract_obstacle_location(XYZ_coordinates_features_obstacle)

    %% first perform rotation-transformation to correct for camera pointing down
    
    
    %% get obstacle distance
    
    obstacle_location(1) = 0;
    obstacle_location(2) = 0;
    obstacle_location(3) = mean(XYZ_coordinates_features_obstacle(:,3));
    
    cnt = 0;
    for i = 1:size(XYZ_coordinates_features_obstacle,1)
        
        if XYZ_coordinates_features_obstacle(i,2) > 0 && XYZ_coordinates_features_obstacle(i,2) < 500
            
            obstacle_location(1) = obstacle_location(1) + XYZ_coordinates_features_obstacle(i,1);
            cnt = cnt+1;
        end
    end
    
    obstacle_location(1) = obstacle_location(1)/cnt;
        
    end
    
    