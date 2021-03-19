function Model_inheritance_searching(i)
clc
% addpath 'D:\GEMS\Function folder testing'
load('Model_hits.mat', 'Model_hits');
load('cura_biomodels_metadata.mat');

% myFolder = 'D:\GEMS\Extracted_new_publications';
%
% filePattern = fullfile(myFolder, '*.pdf');
% theFiles = dir(filePattern);
% for k = 1 : length(theFiles)
%     baseFileName = theFiles(k).name;
%     fullFileName = fullfile(theFiles(k).folder, baseFileName);
% end
%
% pdf=theFiles(i,1).name
% open(pdf);

string_nr='string_nr';  file_nr='File_nr';  string_of_text_found='string_of_text_found';    full_title='full_title';
empty_num = {}; empty_char = {{}};
display=struct(string_nr,empty_num, string_of_text_found,empty_char, full_title,empty_char);

j=0;
p=0;
for j=1:24
    if Model_hits(j).Found_in_publication_title==i
        % hits=Model_hits(j);
        
        p=p+1;
        display(p).string_nr=p;
        display(p).file_nr=i;
        display(p).string_of_text_found=Model_hits(j).String;
        display(p).full_title=Model_hits(j).String_publication_title;
        
    end
    
end

t=struct2table(display)

j=find([Model_hits.Found_in_publication_title]==i);
k=j(1);
PMID=Model_hits(k).Found_in_file(1:8);
webpage=['http://identifiers.org/pubmed/' PMID];
web(webpage);

m=0;
while m==0
    prompt = 'Coppy string nr to clipboard ';
    a = input(prompt);
    
    str = input(prompt,'s');
    if isempty(str)
        break
    end
    
    clipboard('copy', display(a).string_of_text_found)
end
end




