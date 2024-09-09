N=128;
sig1=fmlin(N,0.1,0.250);
plot(real(sig1))
title('sig1 Linear frequency modulation');
axis([1 N -1 1]);
xlabel('Time'); ylabel('Real part');