clear; clc; close all;

N = 1024;
pocetnaFrekvencija = 0; krajnjaFrekvencija = 0.5; 
brojSimulacija = 100;  
alphaRenyi = 3;  
SNR = [10, 5, 1]; 

rezultati_fmlin = zeros(length(SNR), 1);
rezultati_fmsin = zeros(length(SNR), 1);
rezultati_fmpar = zeros(length(SNR), 1);

for indeks = 1:length(SNR)
    razinaSNR = SNR(indeks);
    vrijednostiRenyi = zeros(brojSimulacija, 1); 
    for simulacija = 1:brojSimulacija
        signallin = fmlin(N, pocetnaFrekvencija, krajnjaFrekvencija);    
        noise = noisecg(N);
        noisySignal = sigmerge(signallin, noise, razinaSNR);
        [PSD, ~] = pwelch(noisySignal, hamming(256), 128, 1024, 1);
        PSD = PSD / sum(PSD);
        renyiVal = (1/(1 - alphaRenyi)) * log(sum(PSD.^alphaRenyi));
        vrijednostiRenyi(simulacija) = renyiVal;
    end
    rezultati_fmlin(indeks) = mean(vrijednostiRenyi);
end

for indeks = 1:length(SNR)
    razinaSNR = SNR(indeks);
    vrijednostiRenyi = zeros(brojSimulacija, 1); 
    for simulacija = 1:brojSimulacija
        signalsin = fmsin(N);    
        noise = noisecg(N);
        noisySignal = sigmerge(signalsin, noise, razinaSNR);
        [PSD, ~] = pwelch(noisySignal, hamming(256), 128, 1024, 1);
        PSD = PSD / sum(PSD);
        renyiVal = (1/(1 - alphaRenyi)) * log(sum(PSD.^alphaRenyi));
        vrijednostiRenyi(simulacija) = renyiVal;
    end
    rezultati_fmsin(indeks) = mean(vrijednostiRenyi);
end

for indeks = 1:length(SNR)
    razinaSNR = SNR(indeks);
    vrijednostiRenyi = zeros(brojSimulacija, 1); 
    for simulacija = 1:brojSimulacija
        p1 = [1, 0];  
        p2 = [N/2, 0.25]; 
        p3 = [N, 0.4]; 
        [signalpar, ~] = fmpar(N, p1, p2, p3);
        noise = noisecg(N);
        noisySignal = sigmerge(signalpar, noise, razinaSNR);
        [PSD, ~] = pwelch(noisySignal, hamming(256), 128, 1024, 1);
        PSD = PSD / sum(PSD);
        renyiVal = (1/(1 - alphaRenyi)) * log(sum(PSD.^alphaRenyi));
        vrijednostiRenyi(simulacija) = renyiVal;
    end
    rezultati_fmpar(indeks) = mean(vrijednostiRenyi);
end

T = table(SNR.', rezultati_fmlin, rezultati_fmsin, rezultati_fmpar, ...
    'VariableNames', {'SNR','Renyi_fmlin','Renyi_fmsin','Renyi_fmpar'});
disp(T);