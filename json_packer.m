function json_packer
if isfile('dataset.mat') % .mat exist --> pack and delete .mat
    load('dataset.mat')
    string=jsonencode(dataset);
    string = strrep(string, ',"', [',' newline '"']);
    string = strrep(string, ',{', [',' newline '{']); %testing these 3
    string = strrep(string, '[{', ['[' newline '{' newline]);
    string = strrep(string, '}]', ['}' newline ']']);
    fig=fopen('dataset.json','w');
    fwrite(fig, string);
    fclose(fig);
    delete dataset.mat
    fprintf(['Packed', newline])
elseif isfile('dataset.json') % No .mat --> unpack
    string=fileread('dataset.json');
    dataset=jsondecode(string);
    save('dataset.mat', 'dataset');
    fprintf(['Unpacked', newline])
else
    fprintf(['files missing' newline])
end