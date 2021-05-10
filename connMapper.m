clc,clear
%% Setup
if isfile('dataset.mat')==0
    json_packer % Unpack json if not unpacked
end
load('dataset.mat') % Load data
json_packer
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
            if ~any(cellfun(@any,connMatrix(i,:)))
                temp = length(dataset);
                dataset(temp+1).articleInformation.PMID = dataset(i).connection(j).PMID;
                connMatrix{i,temp+1} = dataset(i).connection(j).connType;
            end
        end
    end
end
numParents = length(dataset);
%% Graph Plot
map = digraph; % Initiate variable
map = addnode(map,numParents); % Add empty nodes

for i=numModels:-1:1
    if isfield(dataset(i).articleInformation,'model') && ~isempty(dataset(i).articleInformation.model)
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
    for n = 1:numParents % and parent
        if ~isempty(connMatrix{m,n}) % if a child-parent have a connection
            map = addedge(map,n,m); % add that edge to the graph.
        end
    end
end
% sh1= subplot(1,3,1);
fig = plot(map,'Layout','layered');
%Same but label edge
for m = 1:numModels
    for n = 1:numParents
        if ~isempty(connMatrix{m,n})
            labeledge(fig,n,m,connMatrix{m,n})
        end
    end
end
for i = length(fig.EdgeLabel):-1:1
    if strcmp(fig.EdgeLabel(i),'Direct')
        edgeColor(i,:) = [.0 .3 .0];
    else
        edgeColor(i,:) = [.8 .4 .2];
    end
end
% labelnode(fig,1:numModels,names) % Nod namn
fig.NodeColor(numModels+1:numParents,:) = [.6 .47 0].*ones(numParents-numModels,1);
fig.NodeColor(1:numModels,:) = [0 .47 .6].*ones(numModels,1);
fig.EdgeLabel = {};
fig.EdgeColor = edgeColor;
for i = 1:numModels
    if ischar(dataset(i).articleInformation.year)
        temp = -str2num(dataset(i).articleInformation.year);
    else
        temp = -dataset(i).articleInformation.year;
    end
    years(i) = temp;
    %     fig.YData(i) = temp; %År stratifierning
end
%% Models per year
sh2 = subplot(1,2,1);
figHis = histogram(-years);
temp = yticklabels;
for i = 1:length(yticklabels)
    temp{i} = num2str(-str2double(temp{i}));
end
% yticklabels(temp);
% ylim([-2024.5 -1996.5]) % not resilient
ylim([0 25])
title('Modeller per år','FontSize',20)
ylabel('Modellantal','FontSize',20)
xlabel('År','FontSize',20)
%% Connections per year
sh3 = subplot(1,2,2);
yearsConn = [];
for i = 1:numModels
    if ischar(dataset(i).articleInformation.year)
        temp = -str2num(dataset(i).articleInformation.year);
    else
        temp = -dataset(i).articleInformation.year;
    end
    for j = 1:length(dataset(i).connection)
        yearsConn(end+1) = temp;
    end
end
figHis2 = histogram(-yearsConn);
% yticks([]);
% yticklabels([]);
% ylim([-2024.5 -1996.5]) % not resilient
ylim([0 25])
title('Återanvändningar per år','FontSize',20)
ylabel('Antal återanvändningar','FontSize',20)
xlabel('År','FontSize',20)
%% Export to SIF
for n = 1:numParents
    hasChild = 0;
    for connType = ["Direct" "Partial"]
        stringChildren = [];
        stringParent = string(n);
        for m = 1:numModels
            if isa(connMatrix{m,n},'double')
            elseif connType == connMatrix{m,n}
                stringChildren = [stringChildren string(m)];
            end
        end
        if ~isempty(stringChildren)
            if hasChild == 1
                connStr(2,1) = strjoin([stringParent connType stringChildren]);
            else
                connStr = strjoin([stringParent connType stringChildren]);
            end
            hasChild = 1;
        elseif hasChild == 0 && connType == "Partial"
            connStr = stringParent;
        end
    end
    if n == 1
        stringArray = connStr;
    else
        stringArray = [stringArray;connStr];
    end
end
YearsForCytoscape = -years';
for i=numModels:-1:1
    if isfield(dataset(i).articleInformation,'model') && ~isempty(dataset(i).articleInformation.model)
        modelName = dataset(i).articleInformation.model;
    else
        modelName = 'NaN';
    end
    if isfield(dataset(i).articleInformation,'taxSciName')
        taxName = dataset(i).articleInformation.taxSciName;
    else
        taxName = 'NaN';
    end
    modelNamesForCytoscape{i,1} = modelName;
    taxNamesForCytoscape{i,1} = taxName;
end
fid = fopen('connMap.sif','wt');
fprintf(fid,'%s\n',stringArray);
fclose(fid);










