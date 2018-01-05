function plot_arms(genome, color, x, y)
% function plot_arms(genome, color, x, y)

if(~exist('color', 'var') || isempty(color))
    color = 'red';
end

angle(1) = genome(1);
angle(2) = genome(2);

length_arm = 150; % in pixels
Q1 = [x;y];
Q2 = Q1 + length_arm * [cos(angle(1)); sin(angle(1))];
Q3 = Q1 + length_arm * [cos(angle(2)); sin(angle(2))];

plot([Q1(1) Q2(1)], [Q1(2) Q2(2)], 'Color', color, 'LineWidth', 2);
hold on;
plot([Q1(1) Q3(1)], [Q1(2) Q3(2)], 'Color', color, 'LineWidth', 2);