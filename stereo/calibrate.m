function calibrate(dir_name, STEREO_COLOR)
% calibrate the shifts etc.

if(~exist('STEREO_COLOR', 'var') || isempty(STEREO_COLOR))
    STEREO_COLOR = false;
end

% v_shift that is to be used:
v_shift_R = 0; %-9;
h_shift_R = 7; %5;

% single image size
w = 128;
h = 96;
if(STEREO_COLOR)
    h = h / 2;
end

% stereo vision settings
DIFF_THRESHOLD = 2;
FEATURE_FACTOR = 1.4;

% prepare masks for showing the images in red / blue
Red = zeros(h,w,3);
Red(:,:,1) = 1;
Blue = zeros(h,w,3);
Blue(:,:,3) = 1;

file_names = makeListOfFiles(dir_name, 'bmp');
for f = 1:length(file_names)
    
    if(STEREO_COLOR)
        StereoColor = imread([dir_name file_names{f}]);
        Im = StereoColor(2:2:end, :, :);
        I = [Im(:, 1:2:end, :), Im(:, 2:2:end, :)];
    else
        % load the image:
        I = imread([dir_name file_names{f}]);
    end
    imgR_3 = I(:,1:w,:);
    imgL_3 = I(:,w+1:end,:);
        
    % shift the right image to match the two, and show them with color masks:
    I = double(I) ./ 255;
    R = I(:,1:w,:);
    L = I(:,w+1:end, :);
    R = shiftImage(R, v_shift_R, h_shift_R);
    figure(1);
    imshow(L.*0.5.*Blue+R.*0.5.*Red);
    
    % perform stereo matching:
    cam_params = [130 -0.3 64 48 60];
    imgR_3 = shiftImage(imgR_3, v_shift_R, h_shift_R);
    imgR_1 = imgR_3(:,:,1);
    imgL_1 = imgL_3(:,:,1);
    [image_coordinates_stereo, Disp_map] = run_SparseStereo_one_sided( imgL_1, imgR_1, ...
                                            w, h, cam_params, DIFF_THRESHOLD, FEATURE_FACTOR);
    
    figure(2);
    imagesc(Disp_map);
    pause;
end