function rename_images(dir_name)

prefix = 'image_';
file_names = makeListOfFiles(dir_name, 'jpg');
for f = 1:length(file_names)
    movefile([dir_name '/' file_names{f}], [dir_name '/' prefix num2str(f) '.jpg']);
end