function correct_image_size(dir_name)
% to correct for strange SmartUAV images

file_names = makeListOfFiles(dir_name, 'bmp');
for f = 1:length(file_names)
    I = imread([dir_name file_names{f}]);
    I = I(1:96, 1:256, :);
    imwrite(I, [dir_name file_names{f}]);
end