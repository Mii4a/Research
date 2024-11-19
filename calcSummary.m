function [CorrCoef, Mean, Std, Max, Min] = calcSummary(x, varargin)

fx = 'calcSummary';

AlignSummary = [];

unit = 10^2;
punit = 10^3;

Mean = floor(mean(x*unit)')/unit;
Std = floor(std(x*unit)')/unit;
Max = floor(max(x*unit)')/unit;
Min = floor(min(x*unit)')/unit;

yValsize = size(varargin{1}, 2);

%Normal Correlation
switch nargin
    case 1
        [corrR, corrP] = corr(x, 'Type', 'Pearson');

    case 2
        [corrR, corrP] = corr(x, 'Type', 'Pearson');

    case 3
        mat = [varargin{1} x];
        [corrR, corrP] = corr(mat, 'Type', 'Pearson');
        corrR = corrR(yValsize+1:end, 1:yValsize);
        corrP = corrP(yValsize+1:end, 1:yValsize);

end



% Partial Correlation
% switch nargin
%     case 1
% %         [corrR, corrP] = partialcorr(x, 'Type', 'Pearson');
%         [corrR, corrP] = partialcorr(x, 'Type', 'Spearman');
% 
%     case 2
% %         [corrR, corrP] = partialcorr(x, varargin{1}, 'Type', 'Pearson');
%         [corrR, corrP] = partialcorr(x, varargin{1}, 'Type', 'Spearman');
% 
%     case 3
% %         [corrR, corrP] = partialcorr(x, varargin{1}, varargin{2}, 'Type', 'Pearson');
%         [corrR, corrP] = partialcorr(x, varargin{1}, varargin{2}, 'Type', 'Spearman');
%     
% end



q = 0.05;
method = 'pdep';
report = 'yes';
% [FDR, q] = mafdr(corrP);
[h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(corrP, q, method, report);
% [adj_p, h] = bonf_holm(corrP, q);
% disp(h);

% Three Digits after decimal points
corrR = (floor(corrR*unit))/unit;
corrP = (floor(corrP*punit))/punit;
adj_p = (floor(adj_p*punit))/punit;

sizeR = size(corrR, 2);

if sizeR == 1
    AlignSummary = [corrR, adj_p, corrP];
elseif sizeR > 1
    for ii = 1:sizeR
        AlignSummary = horzcat(AlignSummary, [corrR(:, ii) adj_p(:, ii) corrP(:, ii)]);
    end
end

disp(AlignSummary)
CorrCoef = AlignSummary;