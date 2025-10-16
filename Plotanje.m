clc; clear;

clear; clc; close all;

N = 1024;

p1 = [1, 0];        
p2 = [N/2, 0.25];   
p3 = [N, 0.4];     

sig1 = amgauss(N,N/2,30);


sig1 = sig1 ./ max(abs(sig1));

SNR = 0;
sig1n = sigmerge(sig1, noisecg(N), SNR);

h = tftb_window(61, 'hanning');
[tfr, ~, ~] = tfrsp(sig1n, 1:N, N, h);  

tfr = abs(tfr);
tfr = tfr ./ max(tfr(:));

f = linspace(0, 0.5, N/2 + 1);
tfr_pos = tfr(1:N/2+1, :); 

figure('Units','normalized','Position',[0.1 0.2 0.8 0.6]);
contour(1:N, f, tfr_pos, 50, 'LineWidth', 1);
colormap(jet);
colorbar;
xlabel('Time [samples]');
ylabel('Normalized frequency');
title('Normalized Spectrogram of fmpar Signal');
axis tight;
