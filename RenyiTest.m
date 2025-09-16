clear; clc; close all;

N = 128;
pocetnaFrekvencija = 0; krajnjaFrekvencija = 0.5; 
brojSimulacija = 100;  
alphaRenyi = 3;  
SNR = [10, 5, 1]; 

prosjecnaRenyi = zeros(length(SNR), 1);

for indeks = 1:length(SNR)
    razinaSNR = SNR(indeks);
    vrijednostiRenyi = zeros(brojSimulacija, 1); 
    
    
    for simulacija = 1:brojSimulacija
        signal = fmlin(N, pocetnaFrekvencija, krajnjaFrekvencija);
        
        sum = noisecg(N);
        
        noisySignal = sigmerge(signal, sum, razinaSNR);
        
        [wvd_tf, vrijeme, frekvencija] = tfrwv(noisySignal);
        
        vrijednostRenyi = renyi(wvd_tf, vrijeme, frekvencija, alphaRenyi);
        vrijednostiRenyi(simulacija) = vrijednostRenyi;
    end
    
    prosjecnaRenyi(indeks) = mean(vrijednostiRenyi);
    fprintf('Prosjecna Renyi entropija za SNR %d dB: %.4f\n', razinaSNR, prosjecnaRenyi(indeks));
end

tablicaRezultata = table(SNR', prosjecnaRenyi, ...
                      'Var', {'SNR', 'Prosjecna_Renyiova_Entropija(alpha3)'});

disp('Tablica rezultata:');
disp(tablicaRezultata);