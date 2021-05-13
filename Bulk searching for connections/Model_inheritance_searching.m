function Model_inheritance_searching(i)
clc
% addpath 'D:\GEMS\Function folder testing'
load('Model_hits.mat', 'Model_hits');
load('cura_biomodels_metadata.mat');
%% Currently unused
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
%% Construct table of information to display
string_nr='string_nr';
file_nr='File_nr';
string_of_text_found='string_of_text_found';
full_title='full_title';
empty_num = {};
empty_char = {{}};
display=struct(string_nr,empty_num, string_of_text_found,empty_char, full_title,empty_char);
%% Assign values to and display table
j=0;
p=0;
for j=1:length(Model_hits)
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
%% Open article webpage
j=find([Model_hits.Found_in_publication_title]==i);
k=j(1);%j contains identical 
PMID=Model_hits(k).Found_in_file(1:8);
webpage=['http://identifiers.org/pubmed/' PMID];
web(webpage);
%% User clipboard prompt
while 0==0 %Endless while loop
    prompt = 'Choose string number to copy:';
    str_nr = input(prompt);
    if isempty(str_nr)
        break
    end
    clipboard('copy', display(str_nr).string_of_text_found)
end
