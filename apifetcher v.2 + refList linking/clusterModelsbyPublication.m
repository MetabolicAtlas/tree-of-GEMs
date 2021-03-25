clc,clear
%Updatable for new data in cura_biomodels_metadata.mat!!!
load('cura_biomodels_metadata.mat');

if isfile('organized_metadata.mat')%Update current .mat
    load('organized_metadata.mat');

for i=length(organized_metadata):-1:1%build linkIndex
    if 1==any(strcmpi(organized_metadata(i).access.type,'PMID'))
        pmid_pos=strcmpi(organized_metadata(i).access.type,'PMID');
        vals={organized_metadata(i).access.value};
        pmid=char(vals(pmid_pos));
        linkIndex{i}=['http://identifiers.org/pubmed/' pmid];
    elseif any(strcmp(organized_metadata(i).access.type,'link'))
        link_pos=strcmp(organized_metadata(i).access.type,'link');
        vals={organized_metadata(i).access.value};
        link=char(vals(link_pos));
        linkIndex{i}=link;
    end
end
linkIndex=linkIndex';
s=length(organized_metadata);
else%Create new .mat
    linkIndex={};
    s=0;
    organized_metadata.submissionID=[];
end
for i=2:length(models)
    if any(strcmpi([organized_metadata.submissionID],models(i).submissionId))
        continue%submissonId already exists --> duplicate 
    end
    s=s+1;
    
    %% Clustering
    if 0==isfield(models(i).publication,'link') %'No-link' models
        organized_metadata(s).access.type='null';
        organized_metadata(s).submissionID={models(i).submissionId};
        organized_metadata(s).name=models(i).name;
        continue
        
    elseif 1==any(strcmp(linkIndex,models(i).publication.link))%Is the link identical do another model?
        article_pos=find(strcmp(linkIndex,models(i).publication.link));
        new_sID_pos=length(organized_metadata(article_pos).submissionID)+1;
        organized_metadata(article_pos).submissionID(new_sID_pos)={models(i).submissionId};
        s=s-1;
        continue
        
    else %There is a unique link
        linkIndex{s}=models(i).publication.link;
        organized_metadata(s).name=models(i).publication.title;
    end
    
    %% Link management
    if isempty(regexp(models(i).publication.link,'pubmed','once')) %NonPMID models
        organized_metadata(s).access.type='link';
        organized_metadata(s).access.value=models(i).publication.link;
        organized_metadata(s).submissionID={models(i).submissionId};
        
    else
        organized_metadata(s).access.type='PMID';
        identifier_pos=regexp(models(i).publication.link,'pubmed','once');
        pos=identifier_pos+length('pubmed/');
        PMID=models(i).publication.link(pos:end);
        organized_metadata(s).access.value=PMID;
        organized_metadata(s).submissionID={models(i).submissionId};
    end
    
end
save('organized_metadata.mat','organized_metadata')