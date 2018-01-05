function yuv_raw()

img = load('img_00005.csv');
rgb = double(imread('img_00005.jpg'))./255;

MATLAB_CONV = 1;
JPEG_CONV = 2;
BT601 = 3;
BT2020 = 4;
METHOD = JPEG_CONV;
if(METHOD == MATLAB_CONV)
    ycv = rgb2ycbcr(rgb);
    y = double(ycv(:,:,1))./255;
    u = double(ycv(:,:,2))./255;
    v = double(ycv(:,:,3))./255;
elseif(METHOD == JPEG_CONV)
    y = 0.299 * rgb(:,:,1) + 0.587 * rgb(:,:,2) + 0.114 * rgb(:,:,3);
    u = 0.5 - 0.168736 * rgb(:,:,1) - 0.331264 * rgb(:,:,2) + 0.5 * rgb(:,:,3);
    v = 0.5 + 0.5 * rgb(:,:,1) - 0.418688 * rgb(:,:,2) - 0.081312 * rgb(:,:,3);
elseif(METHOD == BT601)
    y = 16/255 + 65.481 * rgb(:,:,1) + 128.553 * rgb(:,:,2) + 24.966 * rgb(:,:,3);
    u = 128 - 37.797 * rgb(:,:,1) - 74.203 * rgb(:,:,2) + 112.0 * rgb(:,:,3);
    v = 128 + 112.0 * rgb(:,:,1) - 93.786 * rgb(:,:,2) - 18.214 * rgb(:,:,3);
    y = y ./ 255;
    u = u ./ 255;
    v = v ./ 255;
elseif(METHOD == BT2020)
    y = 0.299 * rgb(:,:,1) + 0.0593 * rgb(:,:,2) + 0.2627 * rgb(:,:,3);
    u = 0.5 - 0.168736 * rgb(:,:,1) - 0.331264 * rgb(:,:,2) + 0.5 * rgb(:,:,3);
    v = 0.5 + 0.5 * rgb(:,:,1) - 0.418688 * rgb(:,:,2) - 0.081312 * rgb(:,:,3);
end

% learn coefficients:
% Y = img(:,2:2:end,:) ./ 255;
% targets = Y(:);
% U = img(:,2:2:end,:) ./ 255;
% targets = U(:);
% r = rgb(:,:,1);
% g = rgb(:,:,1);
% b = rgb(:,:,1);
% A = [r(:), g(:), b(:), ones(length(targets),1)];
% targets = A * [0.1;-0.2;0.3;0.0];
% x = A \ targets;
% est = A * x;
% est = reshape(est, [640, 480]);
% figure();
% % imagesc(Y-est);
% imagesc(U-est);


ycv = rgb;
ycv(:,:,1) = y;
ycv(:,:,2) = u;
ycv(:,:,3) = v;
ycv = ycv(:,1:2:end,:);
y = y(:,1:2:end,:);
u = u(:,1:2:end,:);
v = v(:,1:2:end,:);

% Y = img(:,2:2:end,:);
Y = img(:,2:4:end,:) ./ 255;
U = img(:,1:4:end,:) ./ 255;
V = img(:,3:4:end,:) ./ 255;

JPEG_INV = true;
if(JPEG_INV)
    R = Y + 1.402 * (V - 0.5);
    G = Y - 0.344136 * (U - 0.5) - 0.714136 * (V-0.5) ;
    B = Y + 0.1772 * (U - 0.5);
    RGB = zeros(640,240,3);
    RGB(:,:,1) = R;
    RGB(:,:,2) = G;
    RGB(:,:,3) = B;
    figure();
    imshow(RGB);
    title('Inv jpeg');
end
err = abs(Y(:)-y(:));
MAE = mean(err);
fprintf('MAE Y = %f\n', MAE);

figure();
subplot(1,3,1); imagesc(Y-y);
subplot(1,3,2); imagesc(U-u);
subplot(1,3,3); imagesc(V-v);


figure();
subplot(1,3,1)
imshow(Y)

subplot(1,3,2)
imshow(U)

subplot(1,3,3)
imshow(V)

YCV = zeros(size(Y,1), size(Y,2), 3);
YCV(:,:,1) = Y;
YCV(:,:,2) = U;
YCV(:,:,3) = V;

cr_min = 150.0 / 255.0;
dy_min = 0.05;
Response = filter_YCV(YCV, cr_min, dy_min);
figure(); 
imagesc(Response);



function Response = filter_YCV(YCV, cr_min, dy_min)
[DX, DY] = gradient(YCV(:,:,3));
DY = abs(DY);
DX = abs(DX);
Response = DY > dy_min | YCV(:,:,3) > cr_min;
figure();
subplot(1,2,1); imagesc(YCV(:,:,3) > cr_min);
subplot(1,2,2); imagesc(DY > dy_min);