function find_QR_image(RGB)
% function find_QR_image(RGB)

HSV = rgb2hsv(RGB);
% find gray areas:
GrayColor = (HSV(:,:,2) <= 0.2) .* HSV(:,:,2);

W = size(RGB, 2); H = size(RGB, 1);
Gray = rgb2gray(RGB);
window_size = 30;
Std = zeros(H-window_size, W-window_size);
for x = 1:W-window_size
    for y = 1:H-window_size
        Sub = Gray(y:y+window_size, x:x+window_size);
        Std(y, x) = std(Sub(:));
    end
end

figure();
subplot(1,2,1); imagesc(GrayColor);
subplot(1,2,2); imagesc(Std);
waitforbuttonpress;
close all;
