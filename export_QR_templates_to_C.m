function export_QR_templates_to_C()
% function export_QR_templates_to_C()

graphics = false;

size_template = [21 21];
n_pixels = size_template(1)*size_template(2);

QR_dir = './QR_codes_competition/Image/';
template_names = makeListOfFiles(QR_dir, 'png');
n_QR = length(template_names);
QR_templates = cell(n_QR, 1);

fID = fopen('QR_templates.c', 'w');
if(graphics)
    figure();
end
fprintf(fID, 'uint8_t QR_template[%d][%d] = { ', n_QR, n_pixels);
for t = 1:n_QR
    QR_template{t} = imread([QR_dir template_names{t}]);
    QR_template{t} = double(rgb2gray(QR_template{t})) ./ 255;
    QR_template{t} = imresize(QR_template{t}, size_template, 'nearest');
    fprintf('Template %d, length %d.\n', t, length(QR_template{t}(:)))
    if(graphics)
        imshow(QR_template{t});
        waitforbuttonpress();
    end
    fprintf(fID, '{');
    for y = 1:size_template(1)
        for x = 1:size_template(2)
            if(y*x < n_pixels)
                fprintf(fID, '%d, ', round(QR_template{t}(y,x)*255));
            end
        end
    end
    fprintf(fID, '%d},\n', round(QR_template{t}(n_pixels)*255));
end
fprintf(fID, '};')
fclose(fID);
