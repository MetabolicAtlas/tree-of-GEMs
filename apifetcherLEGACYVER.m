clc; clear
%% Retrive metadata
if isfile('cura_biomodels_metadata.mat')==0 %Check if data is already generated
    modelIDs={'null'};%define modelIDs for use in loop
    api = 'https://www.ebi.ac.uk/biomodels'; %Base api adress
    %This for-loop queries the api for all modelIDs
    for i=1:10
        url = strjoin([api...These are our requests to the api, appended to the adress
            '/search?'...%Search for:
            'query=*%3A*%20AND%20curationstatus%3A"Manually%20curated"&domain=biomodels'...All manually curated models
            '&numResults=100'...return 100 results (max size)
            '&sort=first_author-desc'...arbitrary sorting
            '&format=json'...return as json
            '&offset='+string((i-1)*100)],'');%we offset to skip previous results
        options=weboptions('Timeout',1e5);%High timeout because of large requests
        queryresult = webread(url,options);%The result of our search
        modelIDs=[modelIDs;{queryresult.models.id}'];%save the IDs of all results
    end
    %This for-loop request a model from our list of modelIDs
    for i=2:length(modelIDs)
        url=[api '/' modelIDs{i} '?format=json'];%Gives modelmetadata
        modeltemp=webread(url);
        %These if statements are just to make all models have similar structs
        if isfield(modeltemp,'publicationId')==0
            modeltemp.('publicationId')=[];
        end
        if isfield(modeltemp,'description')==0
            modeltemp.('description')=[];
        end
        if isfield(modeltemp,'firstPublished')==0
            modeltemp.('firstPublished')=[];
        end
        if isfield(modeltemp,'publication')==0
            modeltemp.('publication')=[];
        end
        models(i)=modeltemp;
    end
    save('cura_biomodels_metadata.mat','models'); %Save the data for next run
else
    load('cura_biomodels_metadata.mat','models'); %Load previously generated data
end
%% Check for fulltext retrival
%Check models for PMIDs
s=0;m=0;
for i=2:length(models)
    if 0==isfield(models(i).publication,'link')%Does the metadata contain a link?
        continue
    end
    temp=models(i).publication.link;
    if isempty(regexp(models(i).publication.link,'pubmed','once'))%Does the link refrence pubmed?
        m=m+1;
        nonPMID_Articles{m}=models(i).publication.link;
        continue%skip non-pubmed articles
    else
        s=s+1;
        temp=models(i).publication.link;
        PMID{s}=temp(31:end); %this could be improved for stability, currently it depends on link being a specific format
    end
end

%API adresses of EPMC, PUBMED, PMC
api_idconvEPMC=['https://www.ebi.ac.uk/europepmc/webservices/rest/search?'...
    'resultType=idlist&cursorMark=*&pageSize=25&format=json&query=ext_id:'];
api_idconvPUBMED = 'https://www.ncbi.nlm.nih.gov/pmc/utils/idconv/v1.0/?format=json&ids=';
api_EPMC_XML='https://www.ebi.ac.uk/europepmc/webservices/rest/';
api_EPMCcap='/fullTextXML';
api_PMCpdf = 'https://www.ncbi.nlm.nih.gov/pmc/utils/oa/oa.fcgi?id=';

s=0;m=0;k=0;%Where s are the number of EPMC downloads, k for PMC, and m for neither(nonretrivals).
            %Because k always seems to be zero - Presumably EPMC gets content from PMC - PMC retrival is omitted from fastVer 
for i=1:length(PMID)
    options=weboptions('Timeout',1e5);
    url=strjoin([api_idconvEPMC PMID(i)],'');%Check EPMC for corresponding fulltextID
    queryresult=webread(url,options);
    if 1==isfield(queryresult.resultList.result,'fullTextIdList')
        temp=queryresult.resultList.result.fullTextIdList.fullTextId;
        options=weboptions('Timeout',1e5,'ContentType','xmldom');%Note that content type is specified
        url=strjoin([api_EPMC_XML temp api_EPMCcap],'');
        fname=strjoin(['PMID' PMID(i) 'EPMC' string(i) '.xml'],'');%Name of xml-file      
        try%downloading the article off EPMC if there is a fulltextID
            queryresult=webread(url,options);
            xmlwrite(fname,queryresult);
            s=s+1;
            continue
        catch%If EPMC download fails, try PMC instead
            options=weboptions('Timeout',1e5);
            url=strjoin([api_idconvPUBMED PMID(i)],'');%Check for PMCID
            queryresult=webread(url,options);
            pause(.34)%Limit of requests per second on pubmed is 3
            if isfield(queryresult.records,'pmcid')==0
                m=m+1;
                nonPMCID(m)=PMID(i);%List of PMIDs without PMCID
            else
                try%downloading the article off PMC if there is a PMCID
                    options=weboptions('Timeout',1e5,'ContentType','xmldom');
                    url=strjoin([api_PMCpdf queryresult.records.pmcid],'');
                    queryresult=webread(url,options);
                    xmlwrite('temp.xml',queryresult);
                    %Possible improvement: readstruct did not seem to work
                    %directly on the url, so the xml is first written down
                    %and then readstruct:ed. Going directly to struct would
                    %of course be preferable.
                    queryresult=readstruct('temp.xml');
                    tarurl=queryresult.records.record.link.hrefAttribute;%Retrive link to tar.gz 
                    gunzip(tarurl,'temp');
                    untar(['temp/' PMID(i) '.tar'],'Articles');
                    k=k+1;
                catch
                    m=m+1;
                    nonPMCID(m)=PMID(i);
                end
            end
        end
    else %Identical to "If epmc download fails"
        options=weboptions('Timeout',1e5);
        url=strjoin([api_idconvPUBMED PMID(i)],'');
        queryresult=webread(url,options);
        pause(.33)%Not tax pubmed?
        if isfield(queryresult.records,'pmcid')==0
            m=m+1;
            nonPMCID(m)=PMID(i);
        else
            try
                options=weboptions('Timeout',1e5,'ContentType','xmldom');
                url=strjoin([api_PMCpdf queryresult.records.pmcid],'');
                queryresult=webread(url,options);
                xmlwrite('temp.xml',queryresult);
                queryresult=readstruct('temp.xml');
                tarurl=queryresult.records.record.link.hrefAttribute;
                gunzip(tarurl,'temp');
                untar(['temp/' PMID(i) '.tar'],'Articles');
                k=k+1;
                PMCID{k,:}={queryresult.records.pmcid PMID(i)};
            catch
                m=m+1;
                nonPMCID(m)=PMID(i);
            end
        end
    end
end