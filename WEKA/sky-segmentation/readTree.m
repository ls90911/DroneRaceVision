function nodes = readTree(filename, attributes, classes)
% Reads trees copy-pasted from WEKA (J48)

fid = fopen(filename);
reading = true;
current_depth = 0;
n = 0;
c_n = 0;
while(reading)
    tline = fgetl(fid);
    if(tline ~= -1)
       % there is still a line to be read
       
       % determine attribute:
       att_index = 1;
       name_length_att = 0;
       for a = 1:size(attributes,2)
           str_index = findstr([attributes{a}.name ' '], tline);
           if(sum(size(str_index)) > 1 && length(attributes{a}.name) > name_length_att)
               att_index = a;
               depth = ((str_index - 1) / 4) + 1;
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
           for i = 1:size(classes,1)
               st = findstr(classes{i}, tline);
               if(sum(size(st)) >= 2)
                   % classes{i} is the class of samples associated
                   % to this node: 
                   n = n + 1;
                   nodes{c_n}.child_no = [nodes{c_n}.child_no n];
                   st_1 = findstr('(', tline);
                   st_2 = findstr('/', tline);
                   st_3 = findstr(')', tline);
                   if(sum(size(st_2)) < 2)
                       % only one class at the leaf:
                       if(i == 1) nodes{n} = 0;
                       else nodes{n} = 1;
                       end                       
                   else
                       main_class = eval(tline(st_1+1:st_2-1));
                       sub_class = eval(tline(st_2+1:st_3-1));
                       % class 2 is sky and determines the certainty (which can be interpreted as P(sky))
                       if(i == 1) nodes{n} = sub_class / (main_class + sub_class);
                       else nodes{n} = main_class / (main_class + sub_class);
                       end
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
            
           % adjust the tree to get a different point on the ROC-curve:
       end
    else
        reading = false;
    end
end

fprintf('done\n');