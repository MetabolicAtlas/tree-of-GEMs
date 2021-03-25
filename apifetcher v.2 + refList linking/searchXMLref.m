clc,clear
load('organized_metadata.mat')


%doi to pmid address
options=weboptions('Timeout',1e5);
api_idconvPUBMED = 'https://www.ncbi.nlm.nih.gov/pmc/utils/idconv/v1.0/?format=json&ids=';
if 0==isfield(organized_metadata,'refList')%First time
    organized_metadata(1).refList=[];
end
for i=1:length(organized_metadata)
    s=0;k=0;l=0;
    if 1==isempty(organized_metadata(i).refList) %Has the xml alread been looked through?
        if 1==isfield(organized_metadata(i).file,'name')%Is there a file? ¤¤¤Should add 'and is it xml'
            fname=[organized_metadata(i).file.name '.' organized_metadata(i).file.type];
            doc_struct=readstruct(fname);
            ref_struct=doc_struct.back.ref_list.ref;
            for j=1:length(ref_struct)
                if 1==isfield(ref_struct(j),'element_citation')
                    citType='element_citation';
                elseif 1==isfield(ref_struct(1),'mixed_citation')
                    citType='mixed_citation';
                end%citType
                if 1==isfield(ref_struct(j).(citType),'pub_id')%Is it PubMed?
                    if 1==isfield(ref_struct(j).(citType).pub_id,'pub_id_typeAttribute')%Check for pmid
                        typeAttributes=[ref_struct(j).(citType).pub_id.pub_id_typeAttribute];
                        logical_pmid=strcmp(typeAttributes,'pmid');
                        logical_doi=strcmp(typeAttributes,'doi');
                        if any(logical_pmid)
                            k=k+1;
                            organized_metadata(i).refList(1).type='pmid';
                            organized_metadata(i).refList(1).value(k)={ref_struct(j).(citType).pub_id(logical_pmid).Text};
                        elseif any(logical_doi)%convert doi only citations to pmid
                            doi=char(ref_struct(j).(citType).pub_id(logical_doi).Text);
                            url=[api_idconvPUBMED doi];
                            queryresult=webread(url,options);
                            if 1==isfield(queryresult.records,'pmid')
                                k=k+1;
                                organized_metadata(i).refList(1).type='pmid';
                                organized_metadata(i).refList(1).value(k)={queryresult.records.pmid};
                            elseif 1==isfield(queryresult.records,'pmcid')
                                l=l+1;
                                organized_metadata(i).refList(2).type='pmcid';
                                organized_metadata(i).refList(2).value(l)={queryresult.records.pmcid};
                            else
                                s=s+1;
                                potentially_not_on_pubmed_any_longer(s)=queryresult.records;
                            end
                            pause(.34)%Limit of requests per second on pubmed is 3
                        end
                    else
                        k=k+1;
                        organized_metadata(i).refList(1).type='pmid';
                        organized_metadata(i).refList(1).value(k)={ref_struct(j).(citType).pub_id.Text};
                    end
                end
            end
        end
    end
end
save('organized_metadata.mat','organized_metadata')