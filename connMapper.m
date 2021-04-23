clc,clear
if isfile('dataset.mat')==0
    json_packer
end
load('dataset.mat')
connMatrix = [];
for i = 1:length(dataset)
    if ~isempty(dataset(i).connection)
        for j = 1:length(dataset(i).connection)
            for k = 1:length(dataset)
                if strcmpi(dataset(k).articleInformation.PMID,dataset(i).connection(j).PMID)&&j~=k
                    connMatrix(i,k) = 1;
                else
                    connMatrix(i,k) = 0;
                end
            end
        end
    end
end
json_packer