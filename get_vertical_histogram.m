function [VH, window] = get_vertical_histogram(Response, x, ys, width_hist, height_hist)

y_min = min(ys) - height_hist;
y_min = max([1, y_min]);
y_max = max(ys) + height_hist;
y_max = min([y_max, size(Response, 1)]);

coords = [x+width_hist, x];
x_min = max([1, min(coords)]);
x_max = min([size(Response, 2), max(coords)]);

window = [y_min, y_max, x_min, x_max];
Region = Response(y_min:y_max, x_min:x_max);

VH = sum(Region, 2);

figure();
subplot(1,2,1); imagesc(Region); title('Selected region');
subplot(1,2,2); plot(VH); title('Histogram');