function visualize_direct_genome(genome, name_fig)
% function visualize_direct_genome(genome, name_fig)

% create the gate:
half_gate_size = 0.5; % in meters
WorldPoints(1,:) = [0, half_gate_size, half_gate_size];
WorldPoints(2,:) = [0, -half_gate_size, half_gate_size];
WorldPoints(3,:) = [0, -half_gate_size, -half_gate_size];
WorldPoints(4,:) = [0, half_gate_size, -half_gate_size];

% plot the gate:
figure();
hold on;
for i = 1:size(WorldPoints,1)
    plot3(WorldPoints(i,1), WorldPoints(i,2), WorldPoints(i,3), 'o', 'MarkerSize', 10, 'Color', 'red');
end

% decode the genome:
X = genome(1);
Y = genome(2);
Z = genome(3);
psi = genome(4);

% plot the drone
l = 1;
dx = cos(psi) * l;
dy = sin(psi) * l;
plot3(X,Y,Z, 'x', 'MarkerSize', 10, 'LineWidth', 2, 'Color', [0 0 0])
plot3([X, X+dx],[Y, Y+dy],[Z Z])
xlabel('X');
ylabel('Y');
zlabel('Z');
axis equal
if(exist('name_fig', 'var') && ~isempty(name_fig))
    title(name_fig);
end