function evolveWindow(Response, RGB, x0, y0)
% function evolveWindow(Response, RGB, x0, y0)
%
% Evolves the parameters of a center surround feature in order to best
% capture the window.

Reponse = Response ./ max(Response(:));
W = size(Response,2); H = size(Response,1);
II = getIntegralImage(Response);

% objective functions:
% 1) minimize window response
% 2) maximize size
% 3) symmetric border response
% 4) ratio quantity of red
P = [0.7, 0.15, 0.15, 0];
cP = cumsum(P) ./ sum(P);
fit_winners = [1 0 0 0];

% genome: 
% [x, y, feature_size, border_ratio]
genome_length = 4;


% genetic algorithm:
n_individuals = 30;
n_generations = 50;
std_dev_mutation = 0.02;

% A) Initialization
Population = rand(n_individuals, genome_length);
Population(:,4) = Population(:,4) ./ 5;
% set genomes to feasible values:
correctPopulation(Population);


% potentially fix some genomes:
PreMask = ones(n_individuals, genome_length);
if(exist('x0', 'var') && ~isempty(x0))
    Population(:, 1) = x0 / W;
    PreMask(:,1) = 0;
end
if(exist('y0', 'var') && ~isempty(y0))
    Population(:, 2) = y0 / H;
    PreMask(:,2) = 0;
end

% B) Evolution
figure();
winners = zeros(1, genome_length);

for gen = 1:n_generations
    % i) evaluation:
    resps = zeros(n_individuals, 1);
    symm_resps = zeros(n_individuals, 1);
    sizes = zeros(n_individuals, 1);
    ratios_red = zeros(n_individuals, 1);
    for ind = 1:n_individuals
        feature_size = round(Population(ind,3) * (0.9 * H));
        x = max([round(Population(ind,1) * W), 1]);
        x = min([x, W-feature_size]);
        y = max([round(Population(ind,2) * H), 1]);
        y = min([y, H-feature_size]);
        border_ratio = Population(ind,4);
        resps(ind) = getWindowResponse(x, y, feature_size, border_ratio, II);
        symm_resps(ind) = getBorderResponse(x, y, feature_size, border_ratio, II);
        sizes(ind) = feature_size;
        ratios_red(ind) = getAreaResponse(x, y, feature_size, II);
    end

    
    % ii) selection
    P_new = Population;
    t_size = 5;
    
    % Elitism
    
    [v1,i1] = min(resps);
    Resps(gen) = v1;
    if(v1 < fit_winners(1))
        winners(1, :) = Population(i1,:);
        fit_winners(1) = v1;
    end
    if(P(1) > 0)
        P_new(1,:) = Population(i1,:);
    end
    
    [v2, i2] = max(sizes);
    Sizes(gen) = v2;
    winners(2, :) = Population(i2,:);
    fit_winners(2) = v2;
    if(P(2) > 0)
        P_new(2,:) = Population(i2,:);
    end
    
    [v3, i3] = max(symm_resps);
    SymmResps(gen) = v3;
    if(v3 > fit_winners(3))
        winners(3, :) = Population(i3,:);
        fit_winners(3) = v3;
    end
    if(P(3) > 0)
        P_new(3,:) = Population(i3,:);
    end
    
    [v4, i4] = max(ratios_red);
    RatiosRed(gen) = v4;
    if(v4 > fit_winners(4))
        winners(4, :) = Population(i4,:);
        fit_winners(4) = v4;
    end
    if(P(4) > 0)
        P_new(4,:) = Population(i4,:);
    end
    
    % plot(1:gen, Resps, 1:gen, Sizes);
    subplot(2,2,1);
    plot(1:gen, Resps);
    subplot(2,2,2);
    plot(1:gen, Sizes);
    subplot(2,2,3);
    plot(1:gen, SymmResps);
    subplot(2,2,4);
    plot(1:gen, RatiosRed);
    
    if(gen < n_generations)
        for ind = 4:n_individuals
            
            % tournament selection
            tournament_inds = randperm(n_individuals);
            tournament_inds = tournament_inds(1:t_size);
            
            MULIT_FIT = true;
            if(MULIT_FIT)
                % choose fitness function
                r = rand(1);
                for ff = 1:length(cP)
                    if r < cP(ff)
                        % fprintf('ind %d\n', ind);
                        if(ff == 1)
                            % fprintf('WINDOW\n');
                            % window response
                            [v,i] = min(resps(tournament_inds));
                            P_new(ind,:) = Population(tournament_inds(i),:);
                            break;
                        elseif(ff == 2)
                            % fprintf('SIZE\n');
                            % size
                            [v,i] = max(sizes(tournament_inds));
                            P_new(ind,:) = Population(tournament_inds(i),:);
                            break;
                        elseif(ff == 3)
                            % fprintf('SYMMETRY\n');
                            % window response
                            [v,i] = max(symm_resps(tournament_inds));
                            P_new(ind,:) = Population(tournament_inds(i),:);
                            break;
                        else
                            [v,i] = max(ratios_red(tournament_inds));
                            P_new(ind,:) = Population(tournament_inds(i),:);
                            break;
                        end
                    end
                end
            else
                fits = -P(1) * resps(tournament_inds) + P(2) * sizes(tournament_inds) ./ H + P(3) * symm_resps(tournament_inds);
                [v,i] = max(fits);
                P_new(ind,:) = Population(tournament_inds(i),:);
            end
        end
        
        % iii) Mutation
        p_mut = 0.25;
        Mask = rand(n_individuals, genome_length) < p_mut;
        Mask = Mask & PreMask;
        P_new = P_new + Mask .* (std_dev_mutation * (2 * randn(n_individuals, genome_length) - 1));
        P_new = correctPopulation(P_new);
    
        % set the population to this value
        Population = P_new;
    end
