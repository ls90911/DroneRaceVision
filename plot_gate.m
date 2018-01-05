function plot_gate(genome, color, shape)
% function plot_gate(genome, color)

if(~exist('color', 'var') || isempty(color))
    color = 'red';
end
SQUARE = 1;
CIRCLE = 2;
POLYGON = 3;
if(~exist('shape', 'var') || isempty(shape))
    shape = SQUARE;
end

if(shape == SQUARE)
    x = genome(1);
    y = genome(2);
    s = genome(3);
    
    Q1 = [x-s; y-s];
    Q2 = [x+s; y-s];
    Q3 = [x+s; y+s];
    Q4 = [x-s; y+s];
elseif(shape == POLYGON)
    x = genome(1);
    y = genome(2);
    s_width = genome(3);
    s_left = genome(4);
    s_right = genome(5);
    
    Q1 = [x-s_width; y-s_left];
    Q4 = [x-s_width; y+s_left];
    Q2 = [x+s_width; y-s_right];
    Q3 = [x+s_width; y+s_right];
end

plot([Q1(1) Q2(1)], [Q1(2), Q2(2)], 'Color', color, 'LineWidth', 5);
plot([Q2(1) Q3(1)], [Q2(2), Q3(2)], 'Color', color, 'LineWidth', 5);
plot([Q3(1) Q4(1)], [Q3(2), Q4(2)], 'Color', color, 'LineWidth', 5);
plot([Q4(1) Q1(1)], [Q4(2), Q1(2)], 'Color', color, 'LineWidth', 5);