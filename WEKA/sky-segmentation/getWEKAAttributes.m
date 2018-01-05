function [attributes, params, n_attributes] = getWEKAAttributes(params)

% set / process parameters for the different feature extraction methods:
% IT IS *VERY IMPORTANT* THAT THE ORDER OF THE FEATURES BELOW IS EQUAL TO THE
% ORDER IN WHICH THEY WILL BE EXTRACTED FROM THE IMAGES.
% TRANSLATEDATATOWEKA.M MATCHES ON THE BASIS OF THIS ORDER.

n_attributes = 0;
% patch based features:
if(params.VWK)
    n_attributes = n_attributes + 1;
    % WEKA:
    attributes{n_attributes}.type = 1;
    attributes{n_attributes}.options = cell(params.n_words,1);
    for w = 1:params.n_words
       attributes{n_attributes}.options{w} = num2str(w); 
    end
    attributes{n_attributes}.name = 'VW_center';
    
    % Visual Words neighbors:
    if(params.VAN)
        % WEKA:
        for n = 1:params.N_NEIGHBORS
            attributes{n_attributes+n} = attributes{n_attributes};
        end
        attributes{n_attributes+1}.name = 'VW_top';
        attributes{n_attributes+2}.name = 'VW_right';
        attributes{n_attributes+3}.name = 'VW_bottom';
        attributes{n_attributes+4}.name = 'VW_left';
        n_attributes = n_attributes + params.N_NEIGHBORS;
    end
end
if(params.PMN || params.PSD || params.PEN || params.TEX || params.TRM || params.SMN || params.UNI)
    params.n_patch_attributes = 0;
    if(params.patch_params.TO_GRAY)
        n_channels_patch = 1;
    else
        n_channels_patch = 3;
    end
end
if(params.PMN) 
    for c = 1:n_channels_patch
        n_attributes = n_attributes + 1; 
        params.n_patch_attributes = params.n_patch_attributes + 1;
        % weka:
        attributes{n_attributes}.name = ['PMN_' num2str(c)];
        attributes{n_attributes}.type = 2;
    end
end
if(params.PSD) 
    for c = 1:n_channels_patch
        n_attributes = n_attributes + 1; 
        params.n_patch_attributes = params.n_patch_attributes + 1;
        % weka:
        attributes{n_attributes}.name = ['PSD_' num2str(c)];
        attributes{n_attributes}.type = 2;
    end
end
if(params.PEN) 
    for c = 1:n_channels_patch
        n_attributes = n_attributes + 1; 
        params.n_patch_attributes = params.n_patch_attributes + 1;
        % weka:
        attributes{n_attributes}.name = ['PEN_' num2str(c)];
        attributes{n_attributes}.type = 2;
    end
end
if(params.TEX) 
    for c = 1:n_channels_patch
        n_attributes = n_attributes + 1; 
        params.n_patch_attributes = params.n_patch_attributes + 1;
        % weka:
        attributes{n_attributes}.name = ['TEX_' num2str(c)];
        attributes{n_attributes}.type = 2;
    end
end
if(params.TRM) 
    for c = 1:n_channels_patch
        n_attributes = n_attributes + 1; 
        params.n_patch_attributes = params.n_patch_attributes + 1;
        % weka:
        attributes{n_attributes}.name = ['TRM_' num2str(c)];
        attributes{n_attributes}.type = 2;
    end
end
if(params.SMN)
    for c = 1:n_channels_patch
        n_attributes = n_attributes + 1; 
        params.n_patch_attributes = params.n_patch_attributes + 1;
        % weka:
        attributes{n_attributes}.name = ['SMN_' num2str(c)];
        attributes{n_attributes}.type = 2;
    end
end
if(params.UNI)
    for c = 1:n_channels_patch
        n_attributes = n_attributes + 1; 
        params.n_patch_attributes = params.n_patch_attributes + 1;
        % weka:
        attributes{n_attributes}.name = ['UNI_' num2str(c)];
        attributes{n_attributes}.type = 2;
    end
end
if(params.RGB)
     % weka:
    attributes{n_attributes+1}.name = 'Channel_1';
    attributes{n_attributes+1}.type = 2;
    attributes{n_attributes+2}.name = 'Channel_2';
    attributes{n_attributes+2}.type = 2;
    attributes{n_attributes+3}.name = 'Channel_3';
    attributes{n_attributes+3}.type = 2;    
    % number of attributes:
    n_attributes = n_attributes + 3;
