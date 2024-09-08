% linear frequency modulation
sig = fmlin(128, 0, 0.5);

% Plot generiranog signala
figure;
plot(real(sig));
xlabel('Time');
ylabel('Amplitude');
title('Time-Domain Representation of linear frequency modulation ');
grid on;

% Fourierova transformacija
dsp = fftshift(abs(fft(sig)).^2);
f = (-length(sig)/2:length(sig)/2-1) / length(sig);

% Plot 
figure;
plot(f, dsp);
xlabel('Normalized Frequency');
ylabel('Power');
title('Frequency Spectrum (FFT) of the Chirp Signal');
grid on;

% Spektralna gustoća snage
[pxx, f] = pwelch(sig, [], [], [], 1);

% Plot SGS
figure;
plot(f, 10*log10(pxx));
xlabel('Frequency');
ylabel('Power/Frequency (dB/Hz)');
title('Power Spectral Density of the Chirp Signal');
grid on;

% Generiranje šuma
N = 256; 
noise = noisecg(N, 0.8); 

% Plot šum
figure;
plot(real(noise));
xlabel('Time');
ylabel('Amplitude');
title('Colored Gaussian Noise in Time Domain');

% FFT and PSD of the signal
dsp = fftshift(abs(fft(noise)).^2); % Power spectrum
f = (-N/2:N/2-1)/N; % Frequency axis

% Plot the PSD
figure;
plot(f, dsp);
xlabel('Normalized Frequency');
ylabel('Power');
title('Power Spectral Density of the Noise');


% Log-Log Plot
figure;
loglog(f(f>0), dsp(f>0));
xlabel('Frequency');
ylabel('Power');
title('Log-Log Power Spectral Density');
grid on;

% Fit a line to the log-log PSD
logF = log(f(f>0)); % Log of positive frequencies
logPxx = log(dsp(f>0)); % Log of power spectrum

% Fit a line
coefficients = polyfit(logF, logPxx, 1);
slope = coefficients(1);

% Display the slope
fprintf('The slope of the log-log PSD is: %.2f\n', slope);

% Determine the color of the noise based on slope
if slope >= -0.5 && slope <= 0.5
    disp('The signal is White Noise');
elseif slope > -1.5 && slope < -0.5
    disp('The signal is Pink Noise');
elseif slope < -1.5
    disp('The signal is Brown Noise');
else
    disp('Unknown noise characteristic');
end



