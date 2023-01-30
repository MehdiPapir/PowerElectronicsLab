
w  = 2*pi*50;
s  = tf('s');
k  = 0.1;

w1 = (1-k)*w;
w2 = (1+k)*w;

jw = 1i*w;

MPFn = @(t, n) ( (w1*t)  / (t^2 + (w1+w2)*t + w1*w2) )^n;

MPF1 = MPFn(jw, 1);
A  = abs(MPF1)
P  = angle(MPF1)

bode(MPFn(s, 1))