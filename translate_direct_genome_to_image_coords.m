function [im_coords, visible] = translate_direct_genome_to_image_coords(genome)
% function [im_coords, visible] = translate_direct_genome_to_image_coords(genome)
%
% genome = [X,Y,Z,psi] of the drone with respect to the gate which is at [0,0,0]
% four image coordinates are generated for a square gate

graphics = false;

im_coords = [];

half_gate_size = 0.5; % in meters
WorldPoints(1,:) = [0, half_gate_size, half_gate_size];
WorldPoints(2,:) = [0, -half_gate_size, half_gate_size];
WorldPoints(3,:) = [0, -half_gate_size, -half_gate_size];
WorldPoints(4,:) = [0, half_gate_size, -half_gate_size];


if(graphics)
    % plot the gate:
    figure();
    hold on;
    for i = 1:size(WorldPoints,1)
        plot3(WorldPoints(i,1), WorldPoints(i,2), WorldPoints(i,3), 'o', 'MarkerSize', 10, 'Color', 'red');
    end
end
% decode the genome:
X = genome(1);
Y = genome(2);
Z = genome(3);
psi = genome(4);

if(graphics)
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
end

% vectors to the gate world points in the camera (drone) frame:
DWP = zeros(4,3);
rotation_angle = -psi;
R = [cos(rotation_angle), -sin(rotation_angle), 0;
     sin(rotation_angle), cos(rotation_angle), 0;
     0, 0, 1];

 for i = 1:4
    % get the vector with respect to the drone's position:
    DWP(i,:) = [WorldPoints(i,1)-X, WorldPoints(i,2)-Y, WorldPoints(i,3)-Z];
    % rotate the vector with - psi so that it will be in the body frame:
    BP(i,:) = (R * DWP(i,:)')';
    if(graphics)
        fprintf('Norms: %f, %f\n', norm(DWP(i,:)), norm(BP(i,:)));
    end
end
if(graphics)
    figure();
    hold on;
    for i = 1:size(BP,1)
        plot3(BP(i,1), BP(i,2), BP(i,3), 'o', 'MarkerSize', 10, 'Color', 'red');
    end
    plot3(0,0,0, 'x', 'MarkerSize', 10, 'LineWidth', 2, 'Color', [0 0 0])
    plot3([0, l],[0, 0],[0 0])
    xlabel('BX');
    ylabel('BY');
    zlabel('BZ');
    axis equal
end
% Project the body coordinate points back into the frame:
im_coords = zeros(4,2);
visible = ones(4,1);

% we need the focal length in pixels, and get it by looking at what distance the gate fills the image: 
W = 640; % width image in pixels
H = 480;
FOV = (60/180)*pi; % FOV in rad
half_gate = 0.5;
% tan(FOV/2) = half_gate / dist_at_which_gate_fills_screen
dist_at_which_gate_fills_screen = half_gate / tan(FOV/2);
f = dist_at_which_gate_fills_screen *((W/2) / half_gate_size);

if(graphics)
    figure(); hold on;
end
for i = 1:size(BP,1)
    if(BP(i,1) < 0)
        visible(i) = 0;
    else
        x_pre = f * (BP(i,2) / BP(i,1));
        y_pre = f * (BP(i,3) / BP(i,1));
        im_coords(i,1) = W/2 - x_pre;
        % im_coords(i,2) = H/2 + y_pre; % y up in image
        im_coords(i,2) = H/2 - y_pre; % y down in image
        if(graphics)
            plot(im_coords(i,1), im_coords(i,2), 'o', 'Color', 'red');
        end
    end
end
if(graphics)
    xlabel('x');
    ylabel('y');
end