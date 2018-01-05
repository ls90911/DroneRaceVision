function plot_im_coords(im_coords, color)
% function show_im_coords_on_image(im_coords, color)

if(~exist('color', 'var') || isempty(color))
    color = 'red';
end

coords1 = [im_coords; im_coords(1,:)]; %[im_coords; im_coords(1,:)];
plot(coords1(:,1), coords1(:,2), 'Color', color, 'LineWidth', 5);
