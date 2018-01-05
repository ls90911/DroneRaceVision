function generate_dataset_QR_codes()
% function generate_dataset_QR_codes()
 
save_distorted_sample_images = false; % for making a data set for QR code detection
im_file_name = 'QR_codes_positives/QR_';
im_type = 'png';

save_features = true; % for making a feature data set for QR code detection / recognition
save_negative_features = false;

debug_graphics = false;

% get file names of QR code images:
QR_dir_name = 'QR_codes_competition/Image';
QR_image_names = makeListOfFiles(QR_dir_name, 'png');
QR_image_names = sort_nat(QR_image_names);
n_QR_images = length(QR_image_names);
QR_labels = cumsum(ones(n_QR_images, 1));

% parameters for data generation:
n_samples_per_QR = 1500;
im_size = 70;
im_size_variation = 0.2*im_size;

% features:
% we use integral images to get the illuminance in a region as a ratio to
% the total illuminance in the region:
cell_structure = [3, 10];
n_features = 0;
for cs = 1:length(cell_structure)
    n_features = n_features + cell_structure(cs) * cell_structure(cs);
end

if(save_negative_features)
    negative_dir = 'C:\Roland_gates\full_images\image_with_obstacle\';
    negative_names = makeListOfFiles(negative_dir, 'png');
    n_negative_images = length(negative_names);
    n_samples = 100000;
    n_samples_image = floor(n_samples / n_negative_images);
    n_samples = n_samples_image * n_negative_images;
    NegativeFeatures = zeros(n_samples, n_features);
    sample = 0;
    for im = 1:n_negative_images
        
        fprintf('Negative image %d / %d\n', im, n_negative_images);
        
        RGB = imread([negative_dir negative_names{im}]);
        Im = double(rgb2gray(RGB)) ./ 255;
        
        for s = 1:n_samples_image
            sample = sample + 1;
            Im_Patch = getRandomPatch(Im, im_size, im_size_variation);
            Im_Patch = distort_QR_image(Im_Patch, size(Im_Patch, 1), im_size_variation);
            NegativeFeatures(sample, :) = get_integral_features(Im_Patch, cell_structure);
        end
    end
    
    save('NegativeFeatures', 'NegativeFeatures');
    NegativeLabels = zeros(sample, 1);
    save('NegativeLabels', 'NegativeLabels');
end

Features = zeros(n_samples_per_QR*n_QR_images, n_features);
Labels = zeros(n_samples_per_QR*n_QR_images, 1);
sample = 0;
for qr = 1:n_QR_images
    fprintf('QR label %d / %d\n', qr, n_QR_images);
    
    % load the QR image:
    QR_RGB = imread([QR_dir_name '/' QR_image_names{qr}]);
    % transform it to grayscale and in the interval [-1, 1]:
    QR_Im = double(rgb2gray(QR_RGB)) ./ 255;
    QR_Im = imresize(QR_Im, [im_size, im_size]);
    for s = 1:n_samples_per_QR
        % increment the number of samples:
        sample = sample + 1;
        % Set the label:
        Labels(sample) = QR_labels(qr);
        % Distort the image:
        QR_Im_distorted = distort_QR_image(QR_Im, im_size, im_size_variation);
        if(save_distorted_sample_images)
            imwrite(QR_Im_distorted, [im_file_name num2str(sample) '.' im_type]);
        end
        if(debug_graphics)
            h = figure();
            subplot(1,2,1); imshow(QR_Im);
            subplot(1,2,2); imshow(QR_Im_distorted);
            waitforbuttonpress;
            close(h);
        end
        
        Features(sample, :) = get_integral_features(QR_Im_distorted, cell_structure);
    end
end

if(save_features)
    save('Features', 'Features');
    save('Labels', 'Labels');
    PositiveLabels = ones(sample, 1);
    save('PositiveLabels', 'PositiveLabels');
end


function Im_Patch = getRandomPatch(Im, im_size, im_size_variation)
% function Im_Patch = getRandomPatch(Im, im_size, im_size_variation)
width = size(Im, 2);
height = size(Im, 1);
sv = round(rand(1) * 2 * im_size_variation - im_size_variation);
im_size = im_size + sv;
x = 1 + floor(rand(1) * (width - 1 - im_size));
y = 1 + floor(rand(1) * (height - 1 - im_size));
Im_Patch = Im(y:y+im_size, x:x+im_size, :);

