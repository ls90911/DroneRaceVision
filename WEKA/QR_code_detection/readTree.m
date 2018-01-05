function nodes = readTree(filename, attributes, classes)
% function nodes = readTree(filename, attributes, classes)
%
% Reads trees copy-pasted from WEKA (J48)

% open the file:
fid = fopen(filename);
reading = true;
current_depth = 0;
n = 0;
c_n = 0;
while(reading)
    % read the next line
    tline = fgetl(fid);
    if(tline ~= -1)
       % there is still a line to be read
       
       % determine attribute:
       att_index = 1;
       name_length_att = 0;
       for a = 1:length(attributes)
           str_index = findstr([attributes{a}.name ' '], tline);
           if(sum(size(str_index)) > 1 && length(attributes{a}.name) > name_length_att)
               att_index = a;
               depth = ((str_index - 1) / 4) + 1; % the position in the line is determined by the depth in the tree
               name_length_att = length(attributes{a}.name);
           end
       end
       if(name_length_att == 0)
           error('Attribute does not exist: %s\n', tline);
       end

       % if depth > current_depth, a node has to be made
       % if depth <= current_depth, no new child has to be made, but we need to go to the
       % indicated depth (trace the parents back to
       % that depth) and augment the child number, change the corresponding info (if classification). 
       % : EXCEPTION : nominal attributes
       if(depth > current_depth)
           n = n + 1; % new node
           
           % make new node:
           node.attribute = attributes{att_index}.name;
           node.attribute_no = att_index;
           node.type = attributes{att_index}.type;
           node.depth = depth;
           node.child_no = [];
           node.leaf = false; % standard assumption is not to be a leaf
           if(depth > 1)
               % attach the node to its parent:
               nodes{c_n}.child_no = [nodes{c_n}.child_no n];
               node.parent = c_n;
           end
           % change the current node:
           c_n = n;
           nodes{c_n} = node;
           current_depth = depth;
       else
           while(nodes{c_n}.depth ~= depth)
               c_n = nodes{c_n}.parent;
           end
           current_depth = nodes{c_n}.depth;
       end
       
       % : indicates a classification:
       st = findstr(':', tline);
       if(sum(size(st)) >= 2)
           for i = 1:length(classes)
               % TODO: if classes are simple numbers, this gives problems:
               st = findstr(classes{i}, tline);
               
               % if the class name is found:
               if(sum(size(st)) >= 2)
                   % classes{i} is the class of samples associated
                   % to this node: 
                   % make a leaf node child:
                   n = n + 1;                   
                   nodes{c_n}.child_no = [nodes{c_n}.child_no n];
                   nodes{n}.leaf = true;
                   nodes{n}.class = classes{i};
                   
                   % the number of well and badly classified instances is
                   % indicated like this:
                   st_1 = findstr('(', tline);
                   st_2 = findstr('/', tline);
                   st_3 = findstr(')', tline);
                   
                   % if the slash is not there:
                   if(sum(size(st_2)) < 2)
                       % only one class at the leaf:
                       nodes{n}.uncertainty = 0; % all samples at the lead are of the same class
                   else
                       % main class is the one of the classification
                       % sub is all the rest:
                       main_class = eval(tline(st_1+1:st_2-1));
                       sub_class = eval(tline(st_2+1:st_3-1));
                       nodes{n}.uncertainty = sub_class / (main_class + sub_class);
                       break;
                   end
               end
           end
       end

       % For numerical attributes, <= always comes before >
       st = findstr('<=', tline);
       if(sum(size(st)) >= 2)
           % <= occurs in the line
           stt = findstr(':', tline);
           if(sum(size(stt)) < 2)
               nodes{c_n}.threshold = str2num(tline(st+3:size(tline,2)));%min([st+10, ])));
           else
               nodes{c_n}.threshold = str2num(tline(st+3:stt-1));%min([st+10, size(tline,2)])));
           end
       end
    else
        reading = false;
    end
end

fprintf('done\n');