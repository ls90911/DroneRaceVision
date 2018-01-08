function [y_low, y_high] = snake_up_and_down(x, y, Response)
% function [y_low, y_high] = snake_up_and_down(x, y, Response)

x_initial = round(x);

y_low = round(y);
done = false;

% search downward
while(y_low > 1 && ~done)
    % check x:
    x = max([x, 2]);
    x = min([size(Response, 2)-1, x]);

    if(Response(y_low-1,x) > 0)
        y_low = y_low - 1;
    elseif(Response(y_low-1,x+1) > 0)
        x = x + 1;
        y_low = y_low - 1;
    elseif(Response(y_low-1,x-1) > 0)
        x = x - 1;
        y_low = y_low - 1;
    else
        done = true;
    end
end
x = x_initial;
y_high = y;
done = false;
while(y_high < size(Response,1) && ~done)
    
    % check x:
    x = max([x, 2]);
    x = min([size(Response, 2)-1, x]);

    
    if(Response(y_high+1,x) > 0)
        y_high = y_high + 1;
    elseif(x<size(Response,2)&&Response(y_high+1,x+1) > 0)
        y_high = y_high + 1;
        x = x + 1;
    elseif(x>1&&Response(y_high+1,x-1) > 0)
        y_high = y_high + 1;
        x = x - 1;
    else
        done = true;
    end
end
