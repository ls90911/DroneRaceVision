function correct_SmartUAV_images(dir_name)
% to correct for interlaced SmartUAV images

file_names = makeListOfFiles(dir_name, 'bmp');
for f = 1:length(file_names)
    I = imread([dir_name file_names{f}]);
    R = I(1:2:end, :, :);
    L = I(2:2:end, :, :);
    I = [R, L];
    I = rgb2gray(I);
    imwrite(I, [dir_name file_names{f}]);
end