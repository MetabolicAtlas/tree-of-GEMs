clc,clear
%% Setup
if isfile('dataset.mat')==0
    json_packer % Unpack json if not unpacked
end
load('dataset.mat') % Load data
%% Create Matrix
numModels = length(dataset);
connMatrix = zeros(numModels,numModels); % Preallocate matrix

for i = 1:numModels % For each model
    if ~isempty(dataset(i).connection) % if there are connections in the given model
        for j = 1:length(dataset(i).connection) % for each connection
            for k = 1:numModels % compare its PMID to each model
                if strcmpi(dataset(k).articleInformation.PMID,dataset(i).connection(j).PMID)&&j~=k
                    connMatrix(i,k) = 1; % and save each match.
                end
            end
        end
    end
end

json_packer
%% GraphPlot
map = digraph; % Initiate variable
map = addnode(map,numModels); % Add 87 empty nodes
for m = 1:numModels % For each child
    for n = 1:numModels % and parent
        if 1 == connMatrix(m,n) % if a child-parent have a connection
            map = addedge(map,n,m); % add that edge to the graph.
        end
    end
end
fig = plot(map,'Layout','layered');