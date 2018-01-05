function circle(x,y,r, color, linewidth)
%x and y are the coordinates of the center of the circle
%r is the radius of the circle
%0.01 is the angle step, bigger values will draw the circle faster but
%you might notice imperfections (not very smooth)

if(~exist('color', 'var') || isempty(color))
    color = 'red';
end
if(~exist('linewidth', 'var') || isempty(linewidth))
    linewidth = 2;
end


ang=0:0.01:2*pi; 
xp=r*cos(ang);
yp=r*sin(ang);
plot(x+xp,y+yp, 'Color', color, 'LineWidth', linewidth);
end