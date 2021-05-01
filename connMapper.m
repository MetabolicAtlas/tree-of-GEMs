clc,clear
%% Setup
if isfile('dataset.mat')==0
    json_packer % Unpack json if not unpacked
end
load('dataset.mat') % Load data
%% Create Matrix
numModels = length(dataset);
connMatrix{numModels,numModels} = []; % Preallocate matrix

for i = 1:numModels % For each model
    if ~isempty(dataset(i).connection) % if there are connections in the given model
        for j = 1:length(dataset(i).connection) % for each connection
            for k = 1:numModels % compare its PMID to each model
                if strcmpi(dataset(k).articleInformation.PMID,dataset(i).connection(j).PMID)&&j~=k
                    connMatrix{i,k} = dataset(i).connection(j).connType; % and save each match.
                end
            end
        end
    end
end

json_packer
%% GraphPlot
map = digraph; % Initiate variable
map = addnode(map,numModels); % Add 87 empty nodes

for i=numModels:-1:1
    if isfield(dataset(i).articleInformation,'model')
        modelName = dataset(i).articleInformation.model;
    else
        modelName = 'NaN';
    end
    if isfield(dataset(i).articleInformation,'taxSciName')
        taxName = dataset(i).articleInformation.taxSciName;
    else
        taxName = 'NaN';
    end
    names{i} = [modelName ' ' taxName];
    
end
for m = 1:numModels % For each child
    for n = 1:numModels % and parent
        if ~isempty(connMatrix{m,n}) % if a child-parent have a connection
            map = addedge(map,n,m); % add that edge to the graph.
        end
    end
end
fig = plot(map,'Layout','layered');
%Same but label edge
for m = 1:numModels
    for n = 1:numModels
        if ~isempty(connMatrix{m,n})
            labeledge(fig,n,m,connMatrix{m,n})
        end
    end
end
for i = length(fig.EdgeLabel):-1:1
            if strcmp(fig.EdgeLabel(i),'Direct')
                edgeColor(i,:) = [0 .5 0]
            else
                edgeColor(i,:) = [.2 .4 .8]
            end
end
labelnode(fig,1:numModels,names)
fig.EdgeColor = edgeColor