function [Histogram, locs, pks] = simple_detector(Response, ROI)
% function [Histogram, locs, pks] = simple_detector(Response, ROI)
% ROI: [x_min x_max y_min y_max]
if(exist('ROI', 'var') && ~isempty(ROI))
    R = Response(ROI(3):ROI(4), ROI(1):ROI(2));
else
    R = Response;
end


EFFICIENT = true;
if(~EFFICIENT)
    Histogram = sum(R);
else
    step = 4;
    Histogram = sum(R(1:step:end, :));
end

% smooth the histograms:
SH = smooth(Histogram, 5);

% find all peaks:
[pks,locs] = findpeaks(SH);
% all peaks at least 50% from the maximum:
[v,i] = sort(pks);
ratios = v / v(end);
inds = find(ratios >= 0.50);
locs = locs(i(inds));
pks = pks(i(inds));
% exclude close peaks:
selected_pks = pks(end);
selected_locs = locs(end);
window_size = 30;
for i = length(pks)-1:-1:1
    ii = find(selected_locs >= locs(i) - 50);
    jj = find(selected_locs <= locs(i) + 50);
    kk = intersect(jj, ii);
    if(isempty(kk))
        selected_pks = [selected_pks, pks(i)];
        selected_locs = [selected_locs, locs(i)];
    end
end
locs = selected_locs;
pks = selected_pks;

% graphics:
figure();
plot(SH); hold on; plot(locs, pks, 'x'); title('Poles');

% perhaps detect length by taking 5% / 95% of the sum of pixels?