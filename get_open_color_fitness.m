function cf = get_open_color_fitness(genome, Response)

x = genome(1);
y_l1 = genome(2);
y_l2 = genome(3);
y_r2 = genome(4);
y_r1 = genome(5);
s_bar = genome(6);

cf = 0;
n_points = 0;

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

[s_cf, p] = check_color_fitness_segment(Q1, Q1_inner, Response);
cf = cf + s_cf;
n_points = n_points + p;
[s_cf, p] = check_color_fitness_segment(Q2, Q2_inner, Response);
cf = cf + s_cf;
n_points = n_points + p;
[s_cf, p] = check_color_fitness_segment(Q3, Q3_inner, Response);
cf = cf + s_cf;
n_points = n_points + p;
[s_cf, p] = check_color_fitness_segment(Q4, Q4_inner, Response);
cf = cf + s_cf;
n_points = n_points + p;
[s_cf, p] = check_color_fitness_segment(Q_low, Q_high, Response);
cf = cf + s_cf;
n_points = n_points + p;

% ratio of colored points:
cf = cf / n_points;

function [s_cf, p] = check_color_fitness_segment(Q1, Q2, Response)
% function [s_cf, p] = check_color_fitness_segment(Q1, Q2, Response)
s_cf = 0;
p = 0;
for t = 0:0.01:1
    xx = round(t*Q1(1) + (1-t)*Q2(1));
    yy = round(t*Q1(2) + (1-t)*Q2(2));
    if(xx >= 1 && xx <= size(Response, 2) && yy >= 1 && yy <= size(Response, 1))
        p = p + 1;
        if(Response(yy,xx) > 0)
            s_cf = s_cf + 1;
        end
    end
end