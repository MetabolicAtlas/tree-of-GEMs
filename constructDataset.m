clc,clear
if isfile('dataset.mat')==0
dataset(100).connections(2).parentPMID=[];
dataset(100).connections(2).connectionType=[];
dataset(100).connections(2).citation=[];
dataset(100).connections(2).citationLink=[];
dataset(100).connections(2).notes=[];
dataset(100).articleInformation.childPMID=[];
dataset(100).articleInformation.doi=[];
dataset(100).articleInformation.taxCommon=[];
dataset(100).articleInformation.taxSci=[];
dataset(100).articleInformation.taxID=[];
dataset(100).misc.time=[];
dataset(100).misc.status=[];
initials={'GS' 'EB' 'LW' 'KL' 'JY' 'YL'};
for i=6:-1:1
    temp=initials{i};
    dataset(1).misc.(temp)=[];
end
save('dataset.mat','dataset')
end