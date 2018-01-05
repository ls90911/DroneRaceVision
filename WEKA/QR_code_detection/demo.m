% demo:
filename = 'QR_J48_text.dat';
n_classes = 26;
classes = get_QR_WEKA_Classes(n_classes);
attributes = get_QR_WEKA_Attributes();
tree = readTree(filename, attributes, classes);
C_filename = 'QR_J48_tree.c';
name_tree = 'QR_J48';
saveTree(tree, C_filename, name_tree, attributes, classes);