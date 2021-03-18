%% Code that creats info
%Code that fetches pdf and renames

%Code that reads pdf and creats table about "hits"

%Code that fetches info and creats table about info

%% Code that is used when annotating
% Code that fetches wanted pdf
% Code that loads regex results as well as model info
% Code that makes annotating simple

% clear; clc;
% 
% load('jsonStr.mat');
% 
% info=fopen('info.json','w');
% 
% info_new=fprintf(info,jsonStr)
% clear, clc;
load('PMC-ids.csv')


%% Code renaming files
clear, clc;

myFolder = 'D:\GEMS\New folder';
filePattern = fullfile(myFolder, '*'); % Change to whatever pattern you need.
theFiles = dir(filePattern);

for k = 1 : length(theFiles)
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
end

d=dir(fullfile('D:\GEMS\New folder','**','*.pdf'));
j=2;
for k=1:length(d)
    num_str_check=d(k).folder(23:end);
    num_check=str2double(num_str_check);
    d(k).num_check=num_check;
end

for i=2:length(d)
    if d(i).num_check==d(i-1).num_check
    else 
        j=2;
    end
    new_name=d(i).folder(20:end);
    folder=d(i).folder;
    file_name=d(i).name;
    old_file=[folder,'\',file_name];
    middle_file=[folder,'\','middle','_',num2str(i),'.pdf'];
    if d(i).num_check==d(i-1).num_check
        j_str=num2str(j);
        new_file=[folder,'\',new_name,'_',j_str,'.pdf'];
        j=j+1;
    else
        new_file=[folder,'\',new_name,'_1','.pdf'];
    end
     movefile(old_file,middle_file);
     movefile(middle_file,new_file);
end
movefile([d(1).folder,'\',d(1).name],[d(1).folder,'\','middle','_1','.pdf']);
movefile([d(1).folder,'\','middle','_1','.pdf'],[d(1).folder,'\',d(1).folder(20:end),'_1','.pdf']);
file_names=dir(fullfile('D:\GEMS\New folder','**','*.pdf'));
save('file_names.mat','file_names')

%%
% clear,clc;
% load('cura_biomodels_metadata.mat')
% 
% field = 'PMID'; field2='Num'; field3='Found_in_file'; field4='Found_in_publication_title'; field5='String_publication_title';
% value = {};
% value2 = {{}};
% PMID = struct(field,value,field2,value);

% s=0;
% for i=2:length(models)
%     if 0==isfield(models(i).publication,'link')
%         continue
%     end
%     temp=models(i).publication.link;
%     if isempty(regexp(models(i).publication.link,'pubmed','once'))
%         continue%skip non-pubmed articles
%     else
%         s=s+1;
%         temp=models(i).publication.link;
%         num=i;
%         PMID(s).PMID=temp(31:end);
%         PMID(s).Num=num;
%     end
% end



%%

% for k=1:906
% PMID_num=str2num(PMID(k).PMID)
% PMID(k).PMID=PMID_num;
% end

% i=0;
% for i=1:length(PMID)
% if PMID(i)PMID==PMCids(i).PMID
%     PMID(i).PMCID=PMCids(i).PMCID;
% end
% end

i=0;
for i=1:length(PMID)
a=find(PMID(i).PMID==PMCids.PMID);
 
PMID(i).PMCID=PMCids(a,9).PMCID;
end


%% Check if empty
p=0;
j=0
for p=1:length(PMID)
d=isempty(PMID(p).PMCID);
if d==1
    j=j+1;
end
end
j  


%% Fills in model name, publication title and link in PMID
k=0;
s=1;
for k=1:(length(models)-1)

number=str2double(models(k).publication.link(31:end));
if PMID(s).PMID==number
    PMID(s).model_name=models(k).name;
    PMID(s).publication_title=models(k).publication.title;
    PMID(s).link=models(k).publication.link;
    s=s+1;
end
end


%% Adding PDF name to Base_info

clear, clc;
format long
load file_names.mat
load Model_hits.mat
load Base_info.mat


for i=1:906
a=convertStringsToChars(PMID(i).PMCID);
PMID(i).PMCID_char=a;
b=PMID(i).PMCID_char(4:end);
PMID(i).PMCID_num=str2double(b);
PMID(i).NUMBER=i;
end
for n=1:20
    under=n;
Middle_PMID(1).pdf_name_1=''
end

% r=find(abs(file_names_PMC_num-(PMID.PMCID_num))<10^-6)


for j=length(PMID):-1:1
  if isempty(PMID(j).PMCID)
    PMID(j)=[];
  end
end

for i=1:length(file_names)
    
file_names_PMC=file_names(i).folder(23:end);
file_names_PMC_num=str2double(file_names_PMC);

r=find(file_names_PMC_num==[PMID.PMCID_num]);

for k=1:length(r)
PMID(r(k)).pdf_name=file_names(i).name;
end

end
Middle_PMID=PMID;
save('Middle_PMID.mat','Middle_PMID');
load Base_info.mat
load Middle_PMID.mat

for l=1:length(Middle_PMID)
    PMID(Middle_PMID(l).NUMBER).pdf_name=Middle_PMID(l).pdf_name;
end




