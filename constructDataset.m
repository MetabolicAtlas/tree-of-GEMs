clc,clear
%Updatable for new data in cura_biomodels_metadata.mat!!!
load('cura_biomodels_metadata.mat');
%% Link Indexing
if isfile('dataset.json')%Update current .mat
    json_packer
    load('dataset.mat');

for i=length(dataset):-1:1 %build linkIndex
    if 1==isnumeric(dataset(i).articleInformation.PMID) %PMIDs are wholly numeric
        pmid=char(dataset(i).articleInformation.PMID);
        linkIndex{i}=['http://identifiers.org/pubmed/' pmid];
    elseif 0==isempty(dataset(i).articleInformation.PMID)
        link=char(dataset(i).articleInformation.PMID);
        linkIndex{i}=link;
    end
end
linkIndex=linkIndex'; %Matter of taste
s=length(dataset); %Make sure the for loop assigns new children starting at empty spaces

else%Create new .mat
    linkIndex={};
    s=0;
    dataset.submissionID=[];
end

%% Clustering
existingSid = [];
for i=1:length(dataset)
    existingSid = [existingSid dataset(i).submissionID'];
end

for i=2:length(models)
    
    %% Check for duplicates
    if any(strcmpi(existingSid,models(i).submissionId)) % Check duplicates
        continue%submissonId already exists --> ignore duplicate
    end
    
    s=s+1; % Work at the next empty space in dataset
    
    if 0==isfield(models(i).publication,'link') %'No-publication' models
        dataset(s).articleInformation.PMID='unknown';
        dataset(s).submissionID={models(i).submissionId};
        existingSid = [existingSid {models(i).submissionId}];
        dataset(s).title=models(i).name;
        continue
        
    elseif 1==any(strcmp(linkIndex,models(i).publication.link))%Is the link identical do another model?
        article_pos=find(strcmp(linkIndex,models(i).publication.link)); % Find match position
        new_sID_pos=1+length(dataset(article_pos).submissionID); % New submissionID assigns at end of list
        dataset(article_pos).submissionID(new_sID_pos)={models(i).submissionId};
        existingSid = [existingSid {models(i).submissionId}];
        s=s-1; % Walk back place counter
        continue
        
    else %There is a unique link
        linkIndex{s}=models(i).publication.link;
        dataset(s).title=models(i).publication.title;
    end
    
    %% Link Assignment
    if isempty(regexp(models(i).publication.link,'pubmed','once')) %NonPMID models
        dataset(s).articleInformation.PMID=models(i).publication.link;
        dataset(s).submissionID={models(i).submissionId};
        
    else % Pubmed links are root/pubmed/{PMID}
        identifier_pos=regexp(models(i).publication.link,'pubmed','once'); %Get pos of 'pubmed'
        pos=identifier_pos+length('pubmed/'); %Use it to get pmid pos
        PMID=models(i).publication.link(pos:end);
        dataset(s).articleInformation.PMID=PMID;
        dataset(s).submissionID={models(i).submissionId};
    end
    
end

%% Get DOI and tax info

options=weboptions('Timeout',1e5);
api_idconvPUBMED = 'https://www.ncbi.nlm.nih.gov/pmc/utils/idconv/v1.0/?format=json&ids=';
% TODO taxonomy
%api_tax = 

for i=1:length(dataset)
    check = str2num(dataset(i).articleInformation.PMID);%empty if containing letters 
    if 0==isempty(check) % Only pmid is wholly numeric, returns nonempty
        url = [api_idconvPUBMED char(dataset(i).articleInformation.PMID)];
        queryresult=webread(url,options);
        pause(.34)
        if 1==isfield(queryresult.records,'doi')
            dataset(i).articleInformation.doi = char(queryresult.records.doi);
        end
    end
end

%% End
save('dataset.mat','dataset')
json_packer