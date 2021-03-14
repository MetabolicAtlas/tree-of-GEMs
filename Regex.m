%% Fetches publication title   %*.* NOT type:"file folder"
clear,clc;
load('Models.mat', 'models')
nr_models=985;  %(986 does not have publication)

%found here: https://matlab.fandom.com/wiki/FAQ#How_can_I_process_a_sequence_of_files.3F
% Specify the folder where the files live.
myFolder = 'D:\GEMS\Extracted_new_publications';

% Get a list of all files in the folder with the desired file name pattern.
filePattern = fullfile(myFolder, '*.pdf'); % Change to whatever pattern you need.
theFiles = dir(filePattern);
for k = 1 : length(theFiles)
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
end

p=0;

f=1;    %number of files to look at

field = 'Hits'; field2='String'; field3='Found_in_file'; field4='Found_in_publication_title'; field5='String_publication_title';
value = {};
value2 = {{}};
Model_hits = struct(field,value,field2,value2,field3,value2,field4,value2);   

for j=1:f                           % CHANGE MODEL SPAN
    pdf=theFiles(j,1).name;
    str=extractFileText(pdf);
    
    for i=1:nr_models
        pub_title=models(i).publication.title;
        
        string_length=strlength(pub_title);
        
        n=2;    %nr of fractions of scentence
        
        fraction_of_scentence=floor((string_length)./n);
        
        for k=1:n
            section_of_scentence=fraction_of_scentence.*k;
            if (string_length-section_of_scentence)<=n
                section_of_scentence=section_of_scentence+(string_length-section_of_scentence);
            end
            output_fraction_of_scentence=section_of_scentence;
            l=fraction_of_scentence.*(k-1)+1;
            output_string_of_scentence=pub_title(l:output_fraction_of_scentence);            
            startIndex = regexp(str,output_string_of_scentence);    %to fix change regex_test to output_string_of_scentence
            
            hit=sum(startIndex>=0);
            
            if(hit>0)
%                 regex_test=strcat('(\n.*[a-z|A-Z|0-9].*){1,1}\n?.*(',output_string_of_scentence,').*(.*[a-z|A-Z|0-9].*\n?)+');   %only works for some middle strings
%                 Surrounding_text = regexp(str,output_string_of_scentence);
%                 Surrounding = convertStringsToChars(str);
%                 Surrounding((Surrounding_text-100):(Surrounding_text+100));
                p=p+1;              
                Model_hits(p).Hits=hit;
                Model_hits(p).String=output_string_of_scentence;
                Model_hits(p).Found_in_file=pdf;
                Model_hits(p).Found_in_publication_title=j;
                Model_hits(p).String_publication_title=models(i).publication.title;
                
                
            end
        end
    end
    
end


t=struct2table(Model_hits)

% jsonStr = jsonencode(Model_hits);

% struct = jsondecode(jsonStr);

% save(jsonStr)

% save(struct)

%remember omitnan

%(.*[ ]\n)+.*photoperiodic regulators.*(.*[a-z].*\n)+
%(.*[ ]\n)+.*(photoperiodic regulators).*(.*[a-z].*\n?)+
%(\n.*[a-z].*)+\n.*(Reproducible computationa).*(.*[a-z0-9].*\n?)+
%(\n.*[a-z|A-Z|0-9].*)\n.*(hotoperiodic re).*(.*[a-z|A-Z|0-9].*\n?)+

%(\n.*[a-z|A-Z|0-9].*){1,1}\n?.*(Cell 139).*(.*[a-z|A-Z|0-9].*\n?)+


%1