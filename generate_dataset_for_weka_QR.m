function generate_dataset_for_weka_QR(Features, Labels, cell_structure, n_QR_images)
% function generate_dataset_for_weka_QR(Features, Labels, cell_structure, n_QR_images)
%
% For more information on the format:
% http://www.cs.waikato.ac.nz/ml/weka/arff.html

RECOGNITION = 0;
DETECTION = 1;
MODE = RECOGNITION;

if(~exist('cell_structure', 'var') || isempty(cell_structure))
    cell_structure = [3, 10];
end
if(~exist('n_QR_images', 'var') || isempty(n_QR_images))
    QR_dir_name = 'QR_codes_competition\Image';
    QR_image_names = makeListOfFiles(QR_dir_name, 'png');
    QR_image_names = sort_nat(QR_image_names);
    n_QR_images = length(QR_image_names);
end

% randomize the set:
inds = randperm(size(Features, 1));
Features = Features(inds, :);
Labels = Labels(inds, 1);

fID = fopen('QR_WEKA_data.arff', 'w');
fprintf(fID, '%% QR data set\n');
fprintf(fID, '@relation QR\n');
% load('params.mat');
% for t = 1:params.n_textons
%     fprintf(fID, ['@attribute texton_' num2str(t) ' real\n']);
% end

for cs = 1:length(cell_structure)
    for c = 1:cell_structure(cs) * cell_structure(cs);
        fprintf(fID, ['@attribute cell_' num2str(cs) '_' num2str(c) ' real\n']);
    end
end

if(MODE == RECOGNITION)
    class_string = 'QR_1';
    for q = 2:n_QR_images
        class_string = [class_string ', QR_' num2str(q)];
    end
else
    class_string = 'QR_0, QR_1';
end
    

fprintf(fID, ['@attribute class {' class_string '}\n']);
fprintf(fID, '@data\n');
% create WEKA data set:
fprintf('Data set\n');
for im = 1:size(Features, 1)
    if(mod(im, floor(size(Features, 1)/10)) == 0)
        fprintf('%d%%\n', round(100 * im / size(Features, 1)));
    end
    for f = 1:size(Features, 2)
        fprintf(fID, '%f, ', Features(im, f));
    end
    % We add QR_ in order to be able to easily process it later (finding it in the print out of weka)
    fprintf(fID, 'QR_%d\n', Labels(im));
end
fclose(fID);