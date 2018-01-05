function [P, W] = convert_YUV_to_points(YUV)
% function [P, W] = convert_YUV_to_points(YUV)

U_thr = 0.45;
V_thr = 0.75;
Mask = (YUV(:,:,2) < U_thr) & (YUV(:,:,3) > V_thr);

P = [];
W = [];

for y = 1:size(YUV,1)
    for x = 1:size(YUV, 2);
        if(Mask(y,x))
            P = [P; [x*2, y]];
            weight = 1 - (YUV(y,x,2) / U_thr);
            weight = weight + (YUV(y,x,3) - V_thr) / (1 - V_thr);
            W = [W; weight];
        end
    end
end