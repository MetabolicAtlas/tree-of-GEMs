clc,clear
if isfile('dataset.mat')==0
    json_packer
end
load('dataset.mat')
numModels = length(dataset);
connMatrix = zeros(numModels,numModels);
for i = 1:numModels
    if ~isempty(dataset(i).connection)
        for j = 1:length(dataset(i).connection)
            for k = 1:numModels
                if strcmpi(dataset(k).articleInformation.PMID,dataset(i).connection(j).PMID)&&j~=k
                    connMatrix(i,k) = 1;
                end
            end
        end
    end
end
json_packer