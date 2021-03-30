function json_packer(i)
%json_packer(1) unpacks to .m and json_packer(2) packs to .json
if i==1  %unpack
    string=fileread('dataset.json')
    dataset=jsondecode(string);
    save('dataset.mat', 'dataset')
    fprintf(['Unpacked', newline])
elseif i==2  %pack
    load('dataset.mat')
    string=jsonendcode(dataset);
    fig=fopen('dataset.json','w');
    fwrite(fig, string);
    fclose(fig);
    fprintf(['Packed', newline])
else
    fprintf(['Choose 1 or 2', newline])
end