%% AKILLI İK CV DEĞERLENDİRME SİSTEMİ 
clear; clc;

% 1. Veri Setinin Yüklenmesi
csvFile = 'UpdatedResumeDataset.csv';

opts = detectImportOptions(csvFile);
opts.VariableNamingRule = 'preserve';
rawDataset = readtable(csvFile, opts);

fprintf('Kaggle Veri Seti Başarıyla Yüklendi. Toplam Kayıt: %d\n', height(rawDataset));

% 2. İş İlanı Kriterleri
jobDescription = "3rd year software engineering student familiar with C#, Node.js, HTML, and database design.";

% Performans için ilk 10 adayı değerlendirme
numCandidates = 10; 
evaluatedCandidates = cell(numCandidates, 1);

fprintf('\n--- Yapay Zeka Sıralama Süreci Başlatıldı ---\n');

% 3. CV Değerlendirme Döngüsü
for i = 1:numCandidates
    fprintf('Aday %d analizi yapılıyor...\n', i);
    
    % Hataları önlemek için verileri güvenli şekilde stringe çevirme
    adayYetenekler = string(rawDataset.skills{i});
    adayOkul = string(rawDataset.educational_institution_name{i});
    adayPozisyon = string(rawDataset.positions{i});
    adaySorumluluk = string(rawDataset.responsibilities{i});
    
    rawResume = sprintf('Yetenekler: %s. Egitim: %s. Pozisyon: %s. Sorumluluklari: %s.', ...
                         adayYetenekler, adayOkul, adayPozisyon, adaySorumluluk);
    
    cleanedResume = cleanResume(rawResume);
    
    try
        jsonRaw = evaluateResumeWithLLM(cleanedResume, jobDescription);
        parsedStruct = jsondecode(jsonRaw);
        
        % Yapay zeka JSON içindeki isimlendirmeleri değiştirirse bile sistemin çökmesini engeller.
        outStruct = struct();
        outStruct.Aday_ID = i;
        outStruct.Pozisyon = adayPozisyon;
        outStruct.Puan = 0; % Varsayılan
        outStruct.Degerlendirme = "Değerlendirme alınamadı.";
        
        if isfield(parsedStruct, 'Puan')
            outStruct.Puan = parsedStruct.Puan;
        end
        if isfield(parsedStruct, 'Kisa_Degerlendirme')
            outStruct.Degerlendirme = string(parsedStruct.Kisa_Degerlendirme);
        elseif isfield(parsedStruct, 'Kisa_Degerlendirme_Notu')
            outStruct.Degerlendirme = string(parsedStruct.Kisa_Degerlendirme_Notu);
        end
        
        evaluatedCandidates{i} = outStruct;
    catch ME
        fprintf('  -> Hata [Aday %d]: %s\n', i, ME.message);
    end
end

% 4. Sonuçların Sıralanması
validIndices = ~cellfun(@isempty, evaluatedCandidates);

if any(validIndices)
    cleanResults = [evaluatedCandidates{validIndices}];
    resultsTable = struct2table(cleanResults, 'AsArray', true);
    
    % Puanlara göre büyükten küçüğe sırala
    rankedTable = sortrows(resultsTable, 'Puan', 'descend');
    
    writetable(rankedTable, 'Ranked_Candidates_MATLAB.csv');
    fprintf('\n================ SIRALANMIŞ EN UYGUN ADAYLAR ================\n');
    disp(rankedTable);
else
    fprintf('\nMaalesef hiçbir aday başarılı şekilde okunamadı.\n');
end