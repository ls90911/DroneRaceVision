function opengates_in_image = run_open_detection_on_dir(dir_name, graphics)

% sub_sampling_open_snake.m  Initial detection for candidate genome and
% region of interests.

% get_open_color_fitness.m  Check open gate color fitness.

% fit_open_windon_to_points.m  EA on opengate genome, being the x location
% of central bar, y locations of four horizontal bars and bar length,
% neglecting the double length one on top.

% mean_distance_to_open_gate.m distances_to_open_gate.m

if(~exist('dir_name', 'var') || isempty(dir_name))
    dir_name = 'open_gate_images';
end
if(~exist('graphics', 'var') || isempty(graphics))
    graphics = true;
end

image_names = makeListOfFiles(dir_name, 'jpg');
image_names = sort_nat(image_names);
n_images = length(image_names);

% whether to threshold the color response:
THRESHOLD = true;
CUT_OFF_PROPELLORS = false;
% the detection method (should be true in this file)
SIMPLE_METHOD = true; % just histogram peaks
SUB_SAMPLING_OPEN_SNAKE = false;
graphics = true;
EA_REFINEMENT = false;
HISTOGRAM_REFINEMENT = true;
FILTER_HSV = false;

for im = 1:n_images
    % read the image in RGB
    RGB = imread([dir_name '/' image_names{im}]);
    RGB = double(RGB) ./ 255;
    image_names{im}
    
    % resize the image:
    if(strcmp(dir_name, 'open_gate_images') && size(RGB,2) > 1024)
        RGB = imresize(RGB, 0.25);
    end
    
