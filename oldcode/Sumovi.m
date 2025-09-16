% Step 1: Generate a linear frequency modulated signal (chirp signal)
N = 128;
sig = fmlin(N, 0, 0.5);

% Step 2: Generate four different types of noise using Time-Frequency Toolbox and MATLAB
noise1 = noisecg(N, 0.8);  % Original colored Gaussian noise
noise2 = randn(1, N);  % White noise
noise3 = pinknoise(N);  % Pink noise
noise4 = cumsum(randn(1, N));  % Brown noise (integrated white noise)

% Step 3: Compute Fourier Transform and Power Spectral Density (PSD) for each noise

% Noise 1: Colored Gaussian noise
dsp1 = fftshift(abs(fft(noise1)).^2); 
f_noise1 = (-N/2:N/2-1) / N;

% Noise 2: White noise
dsp2 = fftshift(abs(fft(noise2)).^2); 
f_noise2 = (-N/2:N/2-1) / N;

% Noise 3: Pink noise
dsp3 = fftshift(abs(fft(noise3)).^2); 
f_noise3 = (-N/2:N/2-1) / N;

% Noise 4: Brown noise
dsp4 = fftshift(abs(fft(noise4)).^2); 
f_noise4 = (-N/2:N/2-1) / N;

% Step 4: Plot Power Spectral Density of all noises on a log-log scale
figure;
loglog(f_noise1(f_noise1 > 0), dsp1(f_noise1 > 0), 'r', 'LineWidth', 1.5); hold on;
loglog(f_noise2(f_noise2 > 0), dsp2(f_noise2 > 0), 'g', 'LineWidth', 1.5);
loglog(f_noise3(f_noise3 > 0), dsp3(f_noise3 > 0), 'b', 'LineWidth', 1.5);
loglog(f_noise4(f_noise4 > 0), dsp4(f_noise4 > 0), 'k', 'LineWidth', 1.5);

xlabel('Frequency');
ylabel('Power');
title('Log-Log Power Spectral Density of Different Noises');
legend('Colored Gaussian Noise', 'White Noise', 'Pink Noise', 'Brown Noise');
grid on;

% Step 5: Calculate the slope for each noise on the log-log plot

% Noise 1: Colored Gaussian noise
logF1 = log(f_noise1(f_noise1 > 0));  % Log of frequency (positive values)
logPxx1 = log(dsp1(f_noise1 > 0));    % Log of PSD
coeff1 = polyfit(logF1, logPxx1, 1);  % Fit a line and get the slope
slope1 = coeff1(1);

% Noise 2: White noise
logF2 = log(f_noise2(f_noise2 > 0));  % Log of frequency (positive values)
logPxx2 = log(dsp2(f_noise2 > 0));    % Log of PSD
coeff2 = polyfit(logF2, logPxx2, 1);  % Fit a line and get the slope
slope2 = coeff2(1);

% Noise 3: Pink noise
logF3 = log(f_noise3(f_noise3 > 0));  % Log of frequency (positive values)
logPxx3 = log(dsp3(f_noise3 > 0));    % Log of PSD
coeff3 = polyfit(logF3, logPxx3, 1);  % Fit a line and get the slope
slope3 = coeff3(1);

% Noise 4: Brown noise
logF4 = log(f_noise4(f_noise4 > 0));  % Log of frequency (positive values)
logPxx4 = log(dsp4(f_noise4 > 0));    % Log of PSD
coeff4 = polyfit(logF4, logPxx4, 1);  % Fit a line and get the slope
slope4 = coeff4(1);

% Display the calculated slopes
fprintf('Slope of Colored Gaussian Noise: %.2f\n', slope1);
fprintf('Slope of White Noise: %.2f\n', slope2);
fprintf('Slope of Pink Noise: %.2f\n', slope3);
fprintf('Slope of Brown Noise: %.2f\n', slope4);

% Classify each noise based on the slope
if slope1 >= -0.5 && slope1 <= 0.5
    disp('Colored Gaussian Noise is classified as White Noise');
elseif slope1 > -1.5 && slope1 < -0.5
    disp('Colored Gaussian Noise is classified as Pink Noise');
elseif slope1 < -1.5
    disp('Colored Gaussian Noise is classified as Brown Noise');
end

if slope2 >= -0.5 && slope2 <= 0.5
    disp('White Noise is classified as White Noise');
elseif slope2 > -1.5 && slope2 < -0.5
    disp('White Noise is classified as Pink Noise');
elseif slope2 < -1.5
    disp('White Noise is classified as Brown Noise');
end

if slope3 >= -0.5 && slope3 <= 0.5
    disp('Pink Noise is classified as White Noise');
elseif slope3 > -1.5 && slope3 < -0.5
    disp('Pink Noise is classified as Pink Noise');
elseif slope3 < -1.5
    disp('Pink Noise is classified as Brown Noise');
end

if slope4 >= -0.5 && slope4 <= 0.5
    disp('Brown Noise is classified as White Noise');
elseif slope4 > -1.5 && slope4 < -0.5
    disp('Brown Noise is classified as Pink Noise');
elseif slope4 < -1.5
    disp('Brown Noise is classified as Brown Noise');
end
