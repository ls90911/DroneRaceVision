function [Hor, Ver] = filter_borders(Response, border_size)
% function [Hor, Ver] = filter_borders(Response, border_size)

W = size(Response,2); H = size(Response,1);
II = getIntegralImage(Response);
border_x = 100;
border_y = 100;
Ver = zeros(W-3*border_size, 1);
% Center surround ding
for x = 1:W-3*border_size
    Ver(x) = - getAvgDisparity(x, border_y, x+3*border_size, H-border_y, II) + ...
                2 * getAvgDisparity(x+border_size, border_y, x+2*border_size-1, H-border_y, II);
end
Hor = zeros(H-3*border_size, 1);
for y = 1:H-3*border_size
        Hor(y) = - getAvgDisparity(border_x, y, W-border_x, y+3*border_size, II) + ...
                2 * getAvgDisparity(border_x, y+border_size, W-border_x, y+2*border_size-1,  II);
end


figure();
imagesc(Response);
hold on;
smooth_factor = 1;
[pks_hor, locs_hor] = findpeaks(smooth(Hor, smooth_factor), 'MinPeakDistance', 30); % 'MinPeakProminence',4
[pks_ver, locs_ver] = findpeaks(smooth(Ver, smooth_factor), 'MinPeakDistance', 30); % 'MinPeakProminence',4,
locs_hor = locs_hor + 1.5*border_size;
locs_ver = locs_ver + 1.5*border_size;
for i = 1:length(pks_hor)
    if(pks_hor(i) > mean(pks_hor))
        plot([1 size(Response,2)], [locs_hor(i) locs_hor(i)], 'Color', 'red');
    end
end
for i = 1:length(pks_ver)
    if(pks_ver(i) > mean(pks_ver))
        plot([locs_ver(i) locs_ver(i)], [1 size(Response,1)], 'Color', 'red');
    end
end


figure();
subplot(1,2,1);
bar(smooth(Ver, smooth_factor), 'EdgeColor', 'none');
hold on;
b = bar(Ver, 'FaceColor', 'green', 'EdgeColor', 'none');
b.FaceAlpha = 0.3;
bar(locs_ver-1.5*border_size, pks_ver, 'FaceColor', 'red', 'EdgeColor', 'none');
title('Vertical');
subplot(1,2,2);
bar(smooth(Hor, smooth_factor), 'EdgeColor', 'none');
hold on;
b = bar(Hor, 'FaceColor', 'green', 'EdgeColor', 'none');
b.FaceAlpha = 0.3;
bar(locs_hor-1.5*border_size, pks_hor, 'FaceColor', 'red', 'EdgeColor', 'none');
title('Horizontal');

% find biggest two peaks:
[vals, inds] = sort(pks_ver, 'descend');
locs = locs_ver(inds);
figure('Name', 'Yaw-Control', 'NumberTitle', 'off');
imagesc(Response);
hold on;
if(length(locs) >= 2)
    vals = vals(1:2);
    locs = locs(1:2);
    if(mean(vals) > 1 && abs(1-vals(2)/vals(1)) < 0.5)
        plot_color = 'green';
    else
        plot_color = 'red';
    end
    for i = 1:length(vals)
        plot([locs(i) locs(i)], [1 size(Response,1)], 'Color', plot_color, 'LineWidth', 2);
    end
    plot(mean(locs), size(Response, 1) / 2, 'x', 'MarkerSize', 10, 'LineWidth', 2, 'Color', plot_color);
    
end



function dd = getAvgDisparity(min_x, min_y, max_x, max_y, II)
% function dd = getAvgDisparity(min_x, min_y, max_x, max_y, II)
w = max_x - min_x + 1;
h = max_y - min_y + 1;
n_pix = w * h;
sum_disparities = II(min_y, min_x) +  II(max_y, max_x) - II(min_y, max_x) - II(max_y, min_x);
dd = sum_disparities / n_pix;