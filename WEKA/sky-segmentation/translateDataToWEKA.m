function WEKA = translateDataToWEKA(Data, attributes, comments, filename, classes)
% function WEKA = translateDataToWEKA(Data, attributes, comments, filename, classes)
% Data: the data gathered with our m-files
% attributes: cell structure with for every attribute:
% attributes{i}.type = 1 -> nominal, 2 -> numeric
% if nominal, attributes{i}.options is a cell with the names of all options (1, 2, etc. or 'A', 'B', etc.)
% attributes{i}.name = attribute_name
% comments is a cell with all text to be printed as comments
% filename (should end with .arff)
% classes is a cell with the class names
%
% We assume column vectors for everything, except the m x n Data matrix containing m instances of n
% attributes

fprintf('Translating data matrix to WEKA, * = 5%%.\n');
fid = fopen(filename, 'w');

% for info on the WEKA format, see http://weka.wikispaces.com/Primer
% We start with the comments, databasename, attributes, and classes
for c = 1:size(comments,1)
    fprintf(fid, ['%% ' comments{c} '\n']);
end

fprintf(fid, ['@relation ' filename '\n\n']);

for a = 1:size(attributes,2)
    fprintf(fid, ['@attribute ' attributes{a}.name ' ']);
    if(attributes{a}.type == 1)
        fprintf(fid, '{');
        options = attributes{a}.options;
        for i = 1:size(options,1)
            fprintf(fid, options{i});
            if(i < size(options,1))
               fprintf(fid, ', '); 
            end
        end
        fprintf(fid, '}');
    else
        fprintf(fid, 'real');
    end
    fprintf(fid, '\n');
end

fprintf(fid, '@attribute class {');
for i = 1:size(classes,1)
    fprintf(fid, classes{i});
    if(i < size(classes,1))
        fprintf(fid, ', ');
    end
end
fprintf(fid, '}\n');

% Then we add the data:
fprintf(fid, '\n@data\n');

% We permute the data, so that we can choose to cut off a part of the file (if too big)
Dat = [Data{1} ones(size(Data{1},1),1)];
for c = 2:size(Data,1)
    Dat = [Dat; [Data{c} c*ones(size(Data{c}, 1),1)]];
end
clear Data;
random_order = randperm(size(Dat,1));
Dat = Dat(random_order, :);

% the classes are in different places in the Data cell
%for c = 1:size(Data,1)
for inst = 1:size(Dat,1)
    if(mod(inst, floor(size(Dat,1)/10)) == 0)
        fprintf('.');
    end
    for attr = 1:size(Dat,2)-1
        if(attributes{attr}.type == 1)
            % nominal (can still be represented as a number internally)
            if(isa(Dat(inst, attr), 'numeric'))
                fprintf(fid, '%d', Dat(inst, attr)); % we assume that a nominal number is an integer
            else
                fprintf(fid, Dat(inst, attr)); % is already a string
            end
        else
            % numeric
            fprintf(fid, '%f', Dat(inst, attr));
        end
        fprintf(fid, ',');
    end
    fprintf(fid, [classes{Dat(inst, size(Dat,2))} '\n']);
end
%end

fclose(fid);

fprintf('\n');
