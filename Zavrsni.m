%% 

fs = 1000; % Frequency of sampling (Hz)
t = 0:1/fs:10-1/fs; % Time vector
whiteNoise = randn(size(t)); % White noise signal

% Plot the white noise signal in the time domain
figure;
plot(t, whiteNoise);
xlabel('Time (s)');
ylabel('Amplitude');
title('White Noise in Time Domain');
grid on;



%% 
N = length(whiteNoise); % Length of the signal
f = (0:N-1)*(fs/N); % Frequency vector

% Compute the FFT of the signal
Y = fft(whiteNoise);

% Plot the magnitude of the FFT (single-sided spectrum)
figure;
plot(f(1:floor(N/2)), abs(Y(1:floor(N/2))));
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('White Noise in Frequency Domain (FFT)');
grid on;

%% 
% Using the pwelch method for PSD
[pxx, f] = pwelch(whiteNoise, [], [], [], fs);

% Plot the PSD
figure;
plot(f, 10*log10(pxx)); % Convert to dB scale
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
title('Power Spectral Density (PSD)');
grid on;

%% 

% Plot spectrogram
figure;
spectrogram(whiteNoise,256,250,256,fs,'yaxis');
title('Spectrogram of White Noise');
