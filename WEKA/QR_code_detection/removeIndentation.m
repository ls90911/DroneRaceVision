function removeIndentation(ind, fid)
% function removeIndentation(ind, fid)
while(ind ~= 0)
    printTabs(ind - 1, fid);
    fprintf(fid, '}\n');
    ind = ind - 1;
end