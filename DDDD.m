clear; clc; close all;

N = 1024;
pocetnaFrekvencija = 0; krajnjaFrekvencija = 0.5; 
brojSimulacija = 100;  
alphaRenyi = 3;  
SNR = [10, 5, 1]; 

results_fmlin = zeros(length(SNR), 1);
results_fmsin = zeros(length(SNR), 1);
results_fmpar = zeros(length(SNR), 1);

for indeks = 1:length(SNR)
    razinaSNR = SNR(indeks);
    vrijednostiRenyi = zeros(brojSimulacija, 1); 
    for simulacija = 1:brojSimulacija
        signal = fmlin(N, pocetnaFrekvencija, krajnjaFrekvencija);    
        noise = noisecg(N);
        noisySignal = sigmerge(signal, noise, razinaSNR);
        [PSD, ~] = pwelch(noisySignal, hamming(256), 128, 1024, 1);
        PSD = PSD / sum(PSD);
        renyiVal = (1/(1 - alphaRenyi)) * log(sum(PSD.^alphaRenyi));
        vrijednostiRenyi(simulacija) = renyiVal;
    end
    results_fmlin(indeks) = mean(vrijednostiRenyi);
end

for indeks = 1:length(SNR)
    razinaSNR = SNR(indeks);
    vrijednostiRenyi = zeros(brojSimulacija, 1); 
    for simulacija = 1:brojSimulacija
        signal = fmsin(N);    
        noise = noisecg(N);
        noisySignal = sigmerge(signal, noise, razinaSNR);
        [PSD, ~] = pwelch(noisySignal, hamming(256), 128, 1024, 1);
        PSD = PSD / sum(PSD);
        renyiVal = (1/(1 - alphaRenyi)) * log(sum(PSD.^alphaRenyi));
        vrijednostiRenyi(simulacija) = renyiVal;
    end
    results_fmsin(indeks) = mean(vrijednostiRenyi);
end

for indeks = 1:length(SNR)
    razinaSNR = SNR(indeks);
    vrijednostiRenyi = zeros(brojSimulacija, 1); 
    for simulacija = 1:brojSimulacija
        p1 = [1, 0];  
        p2 = [N/2, 0.25]; 
        p3 = [N, 0.4]; 
        [signal, ~] = fmpar(N, p1, p2, p3);
        noise = noisecg(N);
        noisySignal = sigmerge(signal, noise, razinaSNR);
        [PSD, ~] = pwelch(noisySignal, hamming(256), 128, 1024, 1);
        PSD = PSD / sum(PSD);
        renyiVal = (1/(1 - alphaRenyi)) * log(sum(PSD.^alphaRenyi));
        vrijednostiRenyi(simulacija) = renyiVal;
    end
    results_fmpar(indeks) = mean(vrijednostiRenyi);
end

T = table(SNR.', results_fmlin, results_fmsin, results_fmpar, ...
    'VariableNames', {'SNR_dB','Renyi_fmlin','Renyi_fmsin','Renyi_fmpar'});
disp(T);