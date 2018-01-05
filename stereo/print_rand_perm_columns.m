function print_rand_perm_columns(width, height)

ys = randperm(height);
xs = randperm(width);

fprintf(['int ys[' num2str(height) '] = {']);
for i = 1:height-1
    fprintf([num2str(ys(i)) ', ']);
end
fprintf([num2str(ys(end)) '};\n']);

fprintf(['int xs[' num2str(width) '] = {']);
for i = 1:width-1
    fprintf([num2str(xs(i)) ', ']);
end
fprintf([num2str(xs(end)) '};\n']);
