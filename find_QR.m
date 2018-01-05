function find_QR()
% function find_QR()

% get file names:
dir_name = 'QR_images';
image_names = makeListOfFiles(dir_name, 'jpg');
image_names = sort_nat(image_names);
n_images = length(image_names);

% filter images
for im = 1:n_images
    RGB = imread([dir_name '/' image_names{im}]);
    RGB = double(RGB) ./ 255;
    find_QR_image(RGB);
    
end
