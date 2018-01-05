function QR_Im_distorted = distort_QR_image(QR_Im, im_size, im_size_variation, local_brightness)
% function QR_Im_distorted = distort_QR_image(QR_Im, im_size, im_size_variation, local_brightness)

% reduce contrast:
I_min = min(QR_Im(:));
I_max = max(QR_Im(:));
contrast = 0.2 + 0.8 * rand(1) * (I_max - I_min);
I_middle = (I_max + I_min) / 2;
QR_Im = QR_Im - I_min;
QR_Im = QR_Im * contrast;
QR_Im = QR_Im + I_middle - contrast / 2;

% add local brightness:
P_lb = 0.1;
if(rand(1) < P_lb)
    lb = true; 
    if(~exist('localbrightness', 'var') || isempty(local_brightness))
        local_brightness = zeros(30);
        W = size(local_brightness, 2);
        H = size(local_brightness, 1);
        x_c = W/2;
        y_c = H/2;
        for x = 1:W
            for y = 1:H
                d = sqrt((x-x_c)^2 + (y-y_c)^2);
                local_brightness(y,x) = 1 - (d/x_c)^2;
                if(local_brightness(y,x) < 0)
                    local_brightness(y,x) = 0;
                end
            end
        end
        local_brightness = (0.3 + 0.5 * rand(1)) * local_brightness;
    end
else
    lb = false;
end

% first vary the size.
% If bigger, crop it
% If smaller, paste it in a random background
sv = round(rand(1) * 2 * im_size_variation - im_size_variation);
if(sv > 0)
    % first make the image bigger:
    QR_Im_distorted = imresize(QR_Im, [im_size+sv, im_size+sv]);
    % then crop:
    shift_x = round(rand(1) * floor(sv/2) - floor(sv/4));
    shift_y = round(rand(1) * floor(sv/2) - floor(sv/4));
    QR_Im_distorted = imcrop(QR_Im_distorted, [floor(sv/2)+shift_y floor(sv/2)+shift_x im_size im_size]);
elseif(sv < 0)
    % make the image smaller:
    QR_Im_distorted = imresize(QR_Im, [im_size+sv, im_size+sv]);
    % make a (dark) rightly sized image:
    Im = (0.3 + rand(1) * 0.3) * ones(im_size);
    % random-like background texture
    Im = Im + 0.4 * rand(im_size);
    sv = abs(sv);
    %fprintf('sv = %d\n', sv);
    % randomly translate the code: (don't worry - I also hardly get these 
    % few lines of code here anymore:
    shift_x = round(rand(1) * (ceil(sv/2)-1) - (round(sv/4)-1));
    shift_y = round(rand(1) * (ceil(sv/2)-1) - (round(sv/4)-1));
    Im(ceil(sv/2)+shift_y:ceil(sv/2)+shift_y+im_size-sv-1, ceil(sv/2)+shift_x:ceil(sv/2)+shift_x+im_size-sv-1) = QR_Im_distorted;
    QR_Im_distorted = Im;
else
    QR_Im_distorted = QR_Im;
end

% slightly rotate the image:
std_angle = (5/180) * pi;
angle = randn(1) * std_angle;
QR_Im_distorted = imrotate(QR_Im_distorted, angle);

% change global illuminance:
std_illuminance = 0.1;
global_ill = randn(1) * std_illuminance;
QR_Im_distorted = QR_Im_distorted + global_ill;

% blur:
max_blur_length = 4;
filter = zeros(max_blur_length*2+1);
length_blur = round(max_blur_length*rand(1));
filter(max_blur_length+1, max_blur_length+1-length_blur:max_blur_length+1+length_blur) = 1;
angle = rand(1) * 2 * pi;
filter = imrotate(filter, angle);
filter(max_blur_length+1,max_blur_length+1) = 1;
filter = filter / sum(filter(:));
QR_Im_distorted = imfilter(QR_Im_distorted, filter);

% pixel noise
n_pixels = 0;
std_noise = 0.1;
for p = 1:n_pixels
   x = 1 + floor(rand(1)*im_size);
   y = 1 + floor(rand(1)*im_size);
   QR_Im_distorted(y,x) = QR_Im_distorted(y,x) + randn(1) * std_noise;
end

% local brightness:
if(lb)
    x = 1 + floor(rand(1) * (size(QR_Im_distorted, 2)-size(local_brightness, 2)-1));
    y = 1 + floor(rand(1) * (size(QR_Im_distorted, 1)-size(local_brightness, 1)-1));
    QR_Im_distorted(y:y+H-1, x:x+W-1) = QR_Im_distorted(y:y+H-1, x:x+W-1) + local_brightness;
end

% also already above...
% normally distributed noise on the pixels:
% n_noisy_pixels = 0.05 * im_size * im_size;
% n_pixels = im_size * im_size;
% for np = 1:n_noisy_pixels
%     ind = ceil(rand(1) * n_pixels);
%     QR_Im_distorted(ind) = QR_Im_distorted(ind) + randn(1) * (std_illuminance/2);
% end

% check bounds:
inds = find(QR_Im_distorted < 0);
QR_Im_distorted(inds) = 0;
inds = find(QR_Im_distorted > 1);
QR_Im_distorted(inds) = 1;
