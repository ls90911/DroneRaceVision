function kNN_QR(QR_file_name)
% function kNN_QR(QR_file_name)

QR_Im = imread(QR_file_name);
QR_Im = double(rgb2gray(QR_Im)) ./ 255;
QR_Im = imresize(QR_Im, [63, 63]);

QR_dir = './QR_codes_competition/Image/';
template_names = makeListOfFiles(QR_dir, 'png');
n_QR = length(template_names);
QR_templates = cell(n_QR, 1);

distances = zeros(n_QR, 1);
for t = 1:n_QR
    QR_template{t} = imread([QR_dir template_names{t}]);
    QR_template{t} = double(rgb2gray(QR_template{t})) ./ 255;
    if(size(QR_template{t}) ~= size(QR_Im))
        QR_template{t} = imresize(QR_template{t}, size(QR_Im), 'nearest');
    end
    distances(t) = sum(sum(abs(QR_Im - QR_template{t})));
end

[v,i] = min(distances);
fprintf('Predicted class = %d\n', i);
figure();
plot(distances); hold on; plot(i, v, 'x', 'Color', 'red');
figure();
subplot(1,2,1); imshow(QR_Im); title('Query');
subplot(1,2,2); imshow(QR_template{i}); title('Result');

    