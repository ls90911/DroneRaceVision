function train_Viola_and_Jones_QR()
% function train_Viola_and_Jones_QR()

% output XML:
outputXMLFilename = 'QR_detector.xml';

% get the positive samples:
positive_dir = 'C:\QR_codes\QR_codes_positives\';
positive_names = makeListOfFiles(positive_dir, 'png');
n_positive_images = length(positive_names);
Im = imread([positive_dir positive_names{1}]);
width = size(Im,2);
height = size(Im,1);
objectBoundingBox = [1, 1, width-1, height-1];
positiveInstances = [];
for im = 1:n_positive_images
    pstruct.imageFilename = [positive_dir positive_names{im}];
    pstruct.objectBoundingBoxes = objectBoundingBox;
    positiveInstances = [positiveInstances; pstruct];
end

% get the negative samples:
negative_dir = 'C:\Roland_gates\full_images\image_with_obstacle\';
negative_names = makeListOfFiles(negative_dir, 'png');
for im = 1:length(negative_names)
    negative_names{im} = [negative_dir negative_names{im}];
end
negativeImages = negative_names;

% train:
trainCascadeObjectDetector(outputXMLFilename,positiveInstances,negativeImages); % saved in the xml
