clc,clear
load('organized_metadata.mat')
for i=1:length(organized_metadata)
    organized_metadata(i).refListInDataset=[];%Program is quick enough for it to be easier to remove the field each time
end
for i=1:length(organized_metadata)
    if isfield(organized_metadata(i).refList,'type')...
            &&any(strcmpi({organized_metadata(i).refList.type},'pmid'))%For every refList with PMIDs
        pmid_pos=strcmpi({organized_metadata(i).refList.type},'pmid');
        pmidRefs=string(organized_metadata(i).refList(pmid_pos).value);%Extract the PMIDs
        s=0;%Used as counter for refListInDataset
        for j=1:length(organized_metadata)%For every model in the dataset
            if isfield(organized_metadata(j).access,'type')...
                    &&any(strcmpi(organized_metadata(j).access.type,'pmid'))%If they have a PMID
                pmid_pos=strcmpi(organized_metadata(j).access.type,'pmid');
                pmidMatch=organized_metadata(j).access(pmid_pos).value;%Extract it...
                nameMatch=organized_metadata(j).name;%...and its name...
                nameMatch=organized_metadata(j).name;%...and the authors.
                if any(strcmpi(pmidRefs,pmidMatch))%Check if refList includes the models PMID
                    s=s+1;%Assign to next place in refListInDataset
                    organized_metadata(i).refListInDataset(s).pmid=pmidMatch;%If so, add that information
                    organized_metadata(i).refListInDataset(s).name=nameMatch;
                end
            end
        end
    end
end
save('organized_metadata.mat');
