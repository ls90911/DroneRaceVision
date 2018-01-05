function saveTree(tree, C_filename, name_tree, attributes, classes)
% function saveTree(tree, C_filename, name_tree, attributes, classes)

fid = fopen(C_filename, 'w');

if(fid ~= -1)
    indentation = 0;
    % the C-function will take an array of attributes and will return a
    % class and uncertainty
    fprintf(fid, ['void ' name_tree '(float* attributes, int* class, float* uncertainty)\n']);
    fprintf(fid, '{\n');
    indentation = indentation + 1;
    printTabs(indentation, fid); fprintf(fid, '// use a WEKA-learned tree to classify an instance as defined by its attributes:\n');
    printTabs(indentation, fid); fprintf(fid, '// Returns an integer class and an uncertainty in the range [0,1].\n');
    
    % print the tree:
    printNodesQR(tree, fid, indentation, 1); % should do a depth-first print of the tree
    
    % code for iterating over the image:
    removeIndentation(indentation, fid);
    fclose(fid); 
end



