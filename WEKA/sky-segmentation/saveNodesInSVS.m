function saveNodesInSVS(FEATURES, tree_file_name, name_tree, LOAD_TRAINING_SEGMENTATION, m_adjust_tree, std_file_name)
% function saveNodesInSVS(FEATURES, tree_file_name, name_tree, LOAD_TRAINING_SEGMENTATION, m_adjust_tree, std_file_name)
% saves the tree specified by tree_file_name in C-code for the SVS Surveyor
%
% - tree_file_name: filename with the WEKA J48 tree in it
% - name_tree: name that will be appended to 'segment' in the C-function
% name
% - FEATURES: string containing all features used in the tree.
% - LOAD_TRAINING_SEGMENTATION: whether or not to load previously segmented
% - m_adjust_tree: determines how much the thresholds in the tree are
% adjusted. Positive values result in more sky-classifications. 1 means a
% change of 1 standard deviation. A standard factor is 0.25. Default = 0.
% - std_file_name: during training the standard deviations of all features
% are determined. These standard deviations are used for adjusting a decision 
% tree. This parameter should equal the name of the matlab file with
% standard deviations. 
%
% This implementation does no intelligent things. For example, if the
% gradient is used twice in the same sub-tree, it only has to be calculated
% once. This algorithm will calculate it twice.

if(~exist('LOAD_TRAINING_SEGMENTATION', 'var') || sum(size(LOAD_TRAINING_SEGMENTATION)) < 2)
    LOAD_TRAINING_SEGMENTATION = false;
end
params.LOAD_TRAINING_SEGMENTATION = LOAD_TRAINING_SEGMENTATION;
if(~exist('m_adjust_tree', 'var') || sum(size(m_adjust_tree)) < 2)
    m_adjust_tree = 0;
end

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
% adjust the tree before saving, if necessary:
if(m_adjust_tree ~= 0)
    if(~exist('std_file_name', 'var') || sum(size(std_file_name)) < 2)
        error('Please provide filename that contains standard deviations used for adjusting the tree.');
    else
        load(std_file_name);
        if(ALL_YCV)
            load('adjust_tree_direction_YCV');
        end
        nodes = adjustTree(nodes, m_adjust_tree, std_info, adjust_tree_direction);
    end
end

% ******************
% WRITING THE C-FILE
% ******************

filename = ['segment' name_tree '.c'];
fid = fopen(filename, 'w');
if(fid ~= -1)
    indentation = 0;
    fprintf(fid, ['extern void segment' name_tree '(unsigned char *frame_buf, unsigned char *frame_buf2)\n']);
    fprintf(fid, '{\n');
    indentation = indentation + 1;
    printTabs(indentation, fid); fprintf(fid, '// use a pre-defined tree to segment the image:\n');
    printTabs(indentation, fid);	fprintf(fid, '// the second buffer (image) stores the uncertainties between 0 and 100.\n');
    
    % This method will for now initialize too many variables: we do not
    % check which ones are used in the tree.
    
    % The initialization of all int-variables:
    int_variables = 'int x, y';
    if(params.ILL)
        int_variables = [int_variables, ', maxY'];
    end
    if(params.YCO)
        int_variables = [int_variables, ', YCO_threshold'];
    end
    if(params.GRA)
        int_variables = [int_variables, ', dx, dy, gradient, relative_gradient, maxGradient'];
    end
    if(params.HAR)
        int_variables = [int_variables, ', Noble, Harris'];
    end
    if(params.PMN || params.PSD || params.PEN || params.TEX || params.TRM || params.SMN)
        int_variables = [int_variables, ', patch_size'];
        if(params.PMN)
            int_variables = [int_variables, ', patch_mean'];
        end
        if(params.TEX)
            int_variables = [int_variables, ', patch_texture'];
        end
    end
    if(params.FLD)
        int_variables = [int_variables, ', FD_YCV, FD_CV'];
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
    
    % code for iterating over the image:
    printTabs(indentation, fid); fprintf(fid, 'for(x = 0; x < imgWidth; x++)\n');
    printTabs(indentation, fid); fprintf(fid, '{\n');
    indentation = indentation + 1;
	printTabs(indentation, fid); fprintf(fid, 'for(y = 0; y < imgHeight; y++)\n');
    printTabs(indentation, fid); fprintf(fid, '{\n');
    indentation = indentation + 1;
	printTabs(indentation, fid); fprintf(fid, 'ix = image_index(x,y);\n');
    fprintf(fid, '\n');
    % print the tree:
    printNodes(nodes, fid, indentation, 1); % should do a depth-first print of the tree
    
    % code for iterating over the image:
    removeIndentation(indentation, fid);
    fclose(fid); 
end



