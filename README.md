These codes have three purposes. Firstly, to download pdfs of publications related to models (GEMs) along with their meta data. Secondly, to search for correlations between models and their respective publications. Lastly, to enable a smoothe and organized method of displaying the information gathered/acertained from the previous code.

To each purpose, there is a different code. The currently uploaded code are shown bellow.

Regex.m - Searches for correlations between different models using the pdfs fetched from PubMed. It has come far in its developement and is ready to be used as long as the repository containing the pdfs is specified. One must additionally have a table with the meta data called 'cura_biomodels_metadata.mat' in order to run the code.

apifetcher.m - This program will 1. Query BioModels for metadata of curated models. 2.Download available fulltextXMLs of their respective articles from Europe PMC