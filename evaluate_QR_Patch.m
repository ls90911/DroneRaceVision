function [is_QR, QR_nr] = evaluate_QR_Patch(Patch)
% function [is_QR, QR_nr] = evaluate_QR_Patch(Patch)
% 
% 2 steps: 
% run a J48 tree for detection
% if it is a QR code, run a J48 tree for code recognition

% detection is not working well yet:
% [is_QR, Uncertainty] = predict_QR_code_detection_image([], Patch);
is_QR = true;
if(is_QR)
    [QR_nr, Uncertainty] = predict_QR_code_image([], Patch);
else
    QR_nr = [];
end