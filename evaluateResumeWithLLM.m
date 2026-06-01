function responseText = evaluateResumeWithLLM(resumeText, jobDescription)
    % =====================================================================
    % SENİN SON ÜRETTİĞİN GEÇERLİ API ANAHTARIN:
    apiKey = 'KENDİ_ANAHTARINIZI_BURAYA_GİRİN'; 
    % =====================================================================
    
    % !!! HATA ÇÖZÜMÜ BURADA: Model 'gemini-2.5-flash' olarak güncellendi !!!
    apiUrl = ['https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=', apiKey];
    
    % Prompt (char() dönüşümleri ile %100 güvenli birleştirme)
    promptStr = ['Sen profesyonel bir İK Yapay Zeka asistanısın.', char(10), ...
        'Aşağıda sana verilen aday özgeçmişini (CV), belirtilen iş ilanı kriterlerine göre değerlendir.', char(10), char(10), ...
        '[İş İlanı Kriterleri]: ', char(jobDescription), char(10), ...
        '[Aday Özgeçmişi]: ', char(resumeText), char(10), char(10), ...
        'Lütfen değerlendirmeni SADECE JSON formatında yap. Kesinlikle markdown etiketleri KULLANMA. Cevabın doğrudan { ile başlasın:', char(10), ...
        '{"Puan": 85, "Kritik_Yetenekler": ["yetenek1"], "Eksik_Alanlar": ["alan1"], "Kisa_Degerlendirme": "Özet not."}'];

    % JSON Mimarisi
    partStruct = struct('text', promptStr);
    contentsStruct = struct('parts', partStruct);
    requestBody = struct('contents', contentsStruct);
    
    options = weboptions('HeaderFields', {'Content-Type', 'application/json'}, ...
                         'Timeout', 60, 'RequestMethod', 'post');
                     
    try
        % İstek At
        apiResponse = webwrite(apiUrl, requestBody, options);
        rawText = apiResponse.candidates(1).content.parts(1).text;
        
        % --- KURŞUN GEÇİRMEZ JSON YAKALAYICI (JSON CATCHER) ---
        startIndex = strfind(rawText, '{');
        endIndex = strfind(rawText, '}');
        
        if ~isempty(startIndex) && ~isempty(endIndex)
            rawText = rawText(startIndex(1):endIndex(end));
        end
        
        responseText = rawText;
    catch ME
        % Hata durumunda mesajı göster
        disp(ME.message);
        error('Gemini API İsteği reddedildi.');
    end
end