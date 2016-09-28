function [sig] = constructVocab(Label , Mail )

%Construct Vocab
 
nMail = size(Mail, 1);
vocab = containers.Map;
reverseVocab = containers.Map;
count = 1;

stopWords = {'a', 'about', 'above', 'across', 'after', 'afterwards', 'again', 'against', 'all', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'amoungst', 'amount',  'an', 'and', 'another', 'any', 'anyhow', 'anyone', 'anything', 'anyway', 'anywhere', 'are', 'around', 'as',  'at', 'back', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'below', 'beside', 'besides', 'between', 'beyond', 'bill', 'both', 'bottom', 'but', 'by', 'call', 'can', 'cannot', 'cant', 'co', 'con', 'could', 'couldnt', 'cry', 'de', 'describe', 'detail', 'do', 'done', 'down', 'due', 'during', 'each', 'eg', 'eight', 'either', 'eleven', 'else', 'elsewhere', 'empty', 'enough', 'etc', 'even', 'ever', 'every', 'everyone', 'everything', 'everywhere', 'except', 'few', 'fifteen', 'fify', 'fill', 'find', 'fire', 'first', 'five', 'for', 'former', 'formerly', 'forty', 'found', 'four', 'from', 'front', 'full', 'further', 'get', 'give', 'go', 'had', 'has', 'hasnt', 'have', 'he', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'him', 'himself', 'his', 'how', 'however', 'hundred', 'i', 'ie', 'if', 'in', 'inc', 'indeed', 'interest', 'into', 'is', 'it', 'its', 'itself', 'keep', 'last', 'latter', 'latterly', 'least', 'less', 'ltd', 'made', 'many', 'may', 'me', 'meanwhile', 'might', 'mill', 'mine', 'more', 'moreover', 'most', 'mostly', 'move', 'much', 'must', 'my', 'myself', 'name', 'namely', 'neither', 'never', 'nevertheless', 'next', 'nine', 'no', 'nobody', 'none', 'noone', 'nor', 'not', 'nothing', 'now', 'nowhere', 'of', 'off', 'often', 'on', 'once', 'one', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'our', 'ours', 'ourselves', 'out', 'over', 'own', 'part', 'per', 'perhaps', 'please', 'put', 'rather', 're', 'said', 'same', 'see', 'seem', 'seemed', 'seeming', 'seems', 'serious', 'several', 'she', 'should', 'show', 'side', 'since', 'sincere', 'six', 'sixty', 'so', 'some', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhere', 'still', 'such', 'system', 'take', 'ten', 'than', 'that', 'the', 'their', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'thereupon', 'these', 'they', 'thickv', 'thin', 'third', 'this', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'top', 'toward', 'towards', 'twelve', 'twenty', 'two', 'un', 'under', 'until', 'up', 'upon', 'us', 'very', 'via', 'was', 'we', 'well', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'those', 'why', 'will', 'with', 'within', 'without', 'would', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'the'};

for i = 1:nMail

    mail = Mail{i};
    nWords = size(mail, 1);

    for j = 1:nWords
        
        word = mail{j};
                  
        if (size(word, 2) < 3)
            continue;
        end

        if (strcmp(regexp(word, '[a-zA-Z][a-z]+', 'match'), word) & ~any(strcmp(stopWords, word)))

            if (~vocab.isKey(word))
                vocab(word) = count;
                count = count + 1;
            end
        
        end

    end

end

%Construct Features

nFeat = size(vocab, 1);
Feats = zeros(nMail, nFeat);

for i = 1:nMail
    
    mail = Mail{i};
    
    if (mod(i,10)==1) 
        disp(i)
    end
    
    nWords = size(mail, 1);
    
    for j = 1:nWords
        
        word = mail{j};
        
        if(vocab.isKey(word))
            index = vocab.values({word});
            Feats(i, index{1}) = Feats(i, index{1}) + 1;
        end
    
    end 
    
end

idf = (Feats~=0);
idf = sum(idf, 1);
idf = log(nMail./(idf + 1)) ;

Feats = Feats.*(repmat(idf, nMail, 1));

featScore = IndFeat(Feats, Label);

relFeatInd = find(featScore>=1.8);
dictSize = size(relFeatInd, 2);

keySet = keys(vocab);
valueSet = cell2mat(values(vocab, keySet));
dict = cell(1, dictSize);
for i = 1:dictSize
    ind = relFeatInd(i);
    dict{i} = keySet{valueSet == ind};
end

fid = fopen('C:\Users\DISHAN\Desktop\handout\code\dictionary.csv','w');
fprintf(fid,'%s,',dict{1,1:end-1});
fprintf(fid,'%s\n',dict{1, end});
fclose(fid);

end

