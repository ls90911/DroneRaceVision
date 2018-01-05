function test_Viola_and_Jones_QR(im_dir)
% function test_Viola_and_Jones_QR(im_dir)

% output XML:
outputXMLFilename = 'QR_detector.xml';

detector = vision.CascadeObjectDetector('QR_detector_old.xml');

if(exist('im_dir', 'var') && ~isempty(im_dir))
    im_names = makeListOfFiles(im_dir, 'jpg');
end
% for now we read in negatives and copy paste the positive images:

positive_dir = 'C:\QR_codes\QR_codes_positives\';
positive_names = makeListOfFiles(positive_dir, 'png');
n_positive_images = length(positive_names);
PIm = imread([positive_dir positive_names{1}]);

negative_dir = 'C:\Roland_gates\full_images\image_with_obstacle\';
negative_names = makeListOfFiles(negative_dir, 'png');
n_negative_images = length(negative_names);

n_samples = 100;

for s = 1:n_samples
    
    if(~exist('im_dir', 'var') || isempty(im_dir))
        im = 1 + floor(rand(1) * (n_negative_images-1));
        negative_name = [negative_dir negative_names{im}];
        Im = imread(negative_name);
        Im = double(rgb2gray(Im)) ./ 255;
        W = size(Im, 2);
        H = size(Im, 1);
        
        im = 1 + floor(rand(1) * (n_positive_images-1));
        positive_name = [positive_dir positive_names{im}];
        PIm = imread(positive_name);
        PIm = double(PIm) ./ 255;
        width_positive = size(PIm,2);
        height_positive = size(PIm,1);
        
        x = 1 + floor(rand(1) * (W-width_positive));
        y = 1 + floor(rand(1) * (H-height_positive));
        Im(y:y+height_positive-1, x:x+width_positive-1) = PIm;
    else
        ind = mod(s, length(im_names));
        if(ind == 0)
            ind = 1;
        end
        Im = imread([im_dir '/' im_names{ind}]);
        Im = double(rgb2gray(Im)) ./ 255;
        Im = imresize(Im, 0.2);
        W = size(Im, 2);
        H = size(Im, 1);
    end
    bbox = step(detector,Im);
    
    detectedImg = Im;
    border = 5;
    for bb = 1:size(bbox, 1)
        x_min = max([1, bbox(bb, 1)-border]);
        x_max = min([W, bbox(bb, 1)+bbox(bb, 3)+border]);
        y_min = max([bbox(bb, 2)-border, 1]);
        y_max = min([H, bbox(bb, 2)+bbox(bb, 4)+border]);
        Patch = Im(y_min:y_max, x_min:x_max);
        detectedImg = insertObjectAnnotation(detectedImg,'rectangle',bbox(bb, :), 'QR code');
%         [is_QR, QR_nr] = evaluate_QR_Patch(Patch);
%         if(is_QR)
%             detectedImg = insertObjectAnnotation(detectedImg,'rectangle',bbox(bb, :),['QR code' num2str(QR_nr)]);
%         end
    end
    
    % put all bounding boxes with the same text:
    %     detectedImg = insertObjectAnnotation(Im,'rectangle',bbox,'QR code');
    
    h = figure;
    imshow(detectedImg);
%     imshow(Im);
    waitforbuttonpress;
    close(h);
end

