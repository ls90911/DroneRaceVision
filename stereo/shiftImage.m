function I = shiftImage(I, v_shift, h_shift)
% function I = shiftImage(I, v_shift, h_shift)

if(v_shift > 0)
    % shift image down:
    I(1+v_shift:end, :, :) = I(1:end-v_shift, :, :);
    I(1:v_shift, :, :) = 0;
elseif (v_shift < 0)
    % shift the image up:
    v = abs(v_shift);
    I(1:end-v, :, :) = I(1+v:end, :, :);
    I(end-v+1:end, :, :) = 0;
end

if(h_shift > 0)
    % shift image to the right:
    I(:, 1+h_shift:end, :) = I(:, 1:end-h_shift, :);
    I(:, 1:h_shift, :) = 0;
elseif(h_shift < 0)
    h = abs(h_shift);
    I(:, 1:end-h, :) = I(:, 1+h:end, :);
    I(:, end-h+1:end, :) = 0;
end