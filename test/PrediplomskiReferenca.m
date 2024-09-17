SNR=0
N=128;
sig1=fmlin(N,0.1,0.250);
plot(real(sig1))
title('sig1 Linear frequency modulation');
axis([1 N -1 1]);
xlabel('Time'); ylabel('Real part');

gnsig1=sigmerge(sig1,noisecg(N),SNR);
plot(real(gnsig1))
title('sig1 Linear frequency modulation + gaussian noise');
axis([1 N -1 1]);
xlabel('Time'); ylabel('Real part');

h=tftb_window(61, 'hanning');
[ssig1]=tfrsp((sig1),1:N,N,h);
figure(1)
t=1:1:N;
f=1:1:N;
contour(t,f,ssig1,52 )
title('sig1 Spectrogram');
xlabel('Time'); ylabel('Hz');

