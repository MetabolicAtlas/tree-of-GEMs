clc,clear;
options=weboptions('Timeout',1e3);%High timeout because of large requests
if isfile('cura_biomodels_metadata.mat')==0 %Check if data is already generated
    modelIDs={'null'};%define modelIDs for use in loop
    api = 'https://www.ebi.ac.uk/biomodels'; %Base api adress
    %This for-loop queries the api for all modelIDs
    for i=1:1e10
        url = strjoin([api...These are our requests to the api, appended to the adress
            '/search?'...%Search for:
            'query=*%3A*%20AND%20curationstatus%3A"Manually%20curated"&domain=biomodels'...All manually curated models
            '&numResults=100'...return 100 results (max size)
            '&sort=publication_year-asc'...arbitrary sorting
            '&format=json'...return as json
            '&offset='+string((i-1)*100)],'');%we offset to skip previous results
        queryresult = webread(url,options);%The result of our search
        if 1==isempty(queryresult.models)%Ergo we have gotten all IDs
            break
        end    
        modelIDs=[modelIDs;{queryresult.models.id}'];%save the IDs of all results
    end
    %This for-loop request a model from our list of modelIDs
    for i=2:length(modelIDs)
        url=[api '/' modelIDs{i} '?format=json'];%Gives modelmetadata
        modeltemp=webread(url,options);
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