function generate_dataset_for_weka(Features, Labels)
% function generate_dataset_for_weka(data_set)
%
% For more information on the format:
% http://www.cs.waikato.ac.nz/ml/weka/arff.html

fID = fopen('WEKA_data.arff', 'w');
fprintf(fID, '%% ground data set\n');
fprintf(fID, '@relation ground\n');
% load('params.mat');
% for t = 1:params.n_textons
%     fprintf(fID, ['@attribute texton_' num2str(t) ' real\n']);
% end
fprintf(fID, ['@attribute H real\n']);
fprintf(fID, ['@attribute S real\n']);
fprintf(fID, ['@attribute V real\n']);
fprintf(fID, ['@attribute class {0, 1}\n']);
fprintf(fID, '@data\n');
% create WEKA data set:
fprintf('Data set\n');
for im = 1:size(Features, 1)
    for f = 1:size(Features, 2)
        fprintf(fID, '%f, ', Features(im, f));
    end
    fprintf(fID, '%d\n', Labels(im));
end
fclose(fID);