function [xs,ys,ss,n_gates] = sub_sampling_snake(Response)
% function [xs,ys,ss,n_gates] = sub_sampling_snake(Response)
%
% Two phases:
% 1) take random samples
% 2) if a hit, snake:
%    (a) up and down. If long enough, test two hypotheses with color
%    fitness.
%    (b) left and right. If long enough test two hypotheses with color
%    fitness.

STICK = false;
SQUARE = 1;
CIRCLE = 2;
SHAPE = SQUARE;
MAX_SAMPLES = 500;
W = size(Response,2);
H = size(Response,1);
xs = []; ys = []; ss = [];
min_pixel_size = 100;
min_fit = 0.45;
graphics = false;
if(graphics)
    figure();
    imagesc(Response);
    hold on;
end

for s = 1:MAX_SAMPLES
    
    x = 1 + floor(rand(1)*(W-1));
    y = 1 + floor(rand(1)*(H-1));
    
    if(Response(y,x) > 0)
        % only up and down:
        [y_low, y_high] = snake_up_and_down(x, y, Response);
        sz = (y_high - y_low);
        y = (y_high + y_low) / 2;
        
        if(graphics)
            if(sz < min_pixel_size) % || y_high < size(Response,1)/2)
                plot([x, x], [y_low, y_high], 'Color', 'red');
            else
                plot([x, x], [y_low, y_high], 'Color', 'green', 'LineWidth', 5);
            end
        end
        % check if the vertical stretch is long enough:
        if(sz > min_pixel_size)
            % snake left and right:
            [x_low1, x_high1] = snake_left_and_right(x, y_low, Response);
            [x_low2, x_high2] = snake_left_and_right(x, y_high, Response);
            szx1 = x_high1-x_low1;
            szx2 = x_high2-x_low2;
            if(graphics)
                if(szx1 < min_pixel_size) % || y_high < size(Response,1)/2)
                    plot([x_low1, x_high1], [y_low, y_low], 'Color', 'red');
                else
                    plot([x_low1, x_high1], [y_low, y_low], 'Color', 'green', 'LineWidth', 5);
                end
                if(szx2 < min_pixel_size) % || y_high < size(Response,1)/2)
                    plot([x_low2, x_high2], [y_high, y_high], 'Color', 'red');
                else
                    plot([x_low2, x_high2], [y_high, y_high], 'Color', 'green', 'LineWidth', 5);
                end
            end
            
            if(szx1 > min_pixel_size)
                x = (x_high1 + x_low1) / 2;
                sz = max([sz, szx1]);%(szx1 + sz) / 2;
                xs = [xs; x];
                ys = [ys; y];
                ss = [ss; sz/2];
            elseif(szx2 > min_pixel_size)
                x = (x_high2 + x_low2) / 2;
                sz = max([szx2, sz]);%(szx2 + sz) / 2;
                xs = [xs; x];
                ys = [ys; y];
                ss = [ss; sz/2];
            end
        end
    end
end

n_gates = length(xs);
