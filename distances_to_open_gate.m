function D = distances_to_open_gate(x, y_l1, y_l2, y_r2, y_r1, s_bar, P)
% distances_to_open_gate(x, y_l, y_r, s_l, s_r, s_bar, P)
n_points = size(P, 1);
D = zeros(n_points, 1);

% 1, 2, 3, 4 -> bottom left, top left, top right, top left.
% Q1 = [x-s_bar; y_l-s_l]; Q1_inner = [x; y_l-s_l];
% if(y_l <= y_r)
%     Q2 = [x-2*s_bar; y_l+s_l]; Q2_inner = [x; y_l+s_l];
%     Q3 = [x+s_bar; y_r+s_r]; Q3_inner = [x; y_r+s_r];
% else
%     Q2 = [x-s_bar; y_l+s_l]; Q2_inner = [x; y_l+s_l];
%     Q3 = [x+2*s_bar; y_r+s_r]; Q3_inner = [x; y_r+s_r];
% end
% Q2 = [x-s_bar; y_l+s_l]; Q2_inner = [x; y_l+s_l];
% Q3 = [x+s_bar; y_r+s_r]; Q3_inner = [x; y_r+s_r];
% Q4 = [x+s_bar; y_r-s_r]; Q4_inner = [x; y_r-s_r];
% if (Q1_inner(2) < Q4_inner(2))
%     Q_low = Q1_inner;
%     Q_high = Q3_inner;
% else
%     Q_low = Q4_inner;
%     Q_high = Q2_inner;
% end
 
% 1, 2 -> lower, upper; l, r -> left, right
Q1 = [x-s_bar; y_l1]; Q1_inner = [x; y_l1];
Q2 = [x-s_bar; y_l2]; Q2_inner = [x; y_l2];
Q3 = [x+s_bar; y_r2]; Q3_inner = [x; y_r2];
Q4 = [x+s_bar; y_r1]; Q4_inner = [x; y_r1];
if(y_l1 < y_r1)
    Q_low = Q1;
    Q_high = Q3;
else
    Q_low = Q4;
    Q_high = Q2;
end

for p = 1:n_points
    Point = P(p, :)';
    dists = zeros(5, 1);
    [dists(1), ~, ~] = distance_to_segment(Q1, Q1_inner, Point);
    [dists(2), ~, ~] = distance_to_segment(Q2, Q2_inner, Point);
    [dists(3), ~, ~] = distance_to_segment(Q3, Q3_inner, Point);
    [dists(4), ~, ~] = distance_to_segment(Q4, Q4_inner, Point);
    [dists(5), ~, ~] = distance_to_segment(Q_low, Q_high, Point);
    D(p) = min(dists);
end