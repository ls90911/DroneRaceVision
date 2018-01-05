function [Prediction, Uncertainty] = predict_QR_code_image(image_name, Im)
% function [Prediction, Uncertainty] = predict_QR_code_image(image_name, Im)

% *************
% PREPARE WEKA:
% *************

% import the right classes from WEKA
% IF ERROR: it may be that MATLAB gives an error before even wanting to run this
% function, then copy-paste the following into the command window:
javaaddpath('C:\Program Files\Weka-3-8\weka.jar');

import weka.classifiers.Classifier
import weka.classifiers.trees.*
import weka.classifiers.Evaluation;
import weka.core.*
import java.util.ArrayList

% read a learned random forest model:
j48 = weka.core.SerializationHelper.read('QR_J48.model');

if(~exist('cell_structure', 'var') || isempty(cell_structure))
    cell_structure = [3, 10];
end
if(~exist('n_QR_images', 'var') || isempty(n_QR_images))
    QR_dir_name = 'QR_codes_competition\Image';
    QR_image_names = makeListOfFiles(QR_dir_name, 'png');
    QR_image_names = sort_nat(QR_image_names);
    n_QR_images = length(QR_image_names);
end

% attributes of a sample:
a = 0;
for cs = 1:length(cell_structure)
    for c = 1:cell_structure(cs) * cell_structure(cs);
        a = a + 1;
        Attributes(a) = Attribute(['cell_' num2str(cs) '_' num2str(c)]);
    end
end
n_attributes = a;
% class values:
fvClassVal = FastVector(n_QR_images);
for q = 1:n_QR_images
    fvClassVal.addElement(['QR ' num2str(q)]);
end
ClassAttribute = Attribute('class', fvClassVal);

% joining attributes and class in a vector:
fvWekaAttributes = FastVector(n_attributes+1);
for a = 1:n_attributes
    fvWekaAttributes.addElement(Attributes(a));
end
fvWekaAttributes.addElement(ClassAttribute);

% *****************
% LOOP OVER IMAGES:
% *****************

debug_graphics = true;

% get file names of QR code images:
QR_dir_name = 'QR_codes_competition\Image';
QR_image_names = makeListOfFiles(QR_dir_name, 'png');
QR_image_names = sort_nat(QR_image_names);
n_QR_images = length(QR_image_names);
QR_labels = cumsum(ones(n_QR_images, 1));

% parameters for data generation:
im_size = 70;
im_size_variation = 10;

% features:
% we use integral images to get the illuminance in a region as a ratio to
% the total illuminance in the region:
n_features = 0;
for cs = 1:length(cell_structure)
    n_features = n_features + cell_structure(cs) * cell_structure(cs);
end

n_samples = 1000;
% create a dataset:
dataset = Instances('IntegralQR', fvWekaAttributes, n_samples);
dataset.setClassIndex(dataset.numAttributes() - 1);

% for s = 1:n_samples
if(exist('image_name', 'var') && ~isempty(image_name))
    
    Im = imread(image_name);
    Im = double(rgb2gray(Im)) ./ 255;
end

features = get_integral_features(Im, cell_structure);

% make a single instance:
instance = DenseInstance(n_attributes+1);

% fill it:
for f = 1:length(features)
    instance.setValue(f-1, features(f));
end
%instance.setValue(f, label);

% link the instance to the data set and the other way around:
dataset.add(instance);
instance.setDataset(dataset);

% get the distribution
d = j48.distributionForInstance(instance);
Uncertainty = getEntropy(d / sum(d));
Prediction = j48.classifyInstance(instance);
Prediction = Prediction+1;

h = figure();
imshow(Im); title(['Predicted ' num2str(Prediction) ' Uncertainty ' num2str(Uncertainty)]);
waitforbuttonpress;
close(h);
% end
