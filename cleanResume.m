function cleanedText = cleanResume(rawText)
% cleanResume - Ham CV metnini temizler.

txt = lower(string(rawText));

% RegEx ile linkleri, etiketleri ve özel karakterleri sil
txt = regexprep(txt, 'http\S+\s*', ' ');  
txt = regexprep(txt, 'RT|cc', ' ');      
txt = regexprep(txt, '#\S+', '');         
txt = regexprep(txt, '@\S+', ' ');        

punctuationPattern = '[!"#$%&''()*+,-./:;<=>?@[\]^_`{|}~]';
txt = regexprep(txt, punctuationPattern, ' '); 

txt = regexprep(txt, '\s+', ' ');
cleanedText = strtrim(txt);


end