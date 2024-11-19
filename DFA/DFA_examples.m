% DFA of order 1
% A(1) is approximately 0.5. Indeed Y is an uncorrelated process.
% A = [];
% F = [];
% E = extfreq(EEG.data(12, :), [8, 13]);
% pts = fix(logspace(2, log10(length(E)), 1000));
% 
% % 
% [A,F] = DFA_fun_envelope(E,pts, 1);
% disp(A)
% % disp(F)
% 
% 

minf = 0.5;
maxf = 60;
Fs = 500;
cycle = (minf/2);

FilterOrder = Fs/(cycle);

% if 2/minf >= 1
%     FilterOrder = Fs;d
% end
bpFilt = designfilt('bandpassfir', 'FilterOrder', Fs*(2/minf), ...
    'CutoffFrequency1', minf, 'CutoffFrequency2', maxf, ...
    'Window', 'hamming', 'SampleRate', Fs);

% Fn = Fs/2;
% [b, a] = butter(3, [0.5 60]/Fn);

A = [];
F = [];
% 
N = 10000;
for ii = 1:10
    ham = hamming(N);
    E_rand = (rand(1,N))*20*6;
%     E = highpass(E, 3, Fs, 'ImpulseResponse','fir');
%     E = lowpass(E, maxf, Fs, 'ImpulseResponse','fir');
    E = filter(bpFilt, E_rand);
%     E = filtfilt(bpFilt, E_rand);
%     E = bandpass((rand(1,N)-0.5)*40*2, [0.5, maxf], Fs, 'ImpulseResponse', 'fir', 'Steepness', [0.1 0.5]);
%     hil_E = abs(hilbert(E(2000:end)));
%     cum_E = cumsum(E-mean(E));
    % figure;
    % plot(1:Fs*5, E(1:Fs*5));
    % hold on;
    % plot(1:Fs*5, hil_E(1:Fs*5));
    % hold on;
    % ylim([-40 40]);
    % % plot(1:Fs*5, cum_E(1:Fs*5))
    % rz
    As = [];
    pts = fix(logspace(log10(4), log10(N), 100));
    % pts = fix(linspace(4, N, 100));
    [A(ii, :), F(:, ii)] = DFA_fun_envelope(E,pts);
    disp(A(ii, :));
end
As = mean(A);
disp(As)
wvtool(E(1:end))


% c = 6;
% minf = 0.5;
% maxf = 60;
% Fs = EEG.srate;
% Datalen = 20;
% E = EEG.data(c, :, 1);
% ori = EEG.data(c,:,1);
% 
% E_EEG= filter(bpFilt, double(ori));
% [A(ii+1, :), F(:, ii+1)] = DFA_fun_envelope(E_EEG, pts);
% disp(A)


plot_fun = @(xp,A,ord) polyval(A,log10(xp));
e = ii;
figure
scatter(log10(pts),log10(F(:, e)))
hold on
x = 4:10:N;
plot(log10(x),plot_fun(x,A(e, :)),'--')
hold off
ylim([0 3])
alpha = num2str(A(e, :));
mes = append("alpha is ", alpha);
title(mes)


%%