function printNodesQR(nodes, fid, indentation, n)
% function printNodesQR(nodes, fid, indentation, n)
% should do a depth-first print of the tree
% - n = current node number

if(nodes{n}.leaf == 1) % isa(nodes{n}, 'numeric')
    % the node classifies the current sample:
    class = nodes{n}.class; 
    uncertainty = nodes{n}.uncertainty;
    
    % comment class and uncertainty:
    printTabs(indentation, fid); fprintf(fid, '// %s: %d%%\n', class, 100 - floor(uncertainty * 100));
    % set uncertainty:
    printTabs(indentation, fid); fprintf(fid, '(*uncertainty) = %f;\n', uncertainty);
    
    % set class:
    ind = findstr(class, '_');
    class_num = eval(class(ind+1:end));
    printTabs(indentation, fid); fprintf(fid, '(*class) = %d;\n', class_num);
    printTabs(indentation, fid); fprintf(fid, 'return;\n');
else
    % the node performs a check on an attribute value:
    printTabs(indentation, fid); fprintf(fid, 'if(attributes[%d] <= %f)\n', nodes{n}.attribute_no-1, nodes{n}.threshold);
    
    % and then the children nodes are printed, first the first child:
    printTabs(indentation, fid); fprintf(fid, '{\n');
    printNodesQR(nodes, fid, indentation + 1, nodes{n}.child_no(1));
    printTabs(indentation, fid); fprintf(fid, '}\n');
    printTabs(indentation, fid); fprintf(fid, 'else\n');
    printTabs(indentation, fid); fprintf(fid, '{\n');
    printNodesQR(nodes, fid, indentation + 1, nodes{n}.child_no(2));
    printTabs(indentation, fid); fprintf(fid, '}\n');
end