end
if(params.HSV)
    % weka:
    attributes{n_attributes+1}.name = 'H';
    attributes{n_attributes+1}.type = 2;
    attributes{n_attributes+2}.name = 'S';
    attributes{n_attributes+2}.type = 2;
    attributes{n_attributes+3}.name = 'V';
    attributes{n_attributes+3}.type = 2;    
    % number of attributes:
    n_attributes = n_attributes + 3;
    if(params.BGR)
        % weka:
        attributes{n_attributes+1}.name = 'BGR_dx';
        attributes{n_attributes+1}.type = 2;
        attributes{n_attributes+2}.name = 'BGR_dy';
        attributes{n_attributes+2}.type = 2;
        attributes{n_attributes+3}.name = 'BGR_gradient';
        attributes{n_attributes+3}.type = 2;
        % number of attributes:
        n_attributes = n_attributes + 3;
    end
end
if(params.YCV)
    % weka:
    attributes{n_attributes+1}.name = 'Y';
    attributes{n_attributes+1}.type = 2;
    attributes{n_attributes+2}.name = 'Cb';
    attributes{n_attributes+2}.type = 2;
    attributes{n_attributes+3}.name = 'Cr';
    attributes{n_attributes+3}.type = 2;    
    % number of attributes:
    n_attributes = n_attributes + 3;
end

% filter based features:
if(params.CFB)
    n_filters = 8;
    prefix = 'CFB_';
    for f = 1:n_filters
        attributes{n_attributes+1}.name = [prefix num2str(f)];
        attributes{n_attributes+1}.type = 2;
    end
	n_attributes = n_attributes+ n_filters;
end
if(params.YCO)
    n_attributes = n_attributes + 1;
    attributes{n_attributes}.type = 2;
    attributes{n_attributes}.name = 'YCO';
end
if(params.GRA)
    attributes{n_attributes+1}.type = 2;
    attributes{n_attributes+1}.name = 'dx';
    attributes{n_attributes+2}.type = 2;
    attributes{n_attributes+2}.name = 'dy';
    attributes{n_attributes+3}.type = 2;
    attributes{n_attributes+3}.name = 'gradient';
    attributes{n_attributes+4}.type = 2;
    attributes{n_attributes+4}.name = 'relative_gradient';
    n_attributes = n_attributes + 4;
end
if(params.ILL)
    n_attributes = n_attributes + 1;
    attributes{n_attributes}.type = 2;
    attributes{n_attributes}.name = 'relative_illuminance';
    n_attributes = n_attributes + 1;
    attributes{n_attributes}.type = 2;
    attributes{n_attributes}.name = 'relative_min_ill';
end
if(params.LOAD_TRAINING_SEGMENTATION)
   % using pre-segmentations 
   attributes{n_attributes+1}.type = 2;
   attributes{n_attributes+1}.name = 'sky_at_pixel';
   attributes{n_attributes+2}.type = 2;
   attributes{n_attributes+2}.name = 'proportion_sky_above';
   attributes{n_attributes+3}.type = 2;
   attributes{n_attributes+3}.name = 'proportion_sky_below';
   n_attributes = n_attributes + 3;
end
if(params.HAR)
   attributes{n_attributes+1}.type = 2;
   attributes{n_attributes+1}.name = 'Noble';
   attributes{n_attributes+2}.type = 2;
   attributes{n_attributes+2}.name = 'Harris';
   n_attributes = n_attributes + 2;    
end
if(params.HDS)
    attributes{n_attributes+1}.type = 2;
    attributes{n_attributes+1}.name = 'H_mean';
    attributes{n_attributes+2}.type = 2;
    attributes{n_attributes+2}.name = 'H_entropy';
    n_attributes = n_attributes + 2;
end
if(params.GNS)
    attributes{n_attributes+1}.type = 2;
    attributes{n_attributes+1}.name = 'Grayness';
    n_attributes = n_attributes + 1;
end
if(params.FLD)
    if(~params.ALL_YCV)
        attributes{n_attributes+1}.type = 2;
        attributes{n_attributes+1}.name = 'FD_RGB';
        n_attributes = n_attributes + 1;
        attributes{n_attributes+1}.type = 2;
        attributes{n_attributes+1}.name = 'FD_HSV';
        n_attributes = n_attributes + 1;
        attributes{n_attributes+1}.type = 2;
        attributes{n_attributes+1}.name = 'FD_YCV';
        n_attributes = n_attributes + 1;
        attributes{n_attributes+1}.type = 2;
        attributes{n_attributes+1}.name = 'FD_SV';
        n_attributes = n_attributes + 1;
        attributes{n_attributes+1}.type = 2;
        attributes{n_attributes+1}.name = 'FD_CV';
        n_attributes = n_attributes + 1;
    else
        attributes{n_attributes+1}.type = 2;
        attributes{n_attributes+1}.name = 'FD_YCV';
        n_attributes = n_attributes + 1;
        attributes{n_attributes+1}.type = 2;
        attributes{n_attributes+1}.name = 'FD_CV';
        n_attributes = n_attributes + 1;        
    end
end