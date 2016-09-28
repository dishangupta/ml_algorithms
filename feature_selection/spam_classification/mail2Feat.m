function [ Feats ] = mail2Feat( Mail )

% THE FOLLOWING IS A VERY SIMPLE EXAMPLE SHOWING ONE POSSIBLE WAY TO
% COLLECT FEATURES. PLEASE REPLACE WITH YOUR CODE. NOTE HOW YOU CAN PLACE 
% PRE-PROCESSED RESULTS IN dictionary.csv.


% load data from dictionary.csv file
fid = fopen('dictionary.csv');    
tline = fgetl(fid);
data = strread(tline,'%s','delimiter',',');

nMail = size(Mail,1);
nFeat = length(data);

% set up the feature matrix.
Feats = [zeros(nMail,nFeat),ones(nMail,1)]; 

%vocab = containers.Map;
%count = 1;
%Construct Vocab Hash Map
%{
for i = 1:nFeat

    word = data{i};
        
    if (~vocab.isKey(word))
        vocab(word) = count;
        count = count + 1;
    end
        
end
%}

% collect features
for i = 1:nMail
    
    mail = Mail{i};
    
    if (mod(i,10)==1) 
        disp(i)
    end
    
    indices = find(ismember(data, mail));
    
    for j = indices
        
        word = data{j};
        
        tf = sum(ismember(mail, word));
        
        Feats(i, j) = tf;
    
    end 
    
end

idf = (Feats~=0);
idf = sum(idf, 1);
idf = log(nMail./(idf + 1)) ;

idf(1, end) = 1;  	

Feats = Feats.*(repmat(idf, nMail, 1));	
    
end

