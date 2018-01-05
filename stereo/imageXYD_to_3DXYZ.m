function [ points3D ] = imageXYD_to_3DXYZ( cam_params, data )
% Convert image coordinates [x,y,d] to 3D coordinates [X,Y,Z] 

    f = cam_params(1);
    cx_diff = cam_params(2);
    cx = cam_params(3);
    cy = cam_params(4);
    baseline = cam_params(5);

    Q = [1 0 0 -cx ; 0 1 0 -cy ; 0 0 0 f; 0 0 (-1/baseline) (cx_diff/baseline)];
    
    data(:,3) = data(:,3) + ((data(:,2)-cx)*0.011);
    data(:,3) = data(:,3) - ((data(:,1)-cy)*0.01);

    points3D = data(:,1:3); % do not use gradient information from column 4

    for r = 1:size(data)

       X= [(data(r,2))/1;(data(r,1))/1;-data(r,3);1];
       conv= Q*X;
       points3D(r,:) = conv(1:3)/conv(4);
       
    end

end

