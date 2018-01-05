function YUV = transformColor2YUV(C)
% function YUV = transformColor2YUV(C)
% Take a color image as generated by the stereo board and transform it to
% YUV
% format: Y V Y U ...

V = double(C(:, 2:4:end, 1)) ./ 255;
Y1 = C(:, 1:4:end, 1);
U = double(C(:, 4:4:end, 1)) ./ 255;
Y2 = C(:, 3:4:end, 1);
Y = (double(Y1) + double(Y2)) ./ (2 * 255);

YUV = zeros(size(U,1), size(U,2), 3);
YUV(:,:,1) = Y;
YUV(:,:,2) = U;
YUV(:,:,3) = V;

% h = figure();
% subplot(1,2,1);
% imshow(ycbcr2rgb(YUV));
% subplot(1,2,2);
% U_thr = 0.45;
% V_thr = 0.75;
% Mask = (U < U_thr) & (V > V_thr);
% imshow(Mask);
% waitforbuttonpress;
% close(h);
