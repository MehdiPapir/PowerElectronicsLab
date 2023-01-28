wc = 2*pi*50;
w = 1i*wc;
s = tf('s');

sogi = @(t) (t*wc)/(t^2 + t*wc + wc^2);
lpf1 = @(t) ((wc)/(t + 2 *wc))^1;
lpf8 = @(t) wc^8/((t+wc)^8+wc^8);

f1 = sogi(s);
f2 = lpf1(s);
f3 = lpf8(s);

bode(f1,f2,f3);
legend('SOGI(s)', 'LPF(s)', 'LPF(s)^8')

disp(sogi(w))
disp(lpf1(w))
disp(lpf8(w))
% ----------------------------------------------------------------
%% Lasy Plot
T1 = @(t) ((t*wc)/(t^2 + wc*t + wc^2))^1;
T2 = @(t) ((t*wc)/(t^2 + wc*t + wc^2))^2;

mag1 = zeros(size(0:1:1000));
phs1 = mag1;
mag2 = mag1;
phs2 = mag1;
for n=0:1:1000
    y = T1(0.01*n*w);
    mag1(n+1) = abs(y);
    phs1(n+1) = angle(y)*180/pi;
    y = T2(0.01*n*w);
    mag2(n+1) = abs(y);
    phs2(n+1) = angle(y)*180/pi;
end

subplot(2,1,1)
    plot(mag1)
    hold on
    plot(mag2)
    hold off
subplot(2,1,2)
    plot(phs1)
    hold on
    plot(phs2)
    hold off