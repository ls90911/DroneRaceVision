%% 'Global' variables
% Assuming that we are saving the positive instances:
filesToSave = positiveInstances;
vecFormatName='output_vec.dat';

fileID = fopen(vecFormatName,'w');
%% Write each object
for i = 1 : length(filesToSave)
    %% Get data we want to write
    instance = filesToSave(i);
    % Get the filepath
    filepathSplitter = strsplit(instance(1).imageFilename,'/');
    superString = filepathSplitter(length(filepathSplitter));superString = superString{1};
    % Get the bounding box matrix
    object = instance(1).objectBoundingBoxes;
    
    %% Print to file
    fprintf(fileID,'%s %d ',superString,size(object,1)); % Filename, amount of object
    % Print each object pos and dimensions
    for j =1:size(object,1)
        fprintf(fileID,'%d %d %d %d ',object(j,1),object(j,2),object(j,3),object(j,4));
    end
    % Endl for last object
    fprintf(fileID,'\n');
end



