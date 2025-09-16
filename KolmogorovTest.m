clear; clc; close all;

N = 128;
pocetnaFrekvencija = 0; krajnjaFrekvencija = 0.5; 
brojSimulacija = 100;  
SNR = [10, 5, 1]; 

prosjecnaSlozenost = zeros(length(SNR), 1);

for indeks = 1:length(SNR)
    razinaSNR = SNR(indeks);
    vrijednostiSlozenosti = zeros(brojSimulacija, 1); 
    
    for simulacija = 1:brojSimulacija
        signalCisti = fmlin(N, pocetnaFrekvencija, krajnjaFrekvencija);
        
        sum = noisecg(N);
        
        signalBucni = sigmerge(signalCisti, sum, razinaSNR);
        
        [wvd_tf, vektorVremena, vektorFrekvencija] = tfrwv(signalBucni);
        
        wvd_flat = wvd_tf(:); 
        prag = mean(wvd_flat); 
        binarniNiz = (wvd_flat > prag); 
        
        digitalniString = num2str(binarniNiz);
        
        slozenost = kolmogorov(digitalniString);
        vrijednostiSlozenosti(simulacija) = slozenost;
    end
    
    prosjecnaSlozenost(indeks) = mean(vrijednostiSlozenosti);
    fprintf('Prosjecna Kolmogorovova slozenost za SNR %d dB: %.4f\n', razinaSNR, prosjecnaSlozenost(indeks));
end

tablicaRezultata = table(SNR', prosjecnaSlozenost, ...
                      'VariableNames', {'SNR', 'Prosjecna_Kolmogorovova_Slozenost'});

disp('Tablica rezultata:');
disp(tablicaRezultata);