%     if (im <= 11)
%         RGB = imrotate(RGB, -90);
%     end
    
    if(graphics)
        % show the image:
        figure(); imshow(RGB);
        title('RGB image');
    end
    
    
    if(FILTER_HSV)
        % we filter in the hsv domain:
        HSV = rgb2hsv(RGB);
        H_ref = 0.05; %0.10;
        std_var = 0.15; % 0.1;
        S_thresh = 0.05; % 0.15;
        
        %     H_ref = 0.05; %0.10;
        %     std_var = 0.05; % 0.1;
        %     S_thresh = 0.4;
        Response = filter_HSV(HSV, H_ref, std_var, S_thresh);
    else
        YCV = rgb2ycbcr(RGB);
        cr_min = 140.0 / 255.0;
        dy_min = 1; %0.05;
        Response = filter_YCV(YCV, cr_min, dy_min);
        %         figure();
        %         subplot(1,2,1); imagesc(Response);
        %         dy_min = 0.05;
        %         Response = filter_YCV(YCV, cr_min, dy_min);
        %         subplot(1,2,2); imagesc(Response);
    end
    % response thresholding:
    if(THRESHOLD)
        std_factor = 1.0;%1.5; % 2;
        mR = mean(Response(:));
        stdR = std(Response(:));
        Response = (Response > mR + std_factor*stdR) .* Response;
    end
    
    if(CUT_OFF_PROPELLORS)
        % cut off propellors:
        Response(:, 1:100) = 0;
        Response(:, end-100:end) = 0;
    end
    
    if(graphics)
        figure();
        imagesc(Response);
        title('Response');
    end
    
    if(SIMPLE_METHOD)
        ROI = [1, size(Response, 2), 1, size(Response, 1)];
        [Histogram, locs, pks] = simple_detector(Response, ROI);
        if(length(locs) <= 2)
            figure();
            imagesc(Response);
            hold on;
            for i = 1:length(locs)
                if(i < length(locs))
                    col = [1 0.75 0];
                else
                    col = [0 1 0];
                end
                plot([locs(i), locs(i)], [ROI(3), ROI(4)], 'LineWidth', 2, 'Color', col);
            end
        end
    end
    
    if(SUB_SAMPLING_OPEN_SNAKE)
        [xs, yl1, yl2, yr2, yr1, sb, n_opengates] = sub_sampling_open_snake(Response);
        
        cf = zeros(1, n_opengates);
        for g=1:n_opengates
            cf(g) = get_open_color_fitness([xs(g), yl1(g), yl2(g), yr2(g), yr1(g), sb(g)],...
                Response);
        end
        
        if(n_opengates >= 1)
            [v, i] = max(cf);
            x = xs(i);
            y_l1 = yl1(i); y_l2 = yl2(i); y_r2 = yr2(i); y_r1 = yr1(i);
            s_bar = sb(i);
            n_opengates = length(x);
        end

        if(HISTOGRAM_REFINEMENT)
           % just refine the best guess:
           if(n_opengates >= 1)
               width_hist = 100;
               height_hist = 50;
               % get the histograms on the different sides of the pole:
               [VH_left, window_left ] = get_vertical_histogram(Response, x, [y_l1, y_l2, y_r1, y_r2], -width_hist, height_hist);
               [VH_right, window_right ] = get_vertical_histogram(Response, x, [y_l1, y_l2, y_r1, y_r2], width_hist, height_hist);
               % smooth the histograms:
               VH_left = smooth(VH_left, 5);
               VH_right = smooth(VH_right, 5);
               % find all peaks:
               [pks_l,locs_l] = findpeaks(VH_left);
               [pks_r,locs_r] = findpeaks(VH_right);
               figure();
               subplot(1,2,1); plot(VH_left); hold on; plot(locs_l, pks_l, 'x'); title('Left');
               subplot(1,2,2); plot(VH_right); hold on; plot(locs_r, pks_r, 'x'); title('Right');
               
               locs_l = locs_l + window_left(1);
               locs_r = locs_r + window_right(1);
               % select the peaks:
               if(length(pks_l) == 0)
                   fprintf('should not happen\n')
               elseif(length(pks_l) == 1)
                   y_l1 = locs_l;
                   y_l2 = y_l1;
               else
                   [v, i] = sort(pks_l);
                   inds = i(end-1:end);
                   ys = locs_l(inds);
                   y_l1 = min(ys);
                   y_l2 = max(ys);
               end
               if(length(pks_r) == 0)
                   fprintf('should not happen\n')
               elseif(length(pks_r) == 1)
                   y_r1 = locs_r;
                   y_r2 = y_r1;
               else
                   [v, i] = sort(pks_r);
                   inds = i(end-1:end);
                   ys = locs_r(inds);
                   y_r1 = min(ys);
                   y_r2 = max(ys);
               end
               
               if(graphics)
                  draw_open_gate(Response, [x, y_l1, y_l2, y_r2, y_r1, s_bar]); 
               end
           end
        end
        
        if(EA_REFINEMENT)
            if(graphics)
                figure();
                imagesc(Response);
                title('Response Hue filter: EA refinement');
                hold on;
            end
            
            for g = 1:n_opengates
                size_factor = 1.5;
                x_l = round(x(g) - s_bar(g) * size_factor);
                x_h = round(x(g) + s_bar(g) * size_factor);
                y_min = max(y_l1(g), y_r1(g)); % min
                y_max = min(y_l2(g), y_r2(g)); % max
                y_temp_center = (y_min + y_max)/2; % middle point of top and bottom bars.
                y_l = round(y_temp_center + (y_max - y_min)/2*size_factor);
                y_h = round(y_temp_center - (y_max - y_min)/2*size_factor);
                [x_l, y_l] = check_coordinate(x_l, y_l, size(Response,2), size(Response, 1));
                [x_h, y_h] = check_coordinate(x_h, y_h, size(Response,2), size(Response, 1));
                [points, weights] = convert_response_to_points(Response(y_l:y_h, x_l:x_h));
                
                % fit a window to it:
                max_points = 500;
                if(size(points,1) > max_points)
                    inds = randperm(size(points,1));
                    inds = inds(1:max_points);
                    points = points(inds, :);
                    weights = weights(inds, :);
                end
                [xx, y_ll1, y_ll2, y_rr2, y_rr1, ss_bar]= ...
                    fit_open_window_to_points(points, x(g)-x_l, y_l1(g)-y_l, y_l2(g)-y_l, y_r2(g)-y_l, y_r1(g)-y_l, s_bar(g), weights, Response);
                x(g) = xx + x_l;
                y_l1(g) = y_ll1 + y_l;
                y_l2(g) = y_ll2 + y_l;
                y_r2(g) = y_rr2 + y_l;
                y_r1(g) = y_rr1 + y_l;
                s_bar(g) = ss_bar;
                
                if(graphics)
                    % cut out region for refinement.
                    plot([x_l, x_l], [y_l, y_h], 'Color', 'black', 'LineWidth', 1);
                    plot([x_l, x_h], [y_h, y_h], 'Color', 'black', 'LineWidth', 1);
                    plot([x_h, x_h], [y_h, y_l], 'Color', 'black', 'LineWidth', 1);
                    plot([x_h, x_l], [y_l, y_l], 'Color', 'black', 'LineWidth', 1);
                    color_1 = [1, 0, 0];
                    color_2 = [0, 1, 0];
                    cfg = get_open_color_fitness([x(g), y_l1(g), y_l2(g), y_r2(g), y_r1(g), s_bar(g)], Response);
                    color = cfg*[0 1 0] + (1-cfg)*[1 0 0];
                    Q1 = [x(g)-s_bar(g), y_l1(g)]; Q1_inner = [x(g), y_l1(g)];
                    Q2 = [x(g)-s_bar(g), y_l2(g)]; Q2_inner = [x(g), y_l2(g)];
                    Q3 = [x(g)+s_bar(g), y_r2(g)]; Q3_inner = [x(g), y_r2(g)];
                    Q4 = [x(g)+s_bar(g), y_r1(g)]; Q4_inner = [x(g), y_r1(g)];
                    plot([Q1(1) Q1_inner(1)], [Q1(2), Q1_inner(2)], 'Color', color_1, 'LineWidth', 5);
                    plot([Q2(1) Q2_inner(1)], [Q2(2), Q2_inner(2)], 'Color', color_1, 'LineWidth', 5);
                    plot([Q3(1) Q3_inner(1)], [Q3(2), Q3_inner(2)], 'Color', color_2, 'LineWidth', 5);
                    plot([Q4(1) Q4_inner(1)], [Q4(2), Q4_inner(2)], 'Color', color_2, 'LineWidth', 5);
                    if (Q1_inner(2) < Q4_inner(2))
                        Q_low = Q1_inner;
                        Q_high = Q3_inner;
                    else
                        Q_low = Q4_inner;
                        Q_high = Q2_inner;
                    end
                    plot([Q_low(1) Q_high(1)], [Q_low(2), Q_high(2)], 'Color', color_1, 'LineWidth', 5);
                end
            end
            
            
            if(n_opengates >= 1)
                opengates_in_image{im}.x = x(1);
                opengates_in_image{im}.y_l1 = y_l1(1);
                opengates_in_image{im}.y_l2 = y_l2(1);
                opengates_in_image{im}.y_r2 = y_r2(1);
                opengates_in_image{im}.y_r1 = y_r1(1);
                opengates_in_image{im}.s_bar = s_bar(1);
            end
        end
        
        
        if(graphics)
            waitforbuttonpress;
            close all;
        end
    end
