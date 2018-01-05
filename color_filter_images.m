function color_filter_images()

% get file names:
dir_name = 'phone_images';
image_names = makeListOfFiles(dir_name, 'jpg');
image_names = sort_nat(image_names);
n_images = length(image_names);

% filter images
for im = 1:n_images
    RGB = imread([dir_name '/' image_names{im}]);
    RGB = double(RGB) ./ 255;
    if(strcmp(dir_name, 'images') || strcmp(dir_name, 'ventilator_images'))
        RGB = imrotate(RGB, 90);
    end
    if(strcmp(dir_name, 'phone_images') || strcmp(dir_name, 'real_arena'))
        RGB = imresize(RGB, 0.25);
    end
        
    figure(); imshow(RGB); 
    title('RGB image');
    
    HSV = rgb2hsv(RGB);
    H_ref = 0.10;%0;
    std_var = 0.1;
    S_thresh = 0.4;
    Response = filter_HSV(HSV, H_ref, std_var, S_thresh);
    
    % response thresholding:
    THRESHOLD = true;
    if(THRESHOLD)
        std_factor = 2; % 1.5;
        mR = mean(Response(:));
        stdR = std(Response(:));
        Response = (Response > mR + std_factor*stdR) .* Response;
    end
    % cut off propellors:
    Response(:, 1:100) = 0;
    Response(:, end-100:end) = 0;
    
    % simple method:
    TOP_HALF = true;
    if(TOP_HALF)
        horizontal = mean(Response(1:round(size(Response, 1)/2), :), 2);
        vertical = mean (Response(1:round(size(Response, 1)/2), :));
    else
        horizontal = mean(Response, 2);
        vertical = mean (Response);
    end
    horizontal = (horizontal ./ sum(horizontal));
    ch = cumsum(horizontal);
    ids = find(ch >= 0.5);
    median_y = ids(1);
    vertical = (vertical ./ sum(vertical));
    ch = cumsum(vertical);
    ids = find(ch >= 0.5);
    median_x = ids(1); % quicksort
    %
    %     mean_Response = mean(Response);
    %     if(Response(median_y, median_x) > mean_Response)
    %         % we should actually move it to the "right" direction
    %        if(median_x < size(RGB, 2) / 2)
    %            median_x = median_x + 100;
    %        else
    %            median_x = median_x - 100;
    %        end
    %        if(median_y < size(RGB, 1) / 2)
    %            median_y = median_y + 100;
    %        else
    %            median_y = median_y - 100;
    %        end
    %     end
    
    WINDOW_FROM_HIST_PEAKS = false;
    if(WINDOW_FROM_HIST_PEAKS)
        smooth_factor = 50;
        [pks_hor, locs_hor] = findpeaks(smooth(horizontal, smooth_factor), 'MinPeakDistance', 6); % 'MinPeakProminence',4
        [pks_ver, locs_ver] = findpeaks(smooth(vertical, smooth_factor), 'MinPeakDistance', 6); % 'MinPeakProminence',4,
        
        figure();
        subplot(1,2,1);
        bar(smooth(horizontal, smooth_factor));
        hold on;
        bar(locs_hor, pks_hor, 'FaceColor', 'red');
        title('Hor');
        subplot(1,2,2);
        bar(smooth(vertical, smooth_factor));
        hold on;
        bar(locs_ver, pks_ver, 'FaceColor', 'red');
        title('Ver')
    end
    
    figure();
    imagesc(Response);
    hold on;
    plot(median_x, median_y, 'x', 'MarkerSize', 10, 'Color', 'red', 'LineWidth', 3);
    title('Response Hue filter');
    
    if(WINDOW_FROM_HIST_PEAKS)
        % find biggest two peaks:
        [vals, inds] = sort(pks_ver, 'descend');
        locs = locs_ver(inds);
        figure('Name', 'Yaw-Control', 'NumberTitle', 'off');
        imagesc(Response);
        hold on;
        if(length(locs) >= 2)
            vals = vals(1:2);
            locs = locs(1:2);
            if(abs(1-vals(2)/vals(1)) < 0.5)
                plot_color = 'green';
            else
                plot_color = 'red';
            end
            for i = 1:length(vals)
                plot([locs(i) locs(i)], [1 size(Response,1)], 'Color', plot_color, 'LineWidth', 2);
            end
            plot(mean(locs), size(Response, 1) / 2, 'x', 'MarkerSize', 10, 'LineWidth', 2, 'Color', plot_color);
            title(['Val = ' num2str(mean(vals)) ' ratio = ' num2str(abs(1-vals(2)/vals(1)))]);
        end

