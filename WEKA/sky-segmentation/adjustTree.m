function nodes = adjustTree(nodes, m_adjust_tree, std_info, adjust_tree_direction)
% function nodes = adjustTree(nodes, m_adjust_tree, std_info, adjust_tree_direction)

n_nodes = length(nodes);
for nd = 1:n_nodes
    if(~isa(nodes{1, nd}, 'numeric'))
        ind1 = searchStdAtt(nodes{1, nd}.attribute, std_info{2,1}, true);
        ind2 = searchStdAtt(nodes{1, nd}.attribute, adjust_tree_direction(:,1), false);
        if(ind1 ~= -1 && ind2 ~= -1)
            nodes{1, nd}.threshold = nodes{1, nd}.threshold + m_adjust_tree * std_info{1,1}(ind1) * adjust_tree_direction{ind2,2};
        end
    end
end

