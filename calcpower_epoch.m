function [s_power, psd] = calcpower_epoch(EEG_data, Ch, specf, Fs)
% %----------%
% Output: [s_power, pxx] = calc_power_epoch(EEG, Ch, specf, Fs)

%         s_power: The power summed with EEG data of decided frequencies [e.g. alpha wave [8, 13]].
%                  Y axis is a channel_num. X axis is an epoch_num.

%         pxx: The power of each frequency that you decide.
%              Y axis is a voltage. X axis is freq_num.
%----------%

Chlabels = ["fp1", "fp2", "f3", "f4", "c3", "c4", ...
            "p3", "p4", "o1", "o2", "f7", "f8", ...
            "t3", "t4", "t5", "t6", ...
            "pg1", "fz", "cz", "pz", "pg2", "a1", "a2", "x5-x6", "DC25"];

disp(length(Chlabels));

%入力されたChに合致するデータをxに代入
x=[];

for ii = 1:length(Chlabels)
   if  any(strcmp(Ch, Chlabels(ii)))
       x = vertcat(x, EEG_data(ii, :, :));
   end
end
[chs, N, epochs] = size(x);



%freq periodogram
% ham = hamming(N);
% freq = 0:Fs/N:Fs/2;

%freq welch
fft_window = N/5; % 4s FFT epoch
ham = hamming(fft_window); %hamming window 
noverlap = fft_window/2; %50% overlap
freq = 0:Fs/fft_window:Fs/2;

minf = specf(1);
maxf = specf(2);
mini = find(freq < minf, 1, 'last')+1;
maxi = find(freq < maxf, 1, 'last')+1;

s_power = zeros(chs, epochs);
psd = zeros(chs, maxi-mini+1, epochs);
xpsd = zeros(chs, length(freq), epochs);


for c = 1:chs
  for e = 1:epochs
      %periodogram
%     xdft = fft(x(c, :, e).*ham');
%     xdft = xdft(1:N/2+1);
%     xpsd(c, :, e) = (abs(xdft).^2)*(1/(N*Fs));
%     xpsd(c, 2:end-1, e) = 2*xpsd(c, 2:end-1, e);
      
      %pwelch
      [pxx, f] = pwelch(x(c, :, e), ham, noverlap, fft_window, Fs);
      xpsd(c, :, e) = pxx';
      
      s_power(c, e) = log10(sum((xpsd(c, mini:maxi, e))));
% %     s_power(c, e) = mean((xpsd(c, mini:maxi, e)));
      psd(c, :, e) = xpsd(c, mini:maxi, e);

  end
end


% 
% figure()
% plot(freq(mini:maxi),xpsd(1, mini:maxi, 1))
% grid on
% xlim([minf, maxf]);
% title_name = num2str(minf) + "-" + num2str(maxf) + "Hz PSD";
% title(title_name);
% xlabel('Frequency (Hz)');
% ylabel('log10(PSD)');



% figure()
% plot(freq(mini:maxi),xpsd(1, mini:maxi, 1))
% grid on
% xlim([minf, maxf]);
% title('Periodgram Using FFT');
% xlabel('Frequency (Hz)');
% ylabel('PSD (mV)')
% % 
% % figure()
% plot(1:epochs,s_power(1, :));
% xlim([1, epochs])
% grid on
% title('Periodgram Using FFT');
% xlabel('epoch');
% ylabel('PSD')
% 
% 
% figure()
% plot(1:epochs,s_power(1, :));
% xlim([1, epochs])
% grid on
% title_name = num2str(minf) + "-" + num2str(maxf) + "Hz PSD";
% title(title_name);
% xlabel('epoch');
% ylabel('log10(PSD)')