end

h=figure();
imshow(RGB);
hold on;
Colors = {'red', 'green', 'blue', 'magenta'};
for ff = 1:4
    winner = winners(ff,:);
    feature_size = round(winner(1,3) * (0.9 * H));
    x = max([round(winner(1,1) * W), 1]);
    x = min([x, W-feature_size]);
    y = max([round(winner(1,2) * H), 1]);
    y = min([y, H-feature_size]);
    border_ratio = winner(1,4);
    rectangle2(h, x, y, x+feature_size, y+feature_size, Colors{ff});
    if(ff ~= 4)
        border = floor(border_ratio * feature_size); % border = 0 leads to NaN response
        border = max([border, 2]);
        rectangle2(h, x+border, y+border, x+feature_size-border, y+feature_size-border, Colors{ff});
    end
end
winner = P_new(1,:);
feature_size = round(winner(1,3) * (0.9 * H));
x = max([round(winner(1,1) * W), 1]);
x = min([x, W-feature_size]);
y = max([round(winner(1,2) * H), 1]);
y = min([y, H-feature_size]);
border_ratio = winner(1,4);
rectangle2(h, x, y, x+feature_size, y+feature_size, [1 1 1]);
border = floor(border_ratio * feature_size); % border = 0 leads to NaN response
border = max([border, 2]);
rectangle2(h, x+border, y+border, x+feature_size-border, y+feature_size-border, [1 1 1]);
title('Red = response, Green = size, Blue = border, White = last gen best response');

function P = correctPopulation(P)
% function correctPopulation(P)
n_inds = size(P,1);
genome_length = size(P,2);
ii = find(P < 0);
P(ii) = 0;
ii = find(P > 1);
P(ii) = 1;

for ind = 1:n_inds
    P(ind, 1) = max([0.1, P(ind, 1)]);
    P(ind, 1) = min([0.9, P(ind, 1)]);
    if(P(ind, 1) + P(ind, 3) > 1)
        P(ind,1) = 1 - P(ind,3);
    end
    P(ind, 2) = max([0.1, P(ind, 2)]);
    P(ind, 2) = min([0.9, P(ind, 2)]);
    if(P(ind, 2) + P(ind, 3) > 1)
        P(ind,2) = 1 - P(ind,3);
    end
    P(ind, 3) = max([0.1, P(ind, 3)]);
    P(ind, 4) = max([0.025, P(ind, 4)]);
end

function sum_disparities = getSumDisparity(min_x, min_y, max_x, max_y, II)
w = max_x - min_x + 1;
h = max_y - min_y + 1;
sum_disparities = II(min_y, min_x) +  II(max_y, max_x) - II(min_y, max_x) - II(max_y, min_x);

function resp = getAreaResponse(x, y, feature_size, II)
whole_area = getSumDisparity(x, y, x+feature_size, y+feature_size, II);
px_area = feature_size * feature_size;
all = II(end, end);
px_all = size(II,1) * size(II, 2);
resp = (whole_area / all) * (px_all / px_area);

function resp = getBorderResponse(x, y, feature_size, border_ratio, II)
border = floor(border_ratio * feature_size); % border = 0 leads to NaN response
border = max([border, 2]);
window_size = feature_size - 2*border;
% outer areas:
left_area = getSumDisparity(x, y+border, x+border, y+border+window_size, II);
right_area = getSumDisparity(x+border+window_size, y+border, x+2*border+window_size, y+border+window_size, II);
up_area = getSumDisparity(x+border, y, x+border+window_size, y+border, II);
down_area = getSumDisparity(x+border, y+border+window_size, x+border+window_size, y+2*border+window_size, II);
px_outer = border * window_size;
resp = 1 - abs((left_area + right_area) / 2 - (up_area + down_area) / 2) / (left_area + right_area + up_area + down_area); % higher = better
resp = resp + (left_area + right_area + up_area + down_area) / (4 * px_outer);
resp = resp / 2;

function resp = getWindowResponse(x, y, feature_size, border_ratio, II)
% function resp = getWindowResponse(x, y, feature_size, border_ratio, II, Response)
% fprintf('x %f, y %f, feature_size %f, border_ratio %f\n', x, y, feature_size, border_ratio);
border = floor(border_ratio * feature_size); % border = 0 leads to NaN response
border = max([border, 2]);
whole_area = getSumDisparity(x, y, x+feature_size, y+feature_size, II);
px_whole = feature_size * feature_size;
inner_area = getSumDisparity(x+border, y+border, x+feature_size-border, y+feature_size-border, II);
px_inner = feature_size-2*border;
px_inner = px_inner * px_inner;
px_border = px_whole - px_inner;
resp = (inner_area/px_inner) - ((whole_area - inner_area) / px_border );
% if((whole_area - inner_area) / px_border < 1)
%     resp = 1;
% else
%     resp = (inner_area/px_inner) / ((whole_area - inner_area) / px_border );
% end

