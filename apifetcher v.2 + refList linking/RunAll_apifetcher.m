% Running this program takes a long while (>40 min). If you've already
% obtained cura_biomodels_metadata.mat,some of organized_metadata.mat or 
% any xml articles (named after their PMCID) then the process will be sped
% up. One might also consider running only some scripts.

%Some webread:s will fail the first time. As most progress is saved, just
%starting the program again should fix the problem with no time loss.
%But it may be wise to wait a while as to not DDOS the site.

retriveMetaData;
% Construct cura_biomodels_metadata.mat if none exists The current code may
% be too taxing on the website though.

clusterModelsbyPublication;
% Cluster models by publication in organized_metadata.mat Will update a
% current organized_metadata.mat with new information from a new
% cura_biomodels_metadata.mat

xmlretrivalEPMC;
% Retrive all articles available through EPMC. Will not redownload already
% existing files.

searchXMLref;
% Search all xml articles for pubmed refrences (PMID/PMCID/DOI). Will not
% look through an article if it already has a refList

linkModels;
% Construct a field of refrences to other models in the dataset. Will 
% update a current organized_metadata.mat with new information.

%Should add a json unpacker/repacker to make the .mat structs git-able