function [angle_1, angle_2] = fit_clock_arms(params, x, y)
% function [angle_1, angle_2] = fit_clock_arms(params, x, y)

graphics = true;

genome_length = 2;

DISTANCE_FIT = 1;
COLOR_FIT = 2;
fit_func = DISTANCE_FIT;

n_individuals = 30;
Population = rand(n_individuals, genome_length) * 2 * pi;
n_generations = 30;
best_fit = 1000000000;
best_genome = Population(1, :);
for g = 1:n_generations
    for i = 1:n_individuals
        if(fit_func == COLOR_FIT)
            %fits(i) = 1-get_color_fitness(Population(i, :), Response, STICK, shape);
        else
            fits(i) = mean_distance_to_arms(Population(i, :), params, x, y);
        end
    end
    [v, ind] = min(fits);
    fprintf('Gen: %d, fit %f\n', g, v);
    if(v < best_fit)
        best_genome = Population(ind, :);
        best_fit = v;
    end
    if(g < n_generations)
        Population = repmat(Population(ind, :), [n_individuals, 1]);
        Mutation = 2 * pi * rand(n_individuals, genome_length) - pi;
        Population = Population + Mutation;
    end
end

angle_1 = best_genome(1);
angle_2 = best_genome(2);


if(graphics)
    h = figure();
    plot(params(:,1), params(:,2), 'x');
    hold on;
    plot_arms([angle_1, angle_2], 'red', x, y);
    waitforbuttonpress;
    close(h);
end