function [classes] = get_QR_WEKA_Classes(nr_QR_codes)
% function [classes] = get_QR_WEKA_Classes(nr_QR_codes)
%
% get a cell of class names

for qr = 1:nr_QR_codes
    classes{qr} = ['QR_' num2str(qr)];
end