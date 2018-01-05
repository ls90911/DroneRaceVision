function detect_window_corners(Response)
% function detect_window_corners(Response)

% get integral image:
II = getIntegralImage(Response);

window_sizes = [5, 10];
n_ws = length(window_sizes);
for w = 1:n_ws
    CR = get_corner_response(II, window_sizes(w));
    figure();
    title(['window size ' num2str(window_sizes(w))]);
    subplot(2,2,1);
    imagesc(CR{1});
    [value, location] = max(CR{1}(:));
    [y,x] = ind2sub(size(CR{1}),location);
    hold on;
    plot(x, y,'x', 'Color', 'red', 'MarkerSize', 10, 'LineWidth', 3);
    title('Bottom right');
    subplot(2,2,2);
    imagesc(CR{2});
    [value, location] = max(CR{2}(:));
    [y,x] = ind2sub(size(CR{1}),location);
    hold on;
    plot(x, y,'x', 'Color', 'red', 'MarkerSize', 10, 'LineWidth', 3);
    title('Top right');
    subplot(2,2,3);
    imagesc(CR{3});
    [value, location] = max(CR{3}(:));
    [y,x] = ind2sub(size(CR{1}),location);
    hold on;
    plot(x, y,'x', 'Color', 'red', 'MarkerSize', 10, 'LineWidth', 3);
    title('Bottom left');
    subplot(2,2,4);
    imagesc(CR{4});
    [value, location] = max(CR{4}(:));
    [y,x] = ind2sub(size(CR{1}),location);
    hold on;
    plot(x, y,'x', 'Color', 'red', 'MarkerSize', 10, 'LineWidth', 3);
    title('Top left');
    
    % detect corners in one of the convolutions:
    figure();
    subplot(2,2,1);
    II_CR = getIntegralImage(CR{1});
    CCR = get_butterfly_response(II_CR, round(window_sizes(w)*1.2), [3, -1, -1, -1]);
    [value, location] = max(CCR(:));
    [y,x] = ind2sub(size(CCR),location);
    imagesc(CCR);
    hold on;
    plot(x, y,'x', 'Color', 'red', 'MarkerSize', 10, 'LineWidth', 3);
    title(['Bottom right size = ' num2str(window_sizes(w))]);
    subplot(2,2,2);
    II_CR = getIntegralImage(CR{2});
    CCR = get_butterfly_response(II_CR, round(window_sizes(w)*1.2), [-1, 3, -1, -1]);
    [value, location] = max(CCR(:));
    [y,x] = ind2sub(size(CCR),location);
    imagesc(CCR);
    hold on;
    plot(x, y,'x', 'Color', 'red', 'MarkerSize', 10, 'LineWidth', 3);
    title(['Top right size = ' num2str(window_sizes(w))]);
    subplot(2,2,3);
    II_CR = getIntegralImage(CR{3});
    CCR = get_butterfly_response(II_CR, round(window_sizes(w)*1.2), [-1, -1, 3, -1]);
    [value, location] = max(CCR(:));
    [y,x] = ind2sub(size(CCR),location);
    imagesc(CCR);
    hold on;
    plot(x, y,'x', 'Color', 'red', 'MarkerSize', 10, 'LineWidth', 3);
    title(['Bottom left size = ' num2str(window_sizes(w))]);
    subplot(2,2,4);
    II_CR = getIntegralImage(CR{4});
    CCR = get_butterfly_response(II_CR, round(window_sizes(w)*1.2), [-1, -1, -1, 3]);
    [value, location] = max(CCR(:));
    [y,x] = ind2sub(size(CCR),location);
    imagesc(CCR);
    hold on;
    plot(x, y,'x', 'Color', 'red', 'MarkerSize', 10, 'LineWidth', 3);
    title(['Top left size = ' num2str(window_sizes(w))]);
end

function CR = get_corner_response(II, window_size)
% function CR = get_corner_response(II, window_size)

% There are four types of corners:
% top left, top right, etc.
CR = cell(4,1);

for x = window_size+1:size(II,2)-window_size
    for y = window_size+1:size(II,1)-window_size
        
        whole_window = get_mean_value(II, x-window_size, y-window_size, 2*window_size);
        size_ww = ((2*window_size+1)*(2*window_size+1));
        
        % top left
        sc1 = get_mean_value(II, x-window_size, y-window_size, window_size);
        % bottom left
        sc2 = get_mean_value(II, x-window_size, y, window_size);
        % top right
        sc3 = get_mean_value(II, x, y-window_size, window_size);
        % bottom right
        sc4 = get_mean_value(II, x, y, window_size);
        size_sc = (window_size+1)*(window_size+1);
        
        c1 = whole_window - sc1;
        c2 = whole_window - sc2;
        c3 = whole_window - sc3;
        c4 = whole_window - sc4;
        size_c = size_ww - size_sc;
        
        CR{1}(y,x) = c1 / size_c - sc1 / size_sc;
        CR{2}(y,x) = c2 / size_c - sc2 / size_sc;
        CR{3}(y,x) = c3 / size_c - sc3 / size_sc;
        CR{4}(y,x) = c4 / size_c - sc4 / size_sc;
    end
end

function mean_val = get_mean_value(II, x, y, sz)
% function mean_val = get_mean_value(II, x, y, sz)
mean_val = II(y+sz, x+sz) + II(y,x) - II(y, x+sz) - II(y+sz, x);


function CCR = get_butterfly_response(II, window_size, weights)
% function CCR = get_butterfly_response(II, window_size, weights)

for x = window_size+1:size(II,2)-window_size
    for y = window_size+1:size(II,1)-window_size
        
        % top left
        sc1 = get_mean_value(II, x-window_size, y-window_size, window_size);
        % bottom left
        sc2 = get_mean_value(II, x-window_size, y, window_size);
        % top right
        sc3 = get_mean_value(II, x, y-window_size, window_size);
        % bottom right
        sc4 = get_mean_value(II, x, y, window_size);
        size_sc = (window_size+1)*(window_size+1);
        
        CCR(y,x) = weights(1) * sc1 / size_sc + weights(2) * sc2 / size_sc ...
                    + weights(3) * sc3 / size_sc + weights(4) * sc4 / size_sc;
    end
end
