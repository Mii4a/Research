files = dir("./dataset_RK/*icacomp.set");
files_name = {files.name};
files_name_head_num = find(files_name == "s2_RK_epochs_rejection_icacomp.set");
files_name_alined = [files_name(files_name_head_num:end) files_name(1:files_name_head_num-1)];
files_name_string = convertStringsToChars(files_name_alined);
files_name_string(6) = [];
files_size = size(files_name_string, 2);


pse_size = 4;
chs = {'fp1', 'fp2',  ...
    'f3', 'f4', 'f7', 'f8', 'fz'...
    't3', 't4', 't5', 't6', ...
    'c3', 'c4', 'cz' ...
    'p3', 'p4', 'pz' ...
    'o1', 'o2' ...
    };

Datalen = 20;
chs_n = size(chs, 2);
pse = struct;
pse_table = [];
specf = [[0.5, 3.9]; [4, 7.9]; [8, 12.9]; [13, 29.9]; [30 60]; [0.5, 60]];
fbandStr = {'δ', ... 
           'θ', ...
           'α', ...
           'β', ...
           'γ', ...
           'Whole Frequency'
          };

dirpath = 'D:/KIOXIA/Experiment/睡眠/統計分析/';
fbandDir = {'δ_index/', ... 
           'θ_index/', ...
           'α_index/', ...
           'β_index/', ...
           'γ_index/', ...
           'Whole_freq_index/'
          };
psdFigDir = 'PSD_wake/';
dfaFigDir = 'DFA_wake/';
psdSavePath = append(dirpath, fbandDir, psdFigDir);
dfaSavePath = append(dirpath, fbandDir, dfaFigDir);

plot_fun = @(xp,A,ord) polyval(A,log10(xp));

for ii = 2
    num = zeros(1);
    EEG_wakedata = [];
    E = [];
    pow = [];
    se = [];
    A = [];

    path = append('./dataset_RK/', files_name_string(ii));
    EEG = pop_loadset(path);
    Fs = EEG.srate;
    EEG_event = EEG.event;
    j = length(EEG_event);
    freq = 0:Fs/(Datalen*Fs):Fs/2;
    disp(ii);
    disp(files_name_string(ii));

    for jj = 1:j
        if ischar(EEG_event(jj).type) == 1
            EEG_event(jj).type = str2double(EEG_event(jj).type);
        end
        if EEG_event(jj).type == 102 && num == 0
            num = jj;
            EEG_wakedata = EEG.data(:, :, 1:num-1);
            E = EEG_event(1:num-1);
        end
    end

    for f = 1:length(specf)
%     for f = 1:length(specf)
        disp(specf(f, :))
        xpsd = [];
        
        for c = 1:chs_n
            disp(chs(1, c))
            %calc index
            [pow(f, c, ii), xpsd(f, :, ii)] = calcpRegion(EEG_wakedata(:,:,2), chs(1, c), specf(f, :), Fs);
%             [se(f, c, ii), A(f, :, ii), F(f, :, ii), pts] = calcseRegion(EEG_wakedata, chs(1, c), specf(f, :), Fs);
%             seAlpha1(f, c, ii) = A(f, 1, ii);
%             seAlpha2(f, c, ii) = A(f, 2, ii);
            if f == 1
                deltaPsd(c, :, ii) = xpsd(f, :, ii);
%                 deltaFlac(c, :, ii) = F(f, :, ii);
            elseif f==2
                thetaPsd(c, :, ii) = xpsd(f, :, ii);
%                 thetaFlac(c, :, ii) = F(f, :, ii);
            elseif f==3
                alphaPsd(c, :, ii) = xpsd(f, :, ii);
%                 alphaFlac(c, :, ii) = F(f, :, ii);
            elseif f==4
                betaPsd(c, :, ii) = xpsd(f, :, ii);
%                 betaFlac(c, :, ii) = F(f, :, ii);
            elseif f==5
                gammaPsd(c, :, ii) = xpsd(f, :, ii);
%                 gammaFlac(c, :, ii) = F(f, :, ii);
            elseif f==6
                wholePsd(c, :, ii) = xpsd(f, :, ii);
%                 wholeFlac(c, :, ii) = F(f, :, ii);
                [se(f, c, ii), A(f, :, ii), F(f, :, ii), pts] = calcseRegion(EEG_wakedata, chs(1, c), specf(f, :), Fs);
            end
        end
    end
    disp(pow(:,:,ii));
    disp(se(:,:,ii));

        pse_first(ii).delta_pow = pow(1, :, ii);
%     pse_first(ii).delta_dfa = se_first(1, :, ii);
    pse_first(ii).theta_pow = pow(2, :, ii);
%     pse_first(ii).theta_dfa = se_first(2, :, ii);
    pse_first(ii).alpha_pow = pow(3, :, ii);
%     pse_first(ii).alpha_dfa = se_first(3, :, ii);
    pse_first(ii).beta_pow = pow(4, :, ii);
%     pse_first(ii).beta_dfa = se_first(4, :, ii);
    pse_first(ii).gamma_pow = pow(5, :, ii);
%     pse_first(ii).gamma_dfa = se_first(5, :, ii);
    pse_first(ii).whole_pow = pow(6, :, ii);
    pse_first(ii).whole_dfa = se(6, :, ii);


