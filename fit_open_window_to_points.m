% TODO: sub_sampling_open_snake.m get_open_color_fitness.m
function [x, y_l1, y_l2, y_r2, y_r1, s_bar] ...
    = fit_open_window_to_points(points, x0, y01, y02, y03, y04, size0, weigths, Response)
% change input!
n_points = size(points, 1);

if(~exist('weights', 'var') || isempty(weights))
    weights = ones(n_points, 1);
end

DISTANCE_FIT = 1;
COLOR_FIT = 2;
fit_func = DISTANCE_FIT;

genome0 = [x0, y01, y02, y03, y04, size0];

genome_length = length(genome0);
params = points;

EVOLUTION = 1;
GRADIENT = 2;
METHOD = EVOLUTION;

if(METHOD == EVOLUTION)
    n_individuals = 10;
    Population = repmat(genome0, [n_individuals, 1]) +...
        5 * rand(n_individuals, genome_length) - 2.5;
    n_generations = 30;
    best_fit = 1000000000;
    best_genome = Population(1, :);
    for g = 1:n_generations
        for i = 1:n_individuals
            if(fit_func == COLOR_FIT)
                fits(i) = 1 - get_open_color_fitness(Population(i, :), Response);
            else
                fits(i) = mean_distance_to_open_gate(Population(i, :), params);
            end
        end
        [v, ind] = min(fits);
        if(v < best_fit)
            best_genome = Population(ind, :);
            best_fit = v;
        end
        if (g < n_generations)
            Population = repmat(Population(ind, :), [n_individuals, 1]);
            Mutation = 5 * rand(n_individuals, genome_length) - 2.5;
            Population = Population + Mutation;
        end
    end
else
    it = 0;
    dx = 2; dy = 2; ds = 2;
    genome = genome0;
    fit_genome = mean_distance_to_open_gate(genome, params);
    best_genome = genome;
    best_fit = fit_genome;
    norm_limit = 1;
    step_size = 2;
    while(it < floor(300 / 4 /5))
        fprintf('Iteration %d, fitness %f\n', it, fit_genome);
        genome_dx = genome + [dx, 0, 0, 0, 0, 0];
        genome_dy_l1 = genome + [0, dy, 0, 0, 0, 0];
        genome_dy_l2 = genome + [0, 0, dy, 0, 0, 0];
        genome_dy_r2 = genome + [0, 0, 0, dy, 0, 0];
        genome_dy_r1 = genome + [0, 0, 0, 0, dy, 0];
        genome_ds_b = genome + [0, 0, 0, 0, 0, ds];
        if(fit_func == COLOR_FIT)
            fit_dx = 1 - get_open_color_fitness(genome_dx, Response);
            fit_dy_l1 = 1 - get_open_color_fitness(genome_dy_l1, Response);
            fit_dy_l2 = 1 - get_open_color_fitness(genome_dy_l2, Response);
            fit_dy_r2 = 1 - get_open_color_fitness(genome_dy_r2, Response);
            fit_dy_r1 = 1 - get_open_color_fitness(genome_dy_r1, Response);
            fit_ds_b = 1 - get_open_color_fitness(genome_ds_b, Response);
        else
            fit_dx = mean_distance_to_open_gate(genome_dx, params);
            fit_dy_l1 = mean_distance_to_open_gate(genome_dy_l1, params);
            fit_dy_l2 = mean_distance_to_open_gate(genome_dy_l2, params);
            fit_dy_r2 = mean_distance_to_open_gate(genome_dy_r2, params);
            fit_dy_r1 = mean_distance_to_open_gate(genome_dy_r1, params);
            fit_ds_b = mean_distance_to_open_gate(genome_ds_b, params);
        end
        fdx = fit_dx - fit_genome;
        fdyl1 = fit_dy_l1 - fit_genome;
        fdyl2 = fit_dy_l2 - fit_genome;
        fdyr2 = fit_dy_r2 - fit_genome;
        fdyr1 = fit_dy_r1 - fit_genome;
        fdsb = fit_ds_b - fit_genome;
        
        v = [fdx, fdyl1, fdyl2, fdyr2, fdyr1, fdsb];
        if(norm(v) > norm_limit)
            step = -sign(v) * step_size;
            genome = genmoe + step;
            if(fit_func == COLOR_FIT)
                fit_genome = 1 - get_open_color_fitness(genome, Response);
            else
                fit_genome = mean_distance_to_open_gate(genome, params);
            end
        else
            genome = genome + 10 * rand(1, 6) - 5;
        end
        if (fit_genome < best_fit)
            best_genome = genome;
            best_fit = fit_genome;
        end
        it = it + 1;
    end
end

best_fit = best_fit / sum(weigths);
x = best_genome(1);
y_l1 = best_genome(2);
y_l2 = best_genome(3);
y_r2 = best_genome(4);
y_r1 = best_genome(5);
s_bar = best_genome(6);