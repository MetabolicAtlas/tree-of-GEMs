clc,clear
fname='paradigm1citations.csv';

% Get data
data = readtable(fname,'TextType','string');
textData=data.cit;
labels = data.connType;

figure(1); % Initialize figure

Category = ["Original" "Direct" "Partially Direct" "Indirect"];
for conns = 1:4
    clear documents
    clear wordBag
    subplot(2,2,conns)
    
    idx = labels == Category(conns); % Get all belonging to a certain conntype
    
    temp = textData(idx);
    
    % Tokenize the text.
    documents = tokenizedDocument(temp);
    
    % Classify words as nouns etc. and split 'you're' to 'you' & 're'.
    documents = addPartOfSpeechDetails(documents);
    
    % Remove insignificant words such as in 'as' & 'in'.
    documents = removeStopWords(documents);
    
    % Make all lowercase and remove conjugation (swimming becomes swim).
    documents = normalizeWords(documents,'Style','lemma');
    
    % Erase punctuation.
    documents = erasePunctuation(documents);
    
    % Remove words with 3 or fewer characters.
    documents = removeShortWords(documents,3);
    
    % Make a bag-of-words
    wordBag = bagOfWords(documents);
    
    % Remove infrequent words (ocurrance 2>=) from the bag
    wordBag = removeInfrequentWords(wordBag,2);
    
    % Remove words that are known false positives (trivial, authors, year)
    wordBag = removeWords(wordBag,["model" "chen"...
        "locke" "tyson" "proctor" "leloup" "vilar" "pokhilko" "novak" "2005"...
        "2006" "2003" "smolen" "klipp"]);
    
    % Remove empty documents
    wordBag = removeEmptyDocuments(wordBag);
    
    % Make word cloud
    wordcloud(wordBag)
    title(Category(conns));
end