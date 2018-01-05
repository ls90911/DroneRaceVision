function [X0, Y0, Z0, psi0] = get_initial_direct_hypothesis(x, y, s)
% function [X0, Y0, Z0, psi0] = get_initial_direct_hypothesis(x, y, s)

% parameters:
half_gate_size = 0.5;
W = 640; % width image in pixels
H = 480;
FOV_w = (60/180)*pi; % FOV in rad - also change in translate_direct_genome_to_image_coords.m
FOV_h = (50/180)*pi; % FOV in rad
dist_at_which_gate_fills_screen = half_gate_size / tan(FOV_w/2);
f = dist_at_which_gate_fills_screen *((W/2) / half_gate_size);

SIMPLE = false;
if(SIMPLE)
    alpha = (s / W) * FOV_w;
    distance = half_gate_size / tan(alpha);
    BX = distance;
    BY = 0;
    BZ = 0;
else
    % determine a rough distance / angle / etc. in body coords
    alpha = (s / W) * FOV_w;
    distance = half_gate_size / tan(alpha);
    angle_to_gate = ((x - W/2) / W) * FOV_w;
    BY = -distance * sin(angle_to_gate);
    BX = distance * cos(angle_to_gate);
    angle_to_gate = -((y - H/2) / H) * FOV_h; % the - is because y is positive down in MATLAB
    BZ = distance * sin(angle_to_gate);
end
% initial parameters for the drone's coordinates when the gate is at
% (0,0,0)
X0 = -BX;
Y0 = -BY;
Z0 = -BZ;
psi0 = 0; % we don't know it based on our information

