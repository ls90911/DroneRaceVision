function test_fit_groundtruth(X, Y, Z, psi)
% function test_direct_fit_groundtruth(X, Y, Z, psi)

genome = [X, Y, Z, psi];
[im_coords, visible] = translate_direct_genome_to_image_coords(genome);
points = generate_points(im_coords);
% visualize_direct_genome([X, Y, Z, psi], 'ground truth');

h = figure();
plot(points(:,1), points(:,2), 'x');
hold on;
plot_im_coords(im_coords);
title('ground truth + measurements')

% first a square fit:
median_x = median(points(:,1));
median_y = median(points(:,2));
size0 = 100;
Response = ones(512, 830);
SQUARE = 1;
CIRCLE = 2;
POLYGON = 3;
shape = SQUARE;
weights = ones(size(points,1), 1);
[x, y, s, best_fit, valid, height_left, height_right, angle, arm_angle_1, arm_angle_2, s_left, s_right] = fit_window_to_points(points, median_x, median_y, size0, weights, shape, Response);
figure(h);
plot_gate([x,y,s], 'magenta', shape)

% fit a polygon:
shape = POLYGON;
INITIALIZE = false;
if(~INITIALIZE)
    [x, y, s, best_fit, valid, height_left, height_right, angle, arm_angle_1, arm_angle_2, s_left, s_right] = ...
        fit_window_to_points(points, median_x, median_y, size0, weights, shape, Response);
else
    [x, y, s, best_fit, valid, height_left, height_right, angle, arm_angle_1, arm_angle_2, s_left, s_right] = ...
        fit_window_to_points(points, x, y, s, weights, shape, Response);
end
figure(h);
plot_gate([x,y,s, s_left, s_right], 'green', shape)

psi_estimate = get_angle_from_polygon(s_left, s_right);
fprintf('psi = %f, psi estimate = %f\n', psi, psi_estimate);

function points = generate_points(im_coords)
% function points = generate_points(im_coords)

im_coords = [im_coords; im_coords(1, :)];
points = [];
for i = 1:size(im_coords,1)-1
   for t = 0:0.01:1
       P = t * im_coords(i, :) + (1-t) * im_coords(i+1,:);
       P = P + randn(1,2) * 1;
       points = [points; P];
   end
end

