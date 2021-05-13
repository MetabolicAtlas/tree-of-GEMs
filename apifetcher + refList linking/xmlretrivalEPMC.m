clc,clear;
%% API adresses of EPMC, PUBMED, load data
api_idconvEPMC=['https://www.ebi.ac.uk/europepmc/webservices/rest/search?'...
    'resultType=idlist&cursorMark=*&pageSize=25&format=json&query=ext_id:'];
api_EPMC_XML='https://www.ebi.ac.uk/europepmc/webservices/rest/';
api_EPMCcap='/fullTextXML';
load('organized_metadata.mat')
if 0==isfield(organized_metadata,'file')
    organized_metadata(1).file=[];
end
%% Get EPMC fulltextID
%Options for EPMC fulltextID
options=weboptions('Timeout',1e5);
for i=1:length(organized_metadata)
    if 0==strcmp(organized_metadata(i).access.type,'PMID')
        %Skip non-pubmed
    elseif 1==isfield(organized_metadata(i).file,'source')
        %Skip already assigned
    else
        url=[api_idconvEPMC organized_metadata(i).access.value];%Check EPMC for corresponding fulltextID
        queryresult=webread(url,options);
        if 1==isfield(queryresult.resultList.result,'fullTextIdList')
            organized_metadata(i).file.source='EPMC';
            organized_metadata(i).file.type='xml';
            organized_metadata(i).file.name=char(queryresult.resultList.result.fullTextIdList.fullTextId);
        end
    end 
end
%% Download xml:s from EPMC
options=weboptions('Timeout',1e2,'ContentType','xmldom');%Note that content type is specified
for i=1:length(organized_metadata)
    if 0==isfield(organized_metadata(i).file,'source')
        %Skip TBA
    elseif 0==strcmp(organized_metadata(i).file.source,'EPMC')
        %Skip non-epmc
    else
        try
            url=[api_EPMC_XML organized_metadata(i).file.name api_EPMCcap];
            fname=[organized_metadata(i).file.name '.' organized_metadata(i).file.type];
            if 0==isfile(fname)%If file does not exist
                queryresult=webread(url,options);
                xmlwrite(fname,queryresult);
            end
        catch
            organized_metadata(i).file=[];
        end
    end
end
%% Save
save('organized_metadata.mat','organized_metadata')