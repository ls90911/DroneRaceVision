function gates_in_image = run_detection_on_dir(dir_name, graphics)
% function gates_in_image = run_detection_on_dir(dir_name, graphics)

% get file names:
if(~exist('dir_name', 'var') || isempty(dir_name))
    dir_name = 'real_arena';
end
if(~exist('graphics', 'var') || isempty(graphics))
    graphics = true;
end
image_names = makeListOfFiles(dir_name, 'jpg');
image_names = sort_nat(image_names);
n_images = length(image_names);

% whether to threshold the color response:
THRESHOLD = false; % true
CUT_OFF_PROPELLORS = false;
% the detection method (should be true in this file)
SUB_SAMPLING_SNAKE = true;

% filter images
for im = 1:n_images
    
    % read the image in RGB
    RGB = imread([dir_name '/' image_names{im}]);
    RGB = double(RGB) ./ 255;
    % return 3 * matrix RGB(:,:,1) RGB(:,:,2) RGB(:,:,3)
    % which are red green and blue respectively
    
    % potentially resize the image:
    if(strcmp(dir_name, 'images') || strcmp(dir_name, 'ventilator_images'))
        RGB = imrotate(RGB, 90);
    end
    if(strcmp(dir_name, 'phone_images') || strcmp(dir_name, 'real_arena'))
        RGB = imresize(RGB, 0.25);
    end
        
%     if(graphics)
%         % show the image:
%         figure(); imshow(RGB);
%         title('RGB image');
%     end
    
    % we filter in the hsv domain:
    FILTER_HSV = false;
    if(FILTER_HSV)
        HSV = rgb2hsv(RGB);
        H_ref = 0.10;%0;
        std_var = 0.1;
        S_thresh = 0.4;
        Response = filter_HSV(HSV, H_ref, std_var, S_thresh);
    else
        % Probably Michael's code:
        YCV = rgb2ycbcr(RGB);
        
        %--------------------------------
        % why?
        cr_min = 140.0 / 255.0;
        dy_min = 1; %0.05;
        %--------------------------------
        Response = filter_YCV(YCV, cr_min, dy_min);
        dy_min = 0.05;
        Response = filter_YCV(YCV, cr_min, dy_min);
    end
    
%     if(graphics)
%         figure(1);
%         imagesc(Response);
%         hold on;
%         title('Response Hue filter');
%     end
    
    
    if(SUB_SAMPLING_SNAKE)
        
        % USED in COMPETITION:
        
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
        
        
        
        % NOT USED in Competition:
        
        % fit points of the remaining gates:
        for g = 1:n_gates
            
            % cut out a part of the Response map:
            
            % make the square in figure 50 a little bit larger
            % only take color points to a matrix
            size_factor = 1.2;
            x_l = round(x(g) - s(g) * size_factor);
            x_h = round(x(g) + s(g) * size_factor);
            y_l = round(y(g) - s(g) * size_factor);
            y_h = round(y(g) + s(g) * size_factor);
            [x_l, y_l] = check_coordinate(x_l, y_l, size(Response,2), size(Response, 1));
            [x_h, y_h] = check_coordinate(x_h, y_h, size(Response,2), size(Response, 1));
            [points, weights] = convert_response_to_points(Response(y_l:y_h, x_l:x_h));
            
            % fit a window to it:
            % there are too many points, in order to 
            % increase the speed, just randomly select
            % at most 500 points
            max_points = 500;
            if(size(points,1) > max_points)
                inds = randperm(size(points,1));
                inds = inds(1:max_points);
                points = points(inds, :);
                weights = weights(inds, :);
            end
            
            INDIRECT = 0; % in the image domain (works)
            DIRECT = 1; % in the world coordinate frame (does not work)
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
    
    % remember gates for returning
    if(~isempty(x))
        gates_in_image{im}.x = x(1);
        gates_in_image{im}.y = y(1);
        gates_in_image{im}.s = s(1);
    end
    if(graphics)

       % waitforbuttonpress;
             close all;
    end
end

function [x, y] = check_coordinate(x, y, W, H)
% function [x, y] = check_coordinate(x, y, W, H)

x = max([1,x]);
x = min([W,x]);
y = max([1,y]);
y = min([H,y]);

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