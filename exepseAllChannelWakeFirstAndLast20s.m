files = dir("./dataset_RK/*icacomp.set");
files_name = {files.name};
files_name_head_num = find(files_name == "s2_RK_epochs_rejection_icacomp.set");
files_name_alined = [files_name(files_name_head_num:end) files_name(1:files_name_head_num-1)];
files_name_string = convertStringsToChars(files_name_alined);
files_name_string(6) = [];
files_size = size(files_name_string, 2);

pse_size = 4;


chs = ["fp1", "fp2",  ...
       "f3", "f4", "f7", "f8", "fz"...
       "t3", "t4", "t5", "t6", ...
       "c3", "c4", "cz" ...
       "p3", "p4", "pz" ...
       "o1", "o2" ...
       ];

chs_n = size(chs, 2);
pse_first = [];
pse_first_table = [];
pse_last = [];
pse_last_table = [];
specf = [[0.5, 3.9]; [4, 7.9]; [8, 12.9]; [13, 29.9]; [30 60]; [0.5, 60]];
A = [];
F = [];

minf = 0.5;
maxf = 60;
FreqRate = 500;
cycle = minf/2;
FilterOrder = FreqRate/cycle;

bpFilt = designfilt('bandpassfir', 'FilterOrder', FilterOrder, ...
    'CutoffFrequency1', minf, 'CutoffFrequency2', maxf, ...
    'Window', 'hamming', 'SampleRate', FreqRate);

save_dir = "./dataset_RK/";
save_csv = append(save_dir, 'pse_result_Wake_First.csv');

for ii = 17
    num = zeros(1); 
    EEG_wakedata = [];
    EEG_wakedatabase = [];
    EEG_wakedatafilt = [];
    E = [];
    pow_first = [];
    se_first = [];
    pow_last = [];
    se_last = [];


    path = append('./dataset_RK/', files_name_string(ii));
    EEG = pop_loadset(path);
    
    Fs = EEG.srate;
    EEG_event = EEG.event;
    j = length(EEG_event);

    for s = 1:size(EEG.data, 1)
        EEG_wakedatafilt(s, :, :) = filter(bpFilt, EEG.data(s, :, :));
    end

    for jj = 1:j
         if ischar(EEG_event(jj).type) == 1
            EEG_event(jj).type = str2double(EEG_event(jj).type);
         end

         if EEG_event(jj).type == 102 && num == 0
            num = jj;
            EEG_wakedata = EEG_wakedatafilt(:, :, 1:num-1);
%             EEG_wakedata = EEG.data(:, :, 1:num-1);
%             EEG_wakedata = filter(bpFilt, EEG.data(:, :, 1:num-1));
            E = EEG_event(1:num-1);
         end
    end

%         specEpoch = size(EEG_wakedata, 3);
    specEpoch = 1;

    for f = 1:length(specf)
        xpsd = [];
        disp(EEG.filename)
        for c = 1:chs_n
            %calc index
            [pow_first(f, c, ii), xpsd(f, :, ii)] = calcpRegion(EEG_wakedata(:, :, specEpoch), chs(1, c), specf(f, :), Fs);
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
                [se_first(f, c, ii), A(f, :, ii), F(f, :, ii), pts] = calcseRegion(EEG_wakedata(:, :, specEpoch), chs(1, c), specf(f, :), Fs);
            end
        end
    end    

    pse_first(ii).delta_pow = pow_first(1, :, ii);
    %     pse_first(ii).delta_dfa = se_first(1, :, ii);
    pse_first(ii).delta_dfa = zeros(1, 19);
    pse_first(ii).theta_pow = pow_first(2, :, ii);
    %     pse_first(ii).theta_dfa = se_first(2, :, ii);
    pse_first(ii).theta_dfa = zeros(1, 19);
    pse_first(ii).alpha_pow = pow_first(3, :, ii);
    %     pse_first(ii).alpha_dfa = se_first(3, :, ii);
    pse_first(ii).alpha_dfa = zeros(1, 19);
    pse_first(ii).beta_pow = pow_first(4, :, ii);
    %     pse_first(ii).beta_dfa = se_first(4, :, ii);
    pse_first(ii).beta_dfa = zeros(1, 19);
    pse_first(ii).gamma_pow = pow_first(5, :, ii);
    %     pse_first(ii).gamma_dfa = se_first(5, :, ii);
    pse_first(ii).gamma_dfa = zeros(1, 19);
    pse_first(ii).whole_pow = pow_first(6, :, ii);
    pse_first(ii).whole_dfa = se_first(6, :, ii);

%     pse_last(ii).alpha_pow = pow_last(1, :, ii);
%     pse_last(ii).alpha_dfa = se_last(1, :, ii);
%     pse_last(ii).theta_pow = pow_last(2, :, ii);
%     pse_last(ii).theta_dfa = se_last(2, :, ii);


end

pse_first_table = struct2table(pse_first);
writetable(pse_first_table, save_csv);

cpow = pse_first(ii).delta_pow(:, 12:14);
cdfa = pse_first(ii).whole_dfa(:, 12:14);
disp(cpow);
disp(cdfa);



% pse_last_table = struct2table(pse_first);
% csv_last = append(path, 'pse_result_Wake_Last.csv');
% writetable(pse_last_table, csv_last);

