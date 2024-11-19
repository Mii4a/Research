function [pow] = calcpLeftRight(EEG, Fs)

specf = [[8 13];[4 7];];
fbands = size(specf, 1);

regions = [["fp1" "f7" "c3" "o1" "p3" "t3"];["fp2" "f8" "c4" "o2" "p4" "t4"];];
[r_len, ch_len] = size(regions);

% file_num = 3;
% 
% file_name = "s" + num2str(file_num) + "_epoch_rejection_ica.set";
% file_url = "./data/" + file_name;
% pop_loadset(file_url)

pow = [];

for f = 1:fbands
    for r = 1:r_len
        [pow(f, r)] = calcpRegion(EEG, regions(r, :), specf(f, :), Fs);
    end
end