%         %         n_select = 2;
%         %         [pvals, pinds] = sort(pks_hor, 'descend');
%         %         pks_hor = pvals(1:n_select);
%         %         locs_hor = locs_hor(pinds(1:n_select));
%         for i = 1:length(pks_hor)
%             if(pks_hor(i) > mean(pks_hor))
%                 plot([1 size(RGB,2)], [locs_hor(i) locs_hor(i)], 'Color', 'red');
%             end
%         end
%         %         [pvals, pinds] = sort(pks_ver, 'descend');
%         %         pks_ver = pvals(1:n_select);
%         %         locs_ver = locs_ver(pinds(1:n_select));
%         for i = 1:length(pks_ver)
%             if(pks_ver(i) > mean(pks_ver))
%                 plot([locs_ver(i) locs_ver(i)], [1 size(RGB,1)], 'Color', 'red');
%             end
%         end
    end
    
    
    % does not work very nicely when the size is not exactly correct:
    CHRISTOPHE_WINDOW = false;
    if(CHRISTOPHE_WINDOW)
        detectWindow(Response, RGB); % , median_x, median_y);  -> does not seem to work at all...
    end
    
    HOUGH = false;
    if(HOUGH)
        detectHoughWindow(Response);
    end
    
    WINDOW_CORNERS = true;
    if(WINDOW_CORNERS)
        detect_window_corners(Response);
    end
    
    EVOLVE = false;
    if(EVOLVE)
        TOP_HALF = true;
        if(TOP_HALF)
            R = Response(1:round(end/2), :);
        else
            R = Response;
        end
        [points, weights] = convert_response_to_points(R);
        max_points = 500;
        if(size(points,1) > max_points)
            inds = randperm(size(points,1));
            inds = inds(1:max_points);
            points = points(inds, :);
            weights = weights(inds, :);
        end
        size0 = 100;
        SQUARE = 1;
        CIRCLE = 2;
        shape = SQUARE;
        n_gates = 1;
        if(n_gates == 1)
            [x, y, s, best_fit, valid, height_left, height_right, angle, arm_angle_1, arm_angle_2] = fit_window_to_points(points, median_x, median_y, size0, weights, shape, Response);
        else
            [x, y, s, best_fit] = fit_2windows_to_points(points, median_x, median_y, size0, weights, shape, Response);
        end
        figure();
        imagesc(Response);
        hold on;
        for g = 1:n_gates
            
            % determine what ratio of the shape is in the right color:
            STICK = false;
            cf = get_color_fitness([x(g), y(g), s(g)], Response, STICK, shape);
            % a good fit has a high ratio:
            color = cf * [0 1 0] + (1-cf) * [1 0 0];
            text(x(g)-15, y(g), num2str(cf), 'Color', color);
            if(shape == CIRCLE)
                circle(x(g),y(g),s(g), color, 5);
            else
                Q1 = [x(g)-s(g); y(g)-s(g)];
                Q2 = [x(g)+s(g); y(g)-s(g)];
                Q3 = [x(g)+s(g); y(g)+s(g)];
                Q4 = [x(g)-s(g); y(g)+s(g)];
                plot([Q1(1) Q2(1)], [Q1(2), Q2(2)], 'Color', color, 'LineWidth', 5);
                plot([Q2(1) Q3(1)], [Q2(2), Q3(2)], 'Color', color, 'LineWidth', 5);
                plot([Q3(1) Q4(1)], [Q3(2), Q4(2)], 'Color', color, 'LineWidth', 5);
                plot([Q4(1) Q1(1)], [Q4(2), Q1(2)], 'Color', color, 'LineWidth', 5);
            end
            plot([x(g) x(g)], [y(g)+s(g), y(g)+2*s(g)], 'Color', color, 'LineWidth', 5);
            if(~isempty(angle_1))
                plot_arms([angle_1, angle_2], color);
            end
        end
        %         for i = 1:3
        %             evolveWindow(Response, RGB); % , median_x, median_y); -> change to center location
        %         end
    end
    
    GROW = false;
    if(GROW)
        grow_outward(Response, median_x, median_y);
    end
    
    BORDER_RESPONSE = false;
    if(BORDER_RESPONSE)
        border_size = 30;
        [Hor, Ver] = filter_borders(Response, border_size);
    end
    
    SUB_SAMPLING_SNAKE = false;
    if(SUB_SAMPLING_SNAKE)
        
        SQUARE = 1;
        CIRCLE = 2;
        shape = SQUARE;
        
        [x,y,s,n_gates] = sub_sampling_snake(Response); 
        
        % check fitness of all gates and select the best one:
        STICK = false;
        cf = zeros(1,n_gates);
        for g = 1:n_gates
            cf(g) = get_color_fitness([x(g), y(g), s(g)], Response, STICK, shape); 
        end
        if(n_gates >= 1)
            [v,i] = max(cf);
            x = x(i); y = y(i); s = s(i);
            n_gates = length(x);
        end
        % fit points of the remaining gates:
        for g = 1:n_gates
            
            % cut out a part of the Response map:
            size_factor = 1.2;
            x_l = round(x(g) - s(g) * size_factor);
            x_h = round(x(g) + s(g) * size_factor);
            y_l = round(y(g) - s(g) * size_factor);
            y_h = round(y(g) + s(g) * size_factor);
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
            
            INDIRECT = 0;
            DIRECT = 1;
            method = INDIRECT;
            if(method == INDIRECT)
                % other settings:
                SQUARE = 1;
                CIRCLE = 2;
                shape = SQUARE;
                [xx, yy, ss, best_fit, valid, height_left, height_right, angle, angle_1, angle_2] = fit_window_to_points(points, x(g) - x_l, y(g) - y_l, s(g), weights, shape, Response);
                % correct for the fact that the Response map was cropped:
                x(g) = xx + x_l;
                y(g) = yy + y_l;
                s(g) = ss;
                
                % determine what ratio of the shape is in the right color:
                STICK = false;
                cf = get_color_fitness([x(g), y(g), s(g)], Response, STICK, shape);
                % a good fit has a high ratio:
                color = cf * [0 1 0] + (1-cf) * [1 0 0];
                text(x(g)-15, y(g), num2str(cf), 'Color', color);
                if(shape == CIRCLE)
                    circle(x(g),y(g),s(g), color, 5);
                else
                    Q1 = [x(g)-s(g); y(g)-s(g)];
                    Q2 = [x(g)+s(g); y(g)-s(g)];
                    Q3 = [x(g)+s(g); y(g)+s(g)];
                    Q4 = [x(g)-s(g); y(g)+s(g)];
                    plot([Q1(1) Q2(1)], [Q1(2), Q2(2)], 'Color', color, 'LineWidth', 5);
                    plot([Q2(1) Q3(1)], [Q2(2), Q3(2)], 'Color', color, 'LineWidth', 5);
                    plot([Q3(1) Q4(1)], [Q3(2), Q4(2)], 'Color', color, 'LineWidth', 5);
                    plot([Q4(1) Q1(1)], [Q4(2), Q1(2)], 'Color', color, 'LineWidth', 5);
                    
                    if(valid && angle < 1)
                        text(x(g)-15, y(g)+15, ['Right of gate, ' num2str(angle)], 'Color', color);
                    else
                        text(x(g)-15, y(g)+15, ['Left of gate, ' num2str(angle)], 'Color', color);
                    end
                    
                    % COLOR CHECKING DOES NOT WORK NICELY IF NOT ON THE GATE
                    % LINE
                    %                 % get the angle to the gate:
                    %                 x_l = round(x(g) - s(g));
                    %                 x_h = round(x(g) + s(g));
                    %                 y_l = round(y(g) - s(g));
                    %                 y_h = round(y(g) + s(g));
                    %                 [x_l, y_l] = check_coordinate(x_l, y_l, size(Response,2), size(Response, 1));
                    %                 [x_h, y_h] = check_coordinate(x_h, y_h, size(Response,2), size(Response, 1));
                    %                 [y_low_left, y_high_left] = snake_up_and_down(x_l, round(y(g)), Response);
                    %                 height_left = y_high_left - y_low_left;
                    %                 [y_low_right, y_high_right] = snake_up_and_down(x_h, round(y(g)), Response);
                    %                 height_right = y_high_right - y_low_right;
                    %                 if(height_right > 0)
                    %                     height_ratio = height_left / height_right;
                    %                 else
                    %                     height_ratio = 1;
                    %                 end
                    %                 if(height_ratio < 1)
                    %                     text(x(g)-15, y(g)+15, ['Right of gate, ' num2str(height_ratio)], 'Color', color);
                    %                 else
                    %                     text(x(g)-15, y(g)+15, ['Left of gate, ' num2str(height_ratio)], 'Color', color);
                    %                 end
                end
                % plot stick:
                plot([x(g) x(g)], [y(g)+s(g), y(g)+2*s(g)], 'Color', color, 'LineWidth', 5);
                % plot clock arms:
                if(~isempty(angle_1))
                    plot_arms([angle_1, angle_2], color, x(g), y(g));
                end
                
                % get QR code area:
                min_y = round(y(g)-s(g));
                max_y = round(y(g)-0.5*s(g));
                min_x = x(g)+s(g);
                max_x = x(g)+1.5*s(g);
                [min_x, min_y] = check_coordinate(min_x, min_y, size(RGB,2), size(RGB,1));
                [max_x, max_y] = check_coordinate(max_x, max_y, size(RGB,2), size(RGB,1));
                QR_Patch = RGB(min_y:max_y, min_x:max_x, :);
                search_for_QR_corners([], QR_Patch);
                %                 figure();
                %                 imshow(QR_Patch);
            else
                % coordinates have to be in the original image size:
                
                [X0, Y0, Z0, psi0] = get_initial_direct_hypothesis(x(g), y(g), s(g));
                visualize_direct_genome([X0, Y0, Z0, psi0]);
                points(:,1) = points(:,1) + x_l;
                points(:,2) = points(:,2) + y_l;
                [X, Y, Z, psi, best_fit] = fit_window_to_points_direct(points, X0, Y0, Z0, psi0, weights, Response);
                genome = [X, Y, Z, psi];
                visualize_direct_genome(genome);
                
                figure();
                imagesc(Response);
                hold on;
                plot_gate([x(g), y(g), s(g)], 'white');
                [im_coords, visible] = translate_direct_genome_to_image_coords(genome);
                plot_im_coords(im_coords, 'green');
                [im_coords, visible] = translate_direct_genome_to_image_coords([X0, Y0, Z0, psi0]);
                plot_im_coords(im_coords, 'yellow');
                waitforbuttonpress;
            end
        end
    end
    
    CORNER = false;
    if(CORNER)
        I = rgb2gray(RGB);
        
        figure();
        imshow(I); % grayscale detection is very difficult (with the dark red gates)
        
        
        % FAST corners do not work well:
        %         corners = detectFASTFeatures(I);
        %         Rcorners = detectFASTFeatures(Response);
        %         figure();
        %         subplot(1,2,1);
        %         imshow(I); hold on;
        %         plot(corners.selectStrongest(200));
        %         title('Grayscale corners');
        %         subplot(1,2,2);
        %         imagesc(Response); hold on;
        %         plot(Rcorners.selectStrongest(200));
        %         title('Response corners');
        
        % Gradients are hardly visible at the gate. Perhaps do local
        % normalization:
        
        %         [DX, DY] = gradient(I);
        %
        %         figure();
        %         subplot(1,2,1);
        %         imagesc(DX);
        %         subplot(1,2,2);
        %         imagesc(DY);
    end
    
    waitforbuttonpress;
    %     close all;
end

function [x, y] = check_coordinate(x, y, W, H)
% function [x, y] = check_coordinate(x, y, W, H)

x = max([1,x]);
x = min([W,x]);
y = max([1,y]);
y = min([H,y]);

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