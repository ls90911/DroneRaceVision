addpath('../');

%% DATA SET:

set_name = 'SmartUAV'; % set 2 is not well pixel-shifted

%% OTHER DEFINES

% image parameters
width = 128;
height = 96;

% camera parameters
cam_params = [130 -0.3 64 48 60];   % [ focal_length[px] cx_diff[px] cx[px] cy[px] baseline[mm] ] 

% if not calibrated onboard, shift the images here:
v_shift_R = 0;

% stereo vision settings
DIFF_THRESHOLD = 2;
FEATURE_FACTOR = 1.4;

%init
obstacle_location_list = [0 0 0];


%%
dir_name = ['../' set_name '/'];
file_names = makeListOfFiles(dir_name, 'bmp');
img_nrs = 1:length(file_names);

for img_nr = img_nrs

    I = imread([dir_name file_names{img_nr}]);
    
    imgR_3 = I(:,1:width,:);
    imgR_3 = shiftImage(imgR_3, v_shift_R);
    imgL_3 = I(:,width+1:end,:);
    

    imgFeature_3 = imgL_3(:,:,:);
    imgStereo_3 =  imgR_3(:,:,:);

    imgR_1 = imgR_3(:,:,1);
    imgL_1 = imgL_3(:,:,1);

    imgFeature_1 = imgFeature_3(:,:,1);

    [image_coordinates_stereo, Disp_map] = run_SparseStereo_one_sided( imgL_1, imgR_1, width, height, cam_params, DIFF_THRESHOLD, FEATURE_FACTOR);
    XYZ_coordinates_features = imageXYD_to_3DXYZ( cam_params, image_coordinates_stereo );

    hist_bins = [0:100:4000];
    
    figure(1)
    subplot(3,1,1)
    image(Disp_map,'CDataMapping','direct')
    subplot(3,1,2)
    image(imgL_3)
    subplot(3,1,3)
    hist(XYZ_coordinates_features(:,3),hist_bins);
    xlim([hist_bins(1) hist_bins(end-1) ])
    [counts,centers] = hist(XYZ_coordinates_features(:,3),50);
    xlabel('histogram of Z-values of matched points')
    
    obstacle_distance = centers(counts==max(counts));
    obstacle_distance_error = 200;
   
    XYZ_coordinates_features_obstacle = XYZ_coordinates_features;
    cnt = 0;
    for i = 1:length(XYZ_coordinates_features)
        if ( abs(XYZ_coordinates_features(i,3)-obstacle_distance) < obstacle_distance_error )
          cnt = cnt+1;
          XYZ_coordinates_features_obstacle(cnt,:) = XYZ_coordinates_features(i,:);
          
        end
    end
    cnt_object_points = cnt
    
    XYZ_coordinates_features_obstacle = XYZ_coordinates_features_obstacle(1:cnt,:);
    
    obstacle_location = extract_obstacle_location(XYZ_coordinates_features_obstacle)
    
    obstacle_location_list = [obstacle_location_list; obstacle_location];
    
    %     figure(1)
%     subplot(3,1,3)
%     hist(XYZ_coordinates_features_obstacle(:,3),10)
    
    figure(2)
    plot(XYZ_coordinates_features_obstacle(:,1),-XYZ_coordinates_features_obstacle(:,2),'.')
    hold on
    plot(obstacle_location(1),obstacle_location(2),'.r','Markersize',20)
    hold off
    
%     figure(3)
%     plot3(XYZ_coordinates_features_obstacle(:,1),-XYZ_coordinates_features_obstacle(:,2),XYZ_coordinates_features_obstacle(:,3),'.')
%     hold on
%     plot3(obstacle_location(1),obstacle_location(2),obstacle_location(3),'.r','Markersize',20)
%     hold off
    
    img_nr
    pause
    
end

obstacle_location_list = obstacle_location_list(2:end,:);