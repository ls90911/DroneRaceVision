function d = mean_distance_to_open_gate(genome, P)

% x = genome(1);
% y_l = genome(2);
% y_r = genome(3);
% s_l = genome(4);
% s_r = genome(5);
% s_bar = genome(6);
% D = distances_to_open_gate(x, y_l, y_r, s_l, s_r, s_bar, P);

x = genome(1);
y_l1 = genome(2);
y_l2 = genome(3);
y_r2 = genome(4);
y_r1 = genome(5);
s_bar = genome(6);
D = distances_to_open_gate(x, y_l1, y_l2, y_r2, y_r1, s_bar, P);

d = mean(D);
