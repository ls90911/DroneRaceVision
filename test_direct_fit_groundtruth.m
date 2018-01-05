function test_direct_fit_groundtruth(X, Y, Z, psi)
% function test_direct_fit_groundtruth(X, Y, Z, psi)

genome = [X, Y, Z, psi];
[im_coords, visible] = translate_direct_genome_to_image_coords(genome);
points = generate_points(im_coords);
visualize_direct_genome([X, Y, Z, psi], 'ground truth');

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
shape = SQUARE;
weights = ones(size(points,1), 1);
[x, y, s, best_fit, valid, height_left, height_right, angle, arm_angle_1, arm_angle_2] = fit_window_to_points(points, median_x, median_y, size0, weights, shape, Response);
figure(h);
plot_gate([x,y,s], 'magenta')

% transform to initial hypothesis:
[X0, Y0, Z0, psi0] = get_initial_direct_hypothesis(x, y, s);
visualize_direct_genome([X0, Y0, Z0, psi0], 'initial');

% direct fit:
[X1, Y1, Z1, psi1, best_fit1] = fit_window_to_points_direct(points, X0, Y0, Z0, psi0, weights, Response);
visualize_direct_genome([X1, Y1, Z1, psi1], 'final');

fprintf('X,Y,Z,psi: = (%f,%f,%f,%f)\n', X, Y, Z, psi);
fprintf('X,Y,Z,psi: = (%f,%f,%f,%f)\n', X0, Y0, Z0, psi0);
fprintf('X,Y,Z,psi: = (%f,%f,%f,%f)\n', X1, Y1, Z1, psi1);

figure(h);
[im_coords, visible] = translate_direct_genome_to_image_coords([X0, Y0, Z0, psi0]);
plot_im_coords(im_coords, 'blue');
[im_coords, visible] = translate_direct_genome_to_image_coords([X1, Y1, Z1, psi1]);
plot_im_coords(im_coords, 'green');

function points = generate_points(im_coords)
% function points = generate_points(im_coords)

im_coords = [im_coords; im_coords(1, :)];
points = [];
for i = 1:size(im_coords,1)-1
   for t = 0:0.01:1
       P = t * im_coords(i, :) + (1-t) * im_coords(i+1,:);
       P = P + randn(1,2) * 3;
       points = [points; P];
   end
end