end

function [x, y] = check_coordinate(x, y, W, H)
% function [x, y] = check_coordinate(x, y, W, H)

x = max([1,x]);
x = min([W,x]);
y = max([1,y]);
y = min([H,y]);

function draw_open_gate(Response, coords)
x = coords(1);
y_min = min(coords(2:5));
y_max = max(coords(2:5));
width_bar = 100;

figure();
imagesc(Response);
hold on;
plot([x,x], [y_min, y_max], 'LineWidth', 3);
plot([x,x+width_bar], [coords(4), coords(4)], 'LineWidth', 3);
plot([x,x+width_bar], [coords(5), coords(5)], 'LineWidth', 3);
plot([x,x-width_bar], [coords(2), coords(2)], 'LineWidth', 3);
plot([x,x-width_bar], [coords(3), coords(3)], 'LineWidth', 3);


function Response = filter_YCV(YCV, cr_min, dy_min)
[DX, DY] = gradient(YCV(:,:,3));
DY = abs(DY);
DX = abs(DX);
Response = DY > dy_min | YCV(:,:,3) > cr_min;


function Response = filter_HSV(HSV, H_ref, H_std_var, S_thresh)
% function Response = filter_HSV(HSV, H_ref, H_std_var, S_thresh)

% determine distance to mean, bending around 0 / 1:
H = HSV(:,:,1);
width = size(H, 2); height = size(H, 1);
H1 = H - H_ref;
H2 = ones(height, width) - H1;
H = min(H1, H2);

% filter on saturation:
S = HSV(:,:, 2);
S_Filter = S <= S_thresh;
H = H + 1000 * S_Filter; % will get 0 probability

% get the response:
Response = normpdf(H, H_ref, H_std_var);