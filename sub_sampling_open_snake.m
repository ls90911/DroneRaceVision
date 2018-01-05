function [xs, yl1, yl2, yr2, yr1, sb, n_opengates] = sub_sampling_open_snake(Response)
% central x; lower left; upper left; upper right; lower right; size of bars;
MAX_SAMPLES = 1000;
MAX_SUB_SAMPLES = 100;
W = size(Response, 2);
H = size(Response, 1);

xs =[]; yl1 = []; yl2 = []; yr1 = []; yr2 = []; sb = [];

% 1, 2, 3, 4 -> lower left, upper left, upper right, lower right;
% 1, 2, 3, 4 -> l1, l2, r2, r1(1: lower 2: higher).
FOUND = [0, 0, 0, 0];
x_inner = [0, 0, 0, 0];
x_corners = [0, 0, 0, 0];
y_central = [0, 0, 0, 0];
min_pixel_size = 120;
min_pixel_size1 = 60;
min_fit = 0.45;
graphics = true;

if(graphics)
    figure();
    imagesc(Response);
    title('initial snake gate detect')
    hold on;
end

for s = 1:MAX_SAMPLES
    
    x = min(1 + floor(rand(1)*(W-1)),W);
    y = min(1 + floor(rand(1)*(H-1)), H);
    
    if(Response(y, x) > 0)
        [y_low, y_high] = snake_up_and_down(x, y, Response);
        sz = y_high - y_low;
        
%         if(graphics)
%             if(sz < min_pixel_size) % || y_high < size(Response,1)/2)
%                 plot([x, x], [y_low, y_high], 'Color', 'red');
%             else
%                 plot([x, x], [y_low, y_high], 'Color', 'green', 'LineWidth', 5);
%             end
%         end
        if(sz > min_pixel_size)
            y_m_quarter = y_low - floor(rand(1)*(sz/4));
            y_m_quarter = check_y_coordinates(y_m_quarter, size(Response, 1));
            y_quarter = y_low + floor(rand(1)*(sz/4));
            y_quarter = check_y_coordinates(y_quarter, size(Response, 1));
            y_third_quarter = y_high - floor(rand(1)*(sz/4));
            y_third_quarter = check_y_coordinates(y_third_quarter, size(Response, 1));
            y_five_quarter = y_high + floor(rand(1)*(sz/4));
            y_five_quarter = check_y_coordinates(y_five_quarter, size(Response, 1));
            if(graphics)
                plot([x, x], [y_m_quarter, y_quarter], 'Color', 'white', 'LineWidth', 2);
                plot([x, x], [y_third_quarter, y_five_quarter], 'Color', 'white', 'LineWidth', 2);
            end
            for i = 1:MAX_SUB_SAMPLES
                % larger y indicates bigger row number in matlab.
                y_lower_rand = y_third_quarter + floor(rand(1)*(y_five_quarter-y_third_quarter)); % y_m_quarter + floor(rand(1)*(y_quarter-y_m_quarter))
                [x_low1, x_high1] = snake_left_and_right(x, y_lower_rand, Response);
                szx1 = x_high1 - x_low1;
                if(szx1 > min_pixel_size1)
                    fprintf('lower horizontal found\n');
                    if((x_low1 + x_high1)/2 < x)
                        y_central(1) = y_lower_rand;
                        x_inner(1) = x_high1;
                        x_corners(1) = x_low1;
                        FOUND(1) = 1;
                    else
                        y_central(4) = y_lower_rand;
                        x_inner(4) = x_low1;
                        x_corners(4) = x_high1;
                        FOUND(4) = 1;
                    end
                end
                if (FOUND(1) && FOUND(4))
                    break;
                end
            end
            for i = 1:MAX_SUB_SAMPLES
                y_upper_rand = y_m_quarter + floor(rand(1)*(y_quarter-y_m_quarter)); % y_third_quarter + floor(rand(1)*(y_five_quarter-y_third_quarter))
                [x_low2, x_high2] = snake_left_and_right(x, y_upper_rand, Response);
                szx2 = x_high2 - x_low2;
                if(szx2 > min_pixel_size1)
                    fprintf('upper horizontal found\n');
                    if((x_low2 + x_high2)/2 < x)
                        y_central(2) = y_upper_rand;
                        x_inner(2) = x_high2;
                        x_corners(2) = x_low2;
                        FOUND(2) = 1;
                    else
                        y_central(3) = y_upper_rand;
                        x_inner(3) = x_low2;
                        x_corners(3) = x_high2;
                        FOUND(3) = 1;
                    end
                end
                if (FOUND(2) && FOUND(3))
                    break;
                end
            end
            
            if ((FOUND(1) || FOUND(4)) || (FOUND(2) || FOUND(3)))
                xs = [xs; x];
                if((FOUND(1) || FOUND(4)))
                    sb = [sb; 
                        max(x_inner(1)-x_corners(1), x_corners(4)-x_inner(4))];
                elseif(~(FOUND(1) || FOUND(4)) && (FOUND(2) || FOUND(3)))
                    sb = [sb; 
                        max(x_inner(2)-x_corners(2), x_corners(3)-x_inner(3))];
                else
                end
                if (FOUND(1) && FOUND(4))
                    yl1 = [yl1; y_central(1)];
                    yr1 = [yr1; y_central(4)];
                    y_min = min(y_central(1), y_central(4));
                elseif (FOUND(1) && ~FOUND(4))
                    yl1 = [yl1; y_central(1)];
                    yr1 = [yl1; y_central(1)];
                    y_min = y_central(1);
                elseif (~FOUND(1) && FOUND(4))
                    yl1 = [yl1; y_central(4)];
                    yr1 = [yr1; y_central(4)];
                    y_min = y_central(4);
                else
                    yl1 = [yl1; y_high];
                    yr1 = [yr1; y_high];
                    y_min = y_high;
                end
                
                if (FOUND(2) && FOUND(3))
                    yl2 = [yl2; y_central(2)];
                    yr2 = [yr2; y_central(3)];
                    y_max = max(y_central(2), y_central(3));
                elseif (FOUND(2) && ~FOUND(3))
                    yl2 = [yl2; y_central(2)];
                    yr2 = [yr2; y_central(2)];
                    y_max = y_central(2);
                elseif (~FOUND(2) && FOUND(3))
                    yl2 = [yl2; y_central(3)];
                    yr2 = [yr2; y_central(3)];
                    y_max = y_central(3);
                else
                    yl2 = [yl2; y_low];
                    yr2 = [yr2; y_low];
                    y_max = y_low;
                end
                if(graphics)
                    plot([x, x], [y_min, y_max], 'Color', 'green', 'LineWidth', 0.5);
                    if(FOUND(1))
                        plot([x-sb(end), x], [y_central(1), y_central(1)], 'Color', 'black', 'LineWidth', 2);
                    end
                    if(FOUND(2))
                        plot([x-sb(end), x], [y_central(2), y_central(2)], 'Color', 'white', 'LineWidth', 2);
                    end
                    if(FOUND(3))
                        plot([x+sb(end), x], [y_central(3), y_central(3)], 'Color', 'red', 'LineWidth', 2);
                    end
                    if(FOUND(4))
                        plot([x+sb(end), x], [y_central(4), y_central(4)], 'Color', 'magenta', 'LineWidth', 2);
                    end
                end
            end
            y_central(:) = 0;
            x_inner(:) = 0;
            x_corners(:) = 0;
            FOUND(:) = 0;
        end
    end
end
n_opengates = length(xs);

            
function y = check_y_coordinates(y, H)
% function [x, y] = check_coordinate(x, y, W, H)

y = max([1,y]);
y = min([H,y]);