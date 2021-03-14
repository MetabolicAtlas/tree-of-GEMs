
clear, clc;

pdf='D:\GEMS\Extracted_new_publications\10.1177_0748730412451077.pdf';
str=extractFileText(pdf);
str_2=char(str);
regex_test=strcat('(Prediction of photoperiodic regulators',').*↵')   %only works for some middle strings

Surrounding_text=regexp(str,regex_test,'match')

%'(\n.*[a-z|A-Z|0-9].*){1,1}\n?.*(',  ').*(.*[a-z|A-Z|0-9].*\n?)+' 