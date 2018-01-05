function printNodes(nodes, fid, indentation, n, PerPixel, AdjustTree)
% function printNodes(nodes, fid, indentation, n, PerPixel, AdjustTree)
% should do a depth-first print of the tree
% - n = current node number
% - PerPixel whether the tree will be evaluated for a pixel alone or for
% segmenting an entire image. default = false

if(~exist('PerPixel', 'var') || sum(size(PerPixel)) < 2)
    PerPixel = false;
end

if(~exist('AdjustTree', 'var'))
    AdjustTree = false;
end

if(isa(nodes{n}, 'numeric'))
    % the node classifies the current sample:
    class = round(nodes{n}); % class can be 0 or 1
    prob_sky = nodes{n};
    % uncertainty = 2 * (0.5 - abs(0.5 - nodes{n})); % nodes{n} contains p(class = 1)
    if(class == 1)
        uncertainty = 1 - prob_sky;
    else
        uncertainty = prob_sky;
    end
    % comment class and uncertainty:
    if(class == 0)
        printTabs(indentation, fid); fprintf(fid, '// ground: %d%%\n', 100 - floor(uncertainty * 100));
    else
        printTabs(indentation, fid); fprintf(fid, '// sky: %d%%\n', 100 - floor(uncertainty * 100));
    end
    % set uncertainty:
    if(~PerPixel)
        printTabs(indentation, fid); fprintf(fid, 'setUncertainty(frame_buf2, ix, %d);\n', floor(uncertainty * 100));
    else
        printTabs(indentation, fid); fprintf(fid, '(*uncertainty) = %d;\n', floor(uncertainty * 100));
    end
    % set class:
    if(class == 0)
        if(~PerPixel)
            % only ground pixels are set:
            printTabs(indentation, fid); fprintf(fid, 'groundPixel(frame_buf, ix);\n');
        else
            printTabs(indentation, fid); fprintf(fid, 'return GROUND;\n');
        end
    else
        if(PerPixel)
            printTabs(indentation, fid); fprintf(fid, 'return SKY;\n');
        end
    end
