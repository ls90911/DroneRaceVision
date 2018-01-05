function saveNodesInSVSAdjustTree(FEATURES, tree_file_name, name_tree, LOAD_TRAINING_SEGMENTATION)
% function saveNodesInSVSAdjustTree(FEATURES, tree_file_name, name_tree, LOAD_TRAINING_SEGMENTATION)
% saves the tree specified by tree_file_name in C-code for the SVS Surveyor
%
% - tree_file_name: filename with the WEKA J48 tree in it
% - name_tree: name that will be appended to 'segment' in the C-function
% name
% - FEATURES: string containing all features used in the tree.
% - LOAD_TRAINING_SEGMENTATION: whether or not to load previously segmented
%
% This implementation does no intelligent things. For example, if the
% gradient is used twice in the same sub-tree, it only has to be calculated
% once. This algorithm will calculate it twice.

if(~exist('LOAD_TRAINING_SEGMENTATION', 'var') || sum(size(LOAD_TRAINING_SEGMENTATION)) < 2)
    LOAD_TRAINING_SEGMENTATION = false;
end
params.LOAD_TRAINING_SEGMENTATION = LOAD_TRAINING_SEGMENTATION;

% ********
% FEATURES
% ********

ALL_YCV = true;

params.ALL_YCV = ALL_YCV;
params.explanation = 'parameters';
[params.VWK, params.VAN, params.RGB, params.HSV, params.HDS, params.YCV, params.BGR, params.ILL, ...
    params.PMN, params.PSD, params.PEN, params.UNI, params.YCO, params.TEX, params.TRM, params.SMN, ...
    params.GRA, params.CFB, params.HAR, params.GNS, params.FLD] = processMethodString(FEATURES, ALL_YCV, LOAD_TRAINING_SEGMENTATION, params);

if(params.VWK)
    if(~exist('params.n_words','var') || sum(size(params.n_words)) == 0)
        params.VWK_ratio = 1;
        params.patch_size = 5;
        params.n_words = 30;
        params.VWK_TO_GRAY = false;
        params.VWK_n_images = 150;
        params.outputToScreen = true;
        params.graphics = true;
        params.FULL_SAMPLING = false;
        params.n_samples = 100;
        % number of vertical separations, n_bins = V_S + 1
        params.VERTICAL_SEPARATION = 0;
    end
    % Visual Words neighbors:
    if(params.VAN)
        % settings:
        params.N_NEIGHBORS = 4;
        params.FULL_SAMPLING = true;
        params.distance_neighbors = 10;
    end
end
if(params.PMN || params.PSD || params.PEN || params.TEX || params.TRM || params.SMN)
    patch_params.TO_GRAY = true; % params.patch_TO_GRAY;
    if(patch_params.TO_GRAY)
        patch_params.n_channels_patch = 1;
    else
        patch_params.n_channels_patch = 3;
    end
    patch_params.fixed_patch_size = 10;    
    % which methods are used is put in patch_params
    patch_params.PMN = params.PMN;
    patch_params.PSD = params.PSD;
    patch_params.PEN = params.PEN;
    patch_params.UNI = params.UNI;
    patch_params.TEX = params.TEX;
    patch_params.TRM = params.TRM;
    patch_params.SMN = params.SMN;
    params.patch_params = patch_params;
end
if(params.CFB)
    addpath('../clustering/');
    params.n_images = 30;
    if(~exist('params','var') || sum(size(params)) == 0)
        params.MR8 = false;
        params.LMF = true;
        params.nClusters = 10;
        params.nIter = 100;
        params.ratio = 0.25;
        params.TO_GRAY = true;
        % number of vertical separations, n_bins = V_S + 1        
        params.VERTICAL_SEPARATION = 1;
        paramsoutputToScreen = true;
    end
    
    if(params.LMF)
        params.LMFilters = makeLMFilters;
    end
end
if(LOAD_TRAINING_SEGMENTATION)
    params.region_size = 5;
end
if(params.HDS)
    params.hds_region_size = 10;
    params.hds_n_samples = 25;
    params.hds_n_bins = 10;
end

[attributes, params] = getWEKAAttributes(params);

% **********
% CLASSIFIER
% **********

classes = cell(2,1);
classes{1} = 'ground';
classes{2} = 'sky';
nodes = readTree(tree_file_name, attributes, classes);

% *******************
% FOR ADJUSTING TREE:
% *******************