%     pse(ii).delta_pow = pow(1, :, ii);
%     pse(ii).delta_dfa = se(1, :, ii);
%     pse(ii).theta_pow = pow(2, :, ii);
%     pse(ii).theta_dfa = se(2, :, ii);
%     pse(ii).alpha_pow = pow(3, :, ii);
%     pse(ii).alpha_dfa = se(3, :, ii);
%     pse(ii).beta_pow = pow(4, :, ii);
%     pse(ii).beta_dfa = se(4, :, ii);
%     pse(ii).gamma_pow = pow(5, :, ii);
%     pse(ii).gamma_dfa = se(5, :, ii);
%     pse(ii).all_pow = pow(6, :, ii);
%     pse(ii).all_dfa = se(6, :, ii);
end

% aveDeltaPsd = mean(deltaPsd, 3);
% aveThetaPsd = mean(thetaPsd, 3);
% aveAlphaPsd = mean(alphaPsd, 3);
% aveBetaPsd = mean(betaPsd, 3);
% aveGammaPsd = mean(gammaPsd, 3);
% aveWholePsd = mean(wholePsd, 3);
% 
% aveSeAlpha1 = mean(seAlpha1, 3);
% aveSeAlpha2 = mean(seAlpha2, 3);
% 
% aveDeltaFluc = mean(deltaFlac, 3);
% aveThetaFluc = mean(thetaFlac, 3);
% aveAlphaFluc = mean(alphaFlac, 3);
% aveBetaFluc = mean(betaFlac, 3);
% aveGammaFluc = mean(gammaFlac, 3);
% aveWholeFluc = mean(wholeFlac, 3);

% for f = 1:length(specf)
%     minf = specf(f, 1);
%     maxf = specf(f, 2);
%     mini = find(freq < minf, 1, 'last')+1;
%     maxi = find(freq < maxf, 1, 'last')+1;
%     
%     if f == 1
%         avePsd = aveDeltaPsd;
%         aveFluc = aveDeltaFluc;
%     elseif f==2
%         avePsd = aveThetaPsd;
%         aveFluc = aveThetaFluc;
%     elseif f==3
%         avePsd = aveAlphaPsd;
%         aveFluc = aveAlphaFluc;
%     elseif f==4
%         avePsd = aveBetaPsd;
%         aveFluc = aveBetaFluc;
%     elseif f==5
%         avePsd = aveGammaPsd;
%         aveFluc = aveGammaFluc;
%     elseif f==6
%         avePsd = aveWholePsd;
%         aveFluc = aveWholeFluc;
%     end
% 
%     for c = 1:chs_n
% 
%         %PSD filepath
%         chStr = cell2mat(chs(1, c));
%         chStr(1) = upper(chStr(1));
%         figFile = append('PSD(', chStr, ', ', fbandStr(f), ').png');
%         saveFile = append(psdSavePath(f), figFile);
%         disp(saveFile)
% 
%         %PSD figsave
%         figure(1)
%         plot(freq(mini:maxi), avePsd(c, :), 'Color', 'black');
%         grid on
%         xlim([minf, maxf]);
%         yPsdMax = max(max(avePsd(:,:)));
%         yPsdMaxDiff = round(yPsdMax, 1) - yPsdMax; 
%         if  yPsdMaxDiff <= 0
%             yPsdLimMax = round(yPsdMax) + 0.5;
%         elseif yPsdMaxDiff <= 0.25 && yPsdMaxDiff > 0
%             yPsdLimMax = round(yPsdMax) + 0.5;
%         else
%             yPsdLimMax = round(yPsdMax);
%         end
%         ylim([0, yPsdLimMax])
%         title_name = append(num2str(minf), "-", num2str(maxf), " Hz PSD on ", chStr);
%         title(title_name);
%         xlabel('Frequency (Hz)');
%         ylabel('log10 PSD(μV^2/Hz)');
%         fontsize(gcf, 24, 'pixels')
%         saveas(gcf, string(saveFile))
%         close
% 
%         %DFA filepath
%         figFile = append('DFA scaling exponent(', chStr, ', ', fbandStr(f), ').png');
%         saveFile = append(dfaSavePath(f), figFile);
%         disp(saveFile)
% 
%         %DFA figsave
%         figure(2)
%         scatter(log10(pts),log10(aveFluc(c, :)'), 'black');
%         hold on;
%         x = 4:10:10000;
%         plot(log10(x), plot_fun(x,[aveSeAlpha1(f, c), aveSeAlpha2(f, c)]),'r-', 'Color', 'black')
%         hold off
%         yDfaMax = max(max(log10(aveFluc)));
%         yDfaMaxDiff = round(yDfaMax, 1) - yDfaMax;
%         
%         if  yDfaMaxDiff <= 0
%             yDfaLimMax = round(yDfaMax) + 0.5;
%         elseif yDfaMaxDiff <= 0.25 && yDfaMaxDiff > 0
%             yDfaLimMax = round(yDfaMax) + 0.5;
%         else
%             yDfaLimMax = round(yDfaMax);
%         end
%         ylim([-2, yDfaLimMax]);
%         Title = append(num2str(minf), "-", num2str(maxf), " Hz DFA scaling exponent on ", chStr);
%         title(Title);
%         ylabel("log10(F(t))")
%         xlabel("log10(time window)")
%         annoX = [0.4 0.4];
%         annoY = [0.8, 0.65];
%         annoStr = append('α = ', num2str(aveSeAlpha1(f, c), '%.2f'));
%         annotation('textarrow', annoX, annoY, 'String', annoStr);
%         fontsize(gcf, 24, 'pixels')
%         saveas(gcf, string(saveFile))
%         close
%         
%     end
% end


pse_table = struct2table(pse);
path = "./dataset_RK/";
file_name = append(path, 'pse_result_Wake.csv');
writetable(pse_table, file_name);
disp(files_name_string(ii))