function grow_outward(Response, xc, yc)
% function grow_outward(Response, xc, yc)

% single pixels:
mR = mean(Response(:));
H = size(Response, 1);
W = size(Response, 2);
n_directions = 30;
sizes = zeros(n_directions, 1);
pos = [];
for di = 1:n_directions
    x = xc;
    y = yc;
    dx = 2 * rand(1) - 1;
    dy = 2 * rand(1) - 1;
    v = ([dx dy]) ./ norm([dx dy]);
    dx = v(1); dy = v(2);
    sizes(di) = 0;
    while(x >= 1 && x <= W && y >= 1 && y <= H)
        x = x + dx;
        y = y + dy;
        yy = min([H, max([round(y), 1])]);
        xx = min([max([round(x), 1]), W]);
        if(Response(yy, xx) >= mR)
            pos = [pos; [xx, yy]];
            break;
        else
            sizes(di) = sizes(di) + 1;
        end
    end
end

h = figure();
imagesc(Response);
hold on;
plot(pos(:,1), pos(:,2), 'x', 'MarkerSize', 10, 'Color', 'red');
% still based on initial position:
size_init = mean(sizes);
rectangle2(h, xc - size_init, yc - size_init, xc + size_init, yc + size_init, 'yellow');

% make a better fit:
[x, y, s] =  fit_window_to_points(pos, xc, yc, size_init);
mean_sizes = mean(sizes);
if(mean(sizes) > 1e-10)
    ratio = abs(1 - median(sizes) / mean_sizes);
    fprintf('abs(1 - median / mean) = %f\n', ratio);
else
    ratio = 1;
end
ratio_threshold = 0.50;
if(s > 30 && ratio < ratio_threshold)
    rectangle2(h, x - s, y - s, x + s, y + s, 'green');
else
    rectangle2(h, x - s, y - s, x + s, y + s, 'red');
end

title(['Ratio = ' num2str(ratio) 'std = ' num2str(std(sizes)) ' mean size = ' num2str(mean(sizes))]);
