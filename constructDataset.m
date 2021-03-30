clc,clear
if isfile('dataset.mat')==0
dataset(1).connections(2).parentPMID=[];
dataset(1).connections(2).connectionType=[];
dataset(1).connections(2).citation=[];
dataset(1).connections(2).citationLink=[];
dataset(1).connections(2).notes=[];
dataset(1).articleInformation.childPMID=[];
dataset(1).articleInformation.doi=[];
dataset(1).articleInformation.taxCommon=[];
dataset(1).articleInformation.taxSci=[];
dataset(1).articleInformation.taxID=[];
dataset(1).misc.time=[];
dataset(1).misc.status=[];
initials={'GS' 'EB' 'LW' 'KL' 'JY' 'YL'};
for i=6:-1:1
    temp=initials{i};
    dataset(1).misc.(temp)=[];
end
save('dataset.mat','dataset')
end