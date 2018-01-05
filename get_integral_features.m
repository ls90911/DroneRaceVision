function features = get_integral_features(QR_Im_distorted, cell_structure)
% function features = get_integral_features(QR_Im_distorted, cell_structure)

if(size(QR_Im_distorted, 3) > 1)
    QR_Im_distorted = rgb2gray(QR_Im_distorted);
end

H = size(QR_Im_distorted, 1);
W = size(QR_Im_distorted, 2);

% potential pre-processing:
% - (local?) thresholding
% - rotation correction based on gradients
% - ...

% get integral image:
II = getIntegralImage(QR_Im_distorted);
% get the global illuminance:
global_ill = II(end,end);
ncs = length(cell_structure);

features = [];
for cs = 1:ncs
    n_rows = cell_structure(cs);
    n_cells = n_rows * n_rows;
    y_cell_size = floor(H / n_rows);
    x_cell_size = floor(W / n_rows);
    cell_size = min([y_cell_size, x_cell_size]);
    new_features = zeros(1, n_cells);
    cll = 0;
    for r = 1:n_rows
        y = 1 + (r-1) * y_cell_size;
        for c = 1:n_rows
            cll = cll + 1;
            x = 1 + (c-1) * x_cell_size;
            mean_val = get_mean_value(II, x, y, cell_size-1);
            new_features(cll) = mean_val / global_ill;
        end
    end
    features = [features, new_features];
end


function mean_val = get_mean_value(II, x, y, sz)
% function mean_val = get_mean_value(II, x, y, sz)
mean_val = II(y+sz, x+sz) + II(y,x) - II(y, x+sz) - II(y+sz, x);

