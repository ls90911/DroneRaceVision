function [class, uncertainty, n, prob_sky] = classifyTree(fv, nodes, verbose)
% function [class, uncertainty, n, prob_sky] = classifyTree(fv, nodes, verbose)
% class is the class of the feature vector as determined by the tree
% uncertainty is determined by the ratio of classes at the node
% n is the number of the classifying node
% prob_sky is also determined by the ratio of the classes at the node
% verbose: if true, all values and steps are printed

if(~exist('verbose', 'var') || sum(size(verbose)) < 2)
    verbose = false;
elseif(verbose)
    class_names{1} = 'ground';
    class_names{2} = 'sky';
end

classified = false;
n = 1;
while(~classified)
    if(isa(nodes{n}, 'numeric'))
        % the node classifies the current sample:
        class = round(nodes{n}); % class can be 0 or 1
        prob_sky = nodes{n};
        uncertainty = 2 * (0.5 - abs(0.5 - nodes{n})); % nodes{n} contains p(class = 1)
        classified = true;
        if(verbose)
            fprintf('Classified as %s with uncertainty %f\n', class_names{class+1}, uncertainty);
        end
    else
        % the node performs a check on an attribute value:
        attribute_value = fv(nodes{n}.attribute_no);
        if(verbose)
            fprintf(['Node: ' nodes{n}.attribute ' <= ' num2str(nodes{n}.threshold)]);
            fprintf(': attribute_value = %f\n', attribute_value);
        end
        if(attribute_value <= nodes{n}.threshold)
            n = nodes{n}.child_no(1);
        else
            n = nodes{n}.child_no(2);
        end
    end
end
