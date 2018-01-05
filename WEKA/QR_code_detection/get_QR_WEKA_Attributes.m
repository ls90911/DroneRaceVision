function [attributes, n_attributes] = get_QR_WEKA_Attributes()
% function [attributes, n_attributes] = get_QR_WEKA_Attributes()
%
% get an array of attributes structs

% type of attribute:
NOMINAL = 1;
NUMERIC = 2;
% if nominal, attribute should have a field "options" with the possible
% values, e.g., ['a', 'b', 'c']
% here we only have numeric properties

n_attributes = 0;

% integral feature grids:
cell_structure = [3, 10];
% set the attribute names and types:
for cs = 1:length(cell_structure)
    for c = 1:cell_structure(cs) * cell_structure(cs);
        n_attributes = n_attributes + 1;
        attributes{n_attributes}.type = NUMERIC;
        attributes{n_attributes}.name = ['cell_' num2str(cs) '_' num2str(c)];
        % attributes{n_attributes}.C_index = n_attributes-1;
    end
end