else
    % the node performs a check on an attribute value:
    if(strcmp(nodes{n}.attribute, 'YCO'))
        printTabs(indentation, fid); fprintf(fid, 'YCO_threshold = (imgHeight * %d) / 100;\n', floor(nodes{n}.threshold * 100));
        printTabs(indentation, fid); fprintf(fid, 'if(y <= YCO_threshold)\n');
    elseif(strcmp(nodes{n}.attribute, 'relative_illuminance'))
        printTabs(indentation, fid); fprintf(fid, 'Y = (((unsigned int)frame_buf[ix+1] + (unsigned int)frame_buf[ix+3])) >> 1;\n');
        if(~AdjustTree)
            printTabs(indentation, fid); fprintf(fid, 'if(Y <= (maxY * %d) / 100)\n', floor(nodes{n}.threshold * 100));
        else
            printTabs(indentation, fid); fprintf(fid, 'if(Y <= (maxY * %d) / 100 + adjust_rel_Y)\n', floor(nodes{n}.threshold * 100));
        end
    elseif(strcmp(nodes{n}.attribute, 'Y') || strcmp(nodes{n}.attribute, 'Channel_1'))        
        printTabs(indentation, fid); fprintf(fid, 'Y = (((unsigned int)frame_buf[ix+1] + (unsigned int)frame_buf[ix+3])) >> 1;\n');
        if(~AdjustTree)
            printTabs(indentation, fid); fprintf(fid, 'if(Y <= %d)\n', floor(nodes{n}.threshold * 255));
        else
            printTabs(indentation, fid); fprintf(fid, 'if(Y <= %d + adjust_Y)\n', floor(nodes{n}.threshold * 255));
        end
    elseif(strcmp(nodes{n}.attribute, 'Cb') || strcmp(nodes{n}.attribute, 'Channel_2'))
        printTabs(indentation, fid); fprintf(fid, 'Cb = (unsigned int)frame_buf[ix];\n');
        if(~AdjustTree)
            printTabs(indentation, fid); fprintf(fid, 'if(Cb <= %d)\n', round(nodes{n}.threshold * 255));
        else
            printTabs(indentation, fid); fprintf(fid, 'if(Cb <= %d + adjust_Cb)\n', round(nodes{n}.threshold * 255));
        end
    elseif(strcmp(nodes{n}.attribute, 'Cr') || strcmp(nodes{n}.attribute, 'Channel_3'))
        printTabs(indentation, fid); fprintf(fid, 'Cr = (unsigned int)frame_buf[ix+2];\n');
        if(~AdjustTree)
            printTabs(indentation, fid); fprintf(fid, 'if(Cr <= %d)\n', round(nodes{n}.threshold * 255));
        else
            printTabs(indentation, fid); fprintf(fid, 'if(Cr <= %d + adjust_Cr)\n', round(nodes{n}.threshold * 255));
        end
    elseif(strcmp(nodes{n}.attribute, 'gradient'))
        printTabs(indentation, fid); fprintf(fid, 'gradient = getGradient(frame_buf, x, y);\n');
        if(~AdjustTree)
            printTabs(indentation, fid); fprintf(fid, 'if(gradient <= %d)\n', round(nodes{n}.threshold * 255));
        else
            printTabs(indentation, fid); fprintf(fid, 'if(gradient <= %d + adjust_gradient)\n', round(nodes{n}.threshold * 255));
        end
    elseif(strcmp(nodes{n}.attribute, 'dx')) % at time of addition, dx and dy still had to be implemented on the BlackFin
        printTabs(indentation, fid); fprintf(fid, 'dx = getAbsDX(frame_buf, x, y);\n');
        if(~AdjustTree)
            printTabs(indentation, fid); fprintf(fid, 'if(dx <= %d)\n', round(nodes{n}.threshold * 255));
        else
            printTabs(indentation, fid); fprintf(fid, 'if(dx <= %d + adjust_dx)\n', round(nodes{n}.threshold * 255));
        end
    elseif(strcmp(nodes{n}.attribute, 'dy'))
        printTabs(indentation, fid); fprintf(fid, 'dy = getAbsDY(frame_buf, x, y);\n');
        if(~AdjustTree)
            printTabs(indentation, fid); fprintf(fid, 'if(dy <= %d)\n', round(nodes{n}.threshold * 255));        
        else
            printTabs(indentation, fid); fprintf(fid, 'if(dy <= %d + adjust_dy)\n', round(nodes{n}.threshold * 255));        
        end
    elseif(strcmp(nodes{n}.attribute, 'Noble'))
        printTabs(indentation, fid); fprintf(fid, 'Noble = getNoblePixel(frame_buf, x, y);\n');
        % instead of multiplying here with 255, it is better to do so in
        % the implementation before making the tree
        if(~AdjustTree)
            printTabs(indentation, fid); fprintf(fid, 'if(Noble <= %d)\n', round(nodes{n}.threshold * 255^2)); 
        else
            printTabs(indentation, fid); fprintf(fid, 'if(Noble <= %d + adjust_Noble)\n', round(nodes{n}.threshold * 255^2)); 
        end
    elseif(strcmp(nodes{n}.attribute, 'Harris'))
        printTabs(indentation, fid); fprintf(fid, 'Harris = getHarrisPixel(frame_buf, x, y);\n');
        if(~AdjustTree)
            printTabs(indentation, fid); fprintf(fid, 'if(Harris <= %d)\n', round(nodes{n}.threshold * 255^4));
        else
            printTabs(indentation, fid); fprintf(fid, 'if(Harris <= %d + adjust_Harris)\n', round(nodes{n}.threshold * 255^4));
        end
    elseif(strcmp(nodes{n}.attribute, 'PMN_1'))
        printTabs(indentation, fid); fprintf(fid, 'patch_mean = getPatchMean(frame_buf, x, y, patch_size);\n');
        if(~AdjustTree)
            printTabs(indentation, fid); fprintf(fid, 'if(patch_mean <= %d)\n', round(nodes{n}.threshold * 255));
        else
            printTabs(indentation, fid); fprintf(fid, 'if(patch_mean <= %d + adjust_patch_mean)\n', round(nodes{n}.threshold * 255));
        end
    elseif(strcmp(nodes{n}.attribute, 'TEX_1'))        
        printTabs(indentation, fid); fprintf(fid, 'patch_texture = getPatchTexture(frame_buf, x, y, patch_size);\n');
        if(~AdjustTree)
            printTabs(indentation, fid); fprintf(fid, 'if(patch_texture <= %d)\n', round(nodes{n}.threshold * 255));
        else
            printTabs(indentation, fid); fprintf(fid, 'if(patch_texture <= %d + adjust_patch_texture)\n', round(nodes{n}.threshold * 255));
        end
    elseif(strcmp(nodes{n}.attribute, 'FD_YCV'))
        printTabs(indentation, fid); fprintf(fid, 'FD_YCV = get_FD_YCV(frame_buf, x, y);\n');
        if(~AdjustTree)
            printTabs(indentation, fid); fprintf(fid, 'if(FD_YCV <= %d)\n', round(nodes{n}.threshold * 100));
        else
            printTabs(indentation, fid); fprintf(fid, 'if(FD_YCV <= %d + adjust_FD_YCV)\n', round(nodes{n}.threshold * 100));
        end
    elseif(strcmp(nodes{n}.attribute, 'FD_CV'))
        printTabs(indentation, fid); fprintf(fid, 'FD_CV = get_FD_CV(frame_buf, x, y);\n');
        if(~AdjustTree)
            printTabs(indentation, fid); fprintf(fid, 'if(FD_CV <= %d)\n', round(nodes{n}.threshold * 100));
        else
            printTabs(indentation, fid); fprintf(fid, 'if(FD_CV <= %d + adjust_FD_CV)\n', round(nodes{n}.threshold * 100));
        end
    else
        error(['Feature ' nodes{n}.attribute ' cannot yet be written to C-code, please modify printNodes.m']);
    end    
    % and then the children nodes are printed, first the first child:
    printTabs(indentation, fid); fprintf(fid, '{\n');
    printNodes(nodes, fid, indentation + 1, nodes{n}.child_no(1), PerPixel, AdjustTree);
    printTabs(indentation, fid); fprintf(fid, '}\n');
    printTabs(indentation, fid); fprintf(fid, 'else\n');
    printTabs(indentation, fid); fprintf(fid, '{\n');
    printNodes(nodes, fid, indentation + 1, nodes{n}.child_no(2), PerPixel, AdjustTree);
    printTabs(indentation, fid); fprintf(fid, '}\n');
end