namefile = [FEATURES '_TREE'];
if(params.VWK)
    if(~params.FULL_SAMPLING)
        namefile = [namefile '_S' num2str(params.n_samples)];
    end
    if(params.VERTICAL_SEPARATION)
        namefile = [namefile '_VS'];
    end
    if(params.VWK_TO_GRAY)
        namefile = [namefile '_GRAY'];
    end
    if(params.VWK_ratio < 1)
        namefile = [namefile '_R' num2str(params.ratio * 1000)];
    end
    namefile = [namefile '_W' num2str(params.n_words)];
    namefile = [namefile '_P' num2str(params.patch_size)];
end
namefile = [namefile '.mat'];
load('adjust_tree_direction');
k = 1;
load(['std_info_k' num2str(k) '_' namefile]);

% ******************
% WRITING THE C-FILE
% ******************

filename = ['segment_' name_tree 'AdjustTree.c'];
fid = fopen(filename, 'w');
if(fid ~= -1)
    indentation = 0;
    fprintf(fid, ['extern void segment_' name_tree 'AdjustTree(unsigned char *frame_buf, unsigned char *frame_buf2, int adjust_factor)\n']);
    fprintf(fid, '{\n');
    indentation = indentation + 1;
    printTabs(indentation, fid); fprintf(fid, '// use a pre-defined tree to segment the image:\n');
    printTabs(indentation, fid);	fprintf(fid, '// the second buffer (image) stores the uncertainties between 0 and 100.\n');
    
    % This method will for now initialize too many variables: we do not
    % check which ones are used in the tree.
    
    % The initialization of all int-variables:
    int_variables = 'int x, y';
    if(params.ILL)
        int_variables = [int_variables, ', maxY, adjust_rel_Y'];
    end
    if(params.YCO)
        int_variables = [int_variables, ', YCO_threshold'];
    end
    if(params.GRA)
        int_variables = [int_variables, ', dx, dy, gradient, relative_gradient, maxGradient, adjust_dx, adjust_dy, adjust_gradient, adjust_relative_gradient'];
    end
    if(params.HAR)
        int_variables = [int_variables, ', Noble, Harris, adjust_Noble, adjust_Harris'];
    end
    if(params.PMN || params.PSD || params.PEN || params.TEX || params.TRM || params.SMN)
        int_variables = [int_variables, ', patch_size'];
        if(params.PMN)
            int_variables = [int_variables, ', patch_mean, adjust_patch_mean'];
        end
        if(params.TEX)
            int_variables = [int_variables, ', patch_texture, adjust_patch_texture'];
        end
    end
    if(params.RGB)
        int_variables = [int_variables, ', adjust_Y, adjust_Cb, adjust_Cr'];
    end
    if(params.FLD)
        int_variables = [int_variables, ', FD_YCV, adjust_FD_YCV, FD_CV, adjust_FD_CV'];
    end
    int_variables = [int_variables, ';'];
    printTabs(indentation, fid);	fprintf(fid, [int_variables '\n']);
    % The initialization of all unsigned int variables:
    unsigned_int_variables = 'unsigned int ix';
    if(params.RGB)
        unsigned_int_variables = [unsigned_int_variables, ', Y, Cb, Cr'];
    elseif(params.ILL)
        unsigned_int_variables = [unsigned_int_variables, ', Y'];
    end
    unsigned_int_variables = [unsigned_int_variables, ';'];
    printTabs(indentation, fid);	fprintf(fid, [unsigned_int_variables '\n']);
    fprintf(fid, '\n');
    % calculate globally dependent variables, so that it is done only once:
    printTabs(indentation, fid); fprintf(fid, '// global variables, so that they are calculated / initialized only once:\n');
    if(params.ILL)
        printTabs(indentation, fid); fprintf(fid, 'maxY = getMaximumY(frame_buf);\n');
    end
    if(params.GRA)
        RELATIVE_GRADIENT = false; % is not used yet
        if(RELATIVE_GRADIENT)  
            printTabs(indentation, fid); fprintf(fid, 'maxGradient = getMaximumGradient(frame_buf);\n');
        end
    end
    if(params.PMN || params.PSD || params.PEN || params.TEX || params.TRM || params.SMN)
        printTabs(indentation, fid); fprintf(fid, 'patch_size = %d;\n', patch_params.fixed_patch_size);
    end
    fprintf(fid, '\n');
    
    
    printTabs(indentation, fid); fprintf(fid, '// variables for adjusting thresholds:\n');
    if(params.RGB)
        adjustment = getAdjustment('Channel_1', std_info, adjust_tree_direction);
        printTabs(indentation, fid); fprintf(fid, 'adjust_Y = adjust_factor * %d;\n', round(adjustment * 255));
        adjustment = getAdjustment('Channel_2', std_info, adjust_tree_direction);
        printTabs(indentation, fid); fprintf(fid, 'adjust_Cb = adjust_factor * %d;\n', round(adjustment * 255));
        adjustment = getAdjustment('Channel_3', std_info, adjust_tree_direction);
        printTabs(indentation, fid); fprintf(fid, 'adjust_Cr = adjust_factor * %d;\n', round(adjustment * 255));        
    end
    if(params.ILL)
        adjustment = getAdjustment('relative_illuminance', std_info, adjust_tree_direction);
        printTabs(indentation, fid); fprintf(fid, 'adjust_rel_Y = adjust_factor * %d;\n', round(adjustment * 100));
    end
    if(params.GRA)
        adjustment = getAdjustment('dx', std_info, adjust_tree_direction);
        printTabs(indentation, fid); fprintf(fid, 'adjust_dx = adjust_factor * %d;\n', round(adjustment * 255));
        adjustment = getAdjustment('dy', std_info, adjust_tree_direction);
        printTabs(indentation, fid); fprintf(fid, 'adjust_dy = adjust_factor * %d;\n', round(adjustment * 255));
        adjustment = getAdjustment('gradient', std_info, adjust_tree_direction);
        printTabs(indentation, fid); fprintf(fid, 'adjust_gradient = adjust_factor * %d;\n', round(adjustment * 255));
    end
    if(params.HAR)
        adjustment = getAdjustment('Noble', std_info, adjust_tree_direction);
        printTabs(indentation, fid); fprintf(fid, 'adjust_Noble = adjust_factor * %d;\n', round(adjustment * 255^2));
        adjustment = getAdjustment('Harris', std_info, adjust_tree_direction);
        printTabs(indentation, fid); fprintf(fid, 'adjust_Harris = adjust_factor * %d;\n', round(adjustment * 255^4));
    end
    if(params.PMN || params.PSD || params.PEN || params.TEX || params.TRM || params.SMN)
        if(params.PMN)
            adjustment = getAdjustment('PMN_1', std_info, adjust_tree_direction);
            printTabs(indentation, fid); fprintf(fid, 'adjust_patch_mean = adjust_factor * %d;\n', round(adjustment * 255));
        end
        if(params.TEX)
            adjustment = getAdjustment('TEX_1', std_info, adjust_tree_direction);
            printTabs(indentation, fid); fprintf(fid, 'adjust_patch_texture = adjust_factor * %d;\n', round(adjustment * 255));
        end
    end
    if(params.FLD)
        adjustment = getAdjustment('FD_YCV', std_info, adjust_tree_direction);
        printTabs(indentation, fid); fprintf(fid, 'adjust_FD_YCV = adjust_factor * %d;\n', round(adjustment * 100));
        getAdjustment('FD_CV', std_info, adjust_tree_direction);
        printTabs(indentation, fid); fprintf(fid, 'adjust_FD_CV = adjust_factor * %d;\n', round(adjustment * 100));
    end
    
    % code for iterating over the image:
    fprintf(fid, '\n\n');
    printTabs(indentation, fid); fprintf(fid, 'for(x = 0; x < imgWidth; x++)\n');
    printTabs(indentation, fid); fprintf(fid, '{\n');
    indentation = indentation + 1;
	printTabs(indentation, fid); fprintf(fid, 'for(y = 0; y < imgHeight; y++)\n');
    printTabs(indentation, fid); fprintf(fid, '{\n');
    indentation = indentation + 1;
	printTabs(indentation, fid); fprintf(fid, 'ix = image_index(x,y);\n');
    fprintf(fid, '\n');
    % print the tree:
    printNodes(nodes, fid, indentation, 1, false, true); % should do a depth-first print of the tree
    
    % code for iterating over the image:
    removeIndentation(indentation, fid);
    fclose(fid); 
end

function adjustment = getAdjustment(attribute_name, std_info, adjust_tree_direction)
% function adjustment = getAdjustment(attribute_name, std_info, adjust_tree_direction)
STD_FACTOR = 0.25;
ind1 = searchStdAtt(attribute_name, std_info{2,1}, true);
ind2 = searchStdAtt(attribute_name, adjust_tree_direction(:,1), false);
if(ind1 ~= -1 && ind2 ~= -1)
    adjustment = STD_FACTOR * std_info{1,1}(ind1) * adjust_tree_direction{ind2,2};
else
    adjustment = [];
end


