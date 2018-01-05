addpath('../');

%% DATA SET:
DISPARITY_MAPS = false; % directly load the disparity map as calculated by the stereo vision system
STEREO_COLOR = true;
set_name = 'disp_color_images_circle'; % set 2 is not well pixel-shifted

%% STEREO DEFINES
% image parameters
width = 128;
height = 96;

% camera parameters
cam_params = [130 -0.3 64 48 60];   % [ focal_length[px] cx_diff[px] cx[px] cy[px] baseline[mm] ] 

% if not calibrated onboard, shift the images here:
v_shift_R = 0;
h_shift_R = 7;

% stereo vision settings
DIFF_THRESHOLD = 2;
FEATURE_FACTOR = 1.4;


%% PROCESS IMAGES ONE BY ONE

dir_name = ['../' set_name '/'];
file_names = makeListOfFiles(dir_name, 'bmp');
file_names = sort_nat(file_names);
img_nrs = 1:length(file_names);

% evolution over the images:
RETAIN_POPULATION = false;

for img_nr = img_nrs
    
    % print the image number:
    fprintf('Image %d / %d\n', img_nr, length(file_names));
    %% Stereo vision processing:
    stereo_graphics = true;
    if(DISPARITY_MAPS)
        % directly load the disparity map:
        RESOLUTION = 6;
        Disp_map = rgb2gray(imread([dir_name file_names{img_nr}]));
        Disp_map = double(Disp_map) ./ RESOLUTION;
        % strangely, the last column is always high:
        Disp_map(:, end) = 0;
        
        if(stereo_graphics)
            h1 = figure();
            image(Disp_map,'CDataMapping','direct');
            colorbar;
            title('Disparity map');
            waitforbuttonpress;
            close(h1);
        end
    else
        if(~STEREO_COLOR)
            % load a stereo image pair and calculate disparities here:
            I = imread([dir_name file_names{img_nr}]);    
        else
            StereoColor = imread([dir_name file_names{img_nr}]);
            Im = StereoColor(2:2:end, :, :);
            I = [Im(:, 1:2:end, :), Im(:, 2:2:end, :)];
            C = StereoColor(1:2:end, :, :);
            YUV = transformColor2YUV(C);
            height = size(I,1);
            width = size(I,2)/2;
        end
        
        imgR_3 = I(:,1:width,:);
        imgR_3 = shiftImage(imgR_3, v_shift_R, h_shift_R);
        imgL_3 = I(:,width+1:end,:);
        
        imgFeature_3 = imgL_3(:,:,:);
        imgStereo_3 =  imgR_3(:,:,:);
        
        imgR_1 = imgR_3(:,:,1);
        imgL_1 = imgL_3(:,:,1);
        
        imgFeature_1 = imgFeature_3(:,:,1);
        
        % actual stereo vision algorithm:
        [image_coordinates_stereo, Disp_map] = run_SparseStereo_one_sided( imgL_1, imgR_1, width, height, cam_params, DIFF_THRESHOLD, FEATURE_FACTOR);
        
        % convert disparities and image locations to 3D points:
        XYZ_coordinates_features = imageXYD_to_3DXYZ( cam_params, image_coordinates_stereo );
        
        % show the results:
        if(stereo_graphics)
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
        end
    end
    %% Find the gate:
    SQUARE = 1; CIRCLE = 2;
    shape = CIRCLE;
    min_disp_threshold = 2;
    if(~STEREO_COLOR)
        [P, W] = convert_disparitymap_to_points(Disp_map, min_disp_threshold);
    else
        JUST_COLOR = false;
        if(JUST_COLOR)
            [P, W] = convert_YUV_to_points(YUV);
        else
            [P, W] = convert_disparitymap_to_points(Disp_map, min_disp_threshold, YUV);
        end
    end
    fprintf('Number of points: %d\n', size(P,1));
    wp = P .* [W, W] ./ mean(W);
    if(~RETAIN_POPULATION || img_nr == 1 || best_fit > 0.10) %0.05)
        pos0 = mean(wp);
        radius0 = mean(std(wp));
    else
        % use the result of the previous evolution:
        pos0(1) = x;
        pos0(2) = y;
        radius0 = s;
    end
    [x, y, s, best_fit] = fit_window_to_points(P, pos0(1), pos0(2), radius0, W, shape);
    
    h2 = figure();
    subplot(1,3,1);
    hold on;
    for p = 1:size(P,1)
        plot(P(p,1), height - P(p,2), 'x', 'LineWidth', W(p), 'MarkerSize', W(p), 'Color', 'red');
    end
    circle(x,height-y,s, [0 0 0], 5);
    plot([x x], [height-(y+s), height-(y+2*s)], 'Color', [0 0 0], 'LineWidth', 5);
    title(['Point representation, fit = ' num2str(best_fit)]);
    subplot(1,3,2);
    imagesc(Disp_map);
    hold on;
    circle(x,y,s, 'red', 5);
    plot([x x], [y+s, y+2*s], 'Color', 'red', 'LineWidth', 5);
    title('Disparity map');
    subplot(1,3,3);
    if(~DISPARITY_MAPS)
        if(~STEREO_COLOR)
            imshow(imgL_3);
        else
            imshow(ycbcr2rgb(YUV));
            hold on;
            plot(P(:,1)/2, P(:,2), 'o', 'Color', [1 1 1]);
        end
    end
    title('Left image');
    
    %% Pause after each image:
    % waitforbuttonpress;
    pause(1.0);
    % pause;
    close(h2);
end

obstacle_location_list = obstacle_location_list(2:end,:);