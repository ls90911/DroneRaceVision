function learn_ground()
% function learn_ground()

% get file names:
dir_name = 'images';
image_names = makeListOfFiles(dir_name, 'jpg');
image_names = sort_nat(image_names);
n_images = length(image_names);

% create a dataset:
Features = [];
Labels = [];
for im = 1:n_images
    fprintf('Image %d / %d\n', im, n_images);
    
    RGB = imread([dir_name '/' image_names{im}]);
    RGB = double(RGB) ./ 255;
    if(strcmp(dir_name, 'images'))
        RGB = imrotate(RGB, 90);
    end
    if(strcmp(dir_name, 'phone_images'))
        RGB = imresize(RGB, 0.25);
    end
        
    %     figure(); imshow(RGB);
    %     title('RGB image');
    
    HSV = rgb2hsv(RGB);
    
    n_pixels_image = 1000;
    [HSV_pixels, Y] = sample_HSV_pixels(HSV, n_pixels_image);
    Ground = (Y <= size(RGB,1)/2);
    
    Features = [Features; HSV_pixels];
    Labels = [Labels; Ground];
end

generate_dataset_for_weka(Features, Labels);


