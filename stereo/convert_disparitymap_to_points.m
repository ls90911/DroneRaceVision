function [P, W] = convert_disparitymap_to_points(D, min_threshold, YUV)
% function [P, W] = convert_disparitymap_to_points(D, min_threshold, YUV)

if(~exist('min_threshold', 'var') || isempty(min_threshold))
    min_threshold = 0;
end

if(exist('YUV', 'var') && ~isempty(YUV))
    U_thr = 0.45;
    V_thr = 0.75;
    Mask = (YUV(:,:,2) < U_thr) & (YUV(:,:,3) > V_thr);
    COLOR = true;
else
    COLOR = false;
end
P = [];
W = [];
% for y = size(D,1):-1:1 % in order to correspond to other image origin
%     for x = 1:size(D,2)
for y = randperm(size(D,1))
    for x = randperm(size(D,2))
        if(~COLOR)
            if(D(y,x) >= min_threshold)
                P = [P; [x, y]];
                W = [W; D(y,x)];
            end
        else
             RED = false;
             %              for xx = ceil(x/2)-1:1:ceil(x/2)+1
             %                  for yy = y-1:1:y+1
             %                      if(yy >= 1 && yy <= size(Mask,1) && xx >= 1 && xx <= size(Mask,2))
             %                          if(Mask(yy,ceil(xx/2)))
             %                              RED = true;
             %                          end
             %                      end
             %                  end
             %              end
             if(Mask(y,ceil(x/2)))
                 RED = true;
             end
             if(D(y,x) >= min_threshold && RED)
                P = [P; [x, y]];
                W = [W; D(y,x)];
            end
        end
        %             if(size(P,1) >= 150)
        %                 return;
        %             end
        
    end
end

% if(COLOR)
%    h = figure();
%    imshow(ycbcr2rgb(YUV));
%    hold on;
%    plot(P(:,1)/2, P(:,2), 'o', 'Color', [1 1 1]);
%    waitforbuttonpress;
%    close(h);
% end