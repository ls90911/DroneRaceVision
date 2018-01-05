function predict_ground()

% *************
% PREPARE WEKA:
% *************

% import the right classes from WEKA
javaaddpath('C:\Program Files\Weka-3-8\weka.jar');

import weka.classifiers.Classifier
import weka.classifiers.trees.RandomForest
import weka.classifiers.Evaluation;
import weka.core.*
import java.util.ArrayList

% read a learned random forest model:
rf = weka.core.SerializationHelper.read('RandomForest.model');
% attributes of a sample:
Attribute1 = Attribute('H');
Attribute2 = Attribute('S');
Attribute3 = Attribute('V');
% class values:
fvClassVal = FastVector(2);
fvClassVal.addElement('obstacle');
fvClassVal.addElement('ground');
ClassAttribute = Attribute('class', fvClassVal);
% joining attributes and class in a vector:
fvWekaAttributes = FastVector(4);
fvWekaAttributes.addElement(Attribute1);
fvWekaAttributes.addElement(Attribute2);
fvWekaAttributes.addElement(Attribute3);
fvWekaAttributes.addElement(ClassAttribute);

% *****************
% LOOP OVER IMAGES:
% *****************

% get file names:
dir_name = 'images';
image_names = makeListOfFiles(dir_name, 'jpg');
image_names = sort_nat(image_names);
n_images = length(image_names);

% create a dataset:
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
    % convert to HSV:
    HSV = rgb2hsv(RGB);
    H = HSV(:,:,1);
    S = HSV(:,:,2);
    V = HSV(:,:,3);
    Y = repmat(cumsum(ones(size(HSV,1), 1)), [1, size(HSV,2)]);
    C = (Y <= size(HSV,1) / 2);
    % create a dataset:
    dataset = Instances('HSV', fvWekaAttributes, size(HSV,1)*size(HSV,2));
    dataset.setClassIndex(dataset.numAttributes() - 1);
    
    Features = [H(:), S(:), V(:)];
    Labels = C(:);
    
    n_features = size(Features,1);
    Uncertainty = zeros(n_features, 1);
    Predictions = zeros(n_features, 1);
    step = floor(n_features / 20);
    fprintf('Evaluating features: ');
    for f = 1:n_features
        
        if(mod(f, step) == 0)
            fprintf('.');
        end
        
        % make a single instance:
        instance = DenseInstance(4);
        % fill it:
        instance.setValue(0, H(f));
        instance.setValue(1, S(f));
        instance.setValue(2, V(f));
        instance.setValue(3, C(f));
        
        % link the instance to the data set and the other way around:
        dataset.add(instance);
        instance.setDataset(dataset);
        
        % get the distribution
        d = rf.distributionForInstance(instance);
        Uncertainty(f) = getEntropy(d / sum(d));
        Predictions(f) = rf.classifyInstance(instance);
    end
    fprintf('\n');
    UIm = reshape(Uncertainty, [size(HSV,1), size(HSV,2)]);
    PIm = reshape(Predictions, [size(HSV,1), size(HSV,2)]);
    
    h = figure();
    subplot(1,2,1);
    imagesc(PIm);
    title('Predictions');
    subplot(1,2,2);
    imagesc(UIm);
    title('Uncertainty');
    waitforbuttonpress;
    close(h);
end



% % make a single instance:
% instance = DenseInstance(4);
% % fill it:
% instance.setValue(0, 0.5);
% instance.setValue(1, 0.5);
% instance.setValue(2, 0.5);
% instance.setValue(3, 0);
% % link the instance to the data set and the other way around:
% dataset.add(instance);
% instance.setDataset(dataset);
% 
% % cls = javaObject('weka.classifiers.trees.RandomForest');
% % cls = RandomForest();
% d = rf.distributionForInstance(instance);
% c = rf.classifyInstance(instance);



% % calling classifier from matlab
% v1 = java.lang.String('-t');
% v2 = java.lang.String('WEKA_HOME\trainData.arff');
% 
% v3 = java.lang.String('-T');
% v4 = java.lang.String('WEKA_HOME\testDATA.arff');
% 
% prm = cat(1,v1,v2,v3,v4);
% 
% Evaluation.evaluateModel(javaObject('weka.classifiers.bayes.BayesNet'),prm);