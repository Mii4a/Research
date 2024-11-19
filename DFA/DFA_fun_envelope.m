function[A,F] = DFA_fun_envelope(data,pts,order)

% -----------------------------------------------------
% DESCRIPTION:
% Function for the DFA analysis.

% INPUTS: 
% data: a one-dimensional data vector.
% pts: sizes of the windows/bins at which to evaluate the fluctuation
% order: (optional) order of the polynomial for the local trend correction.
% if not specified, order == 1;

% OUTPUTS: 
% A: a 2x1 vector. A(1) is the scaling exponent "alpha",
% A(2) the intercept of the log-log regression, useful for plotting (see examples).
% F: A vector of size Nx1 containing the fluctuations corresponding to the
% windows specified in entries in pts.
% -----------------------------------------------------

% Checking the inputs
if nargin == 2
   order = 1; 
end

sz = size(data);
if sz(1)< sz(2)
    data = data';
end

exit = 0;

if min(pts) == order+1
        disp(['WARNING: The smallest window size is ' num2str(min(pts)) '. DFA order is ' num2str(order) '.'])
        disp('This severly affects the estimate of the scaling coefficient')
        disp('(If order == [] (so 1), the corresponding fluctuation is zero.)')
elseif min(pts) < (order+1)
        disp(['ERROR: The smallest window size is ' num2str(min(pts)) '. DFA order is ' num2str(order) ':'])
        disp(['Aborting. The smallest window size should be of ' num2str(order+1) ' points at least.'])
        exit = 1;
end

if exit == 1
    return
end


% DFA
npts = numel(pts);
F = zeros(npts,1);
N = length(data);
disp(N)
[i, j] = size(data);
hil = hilbert(data);
hil_data = abs(hil);
% figure;
% plot(1:500*20, data(1:500*20));
% hold on;
% plot(1:500*20, hil_data(1:500*20), 'LineWidth', 2);
% legend('Alpha wave', 'Envelope')
% ylim([-40 40])

fft_window = N/5; % 4s FFT epoch
ham = hamming(fft_window); %hamming window 
noverlap = fft_window/2; %50% overlap
nwindow = (N-fft_window)/noverlap;
disp(nwindow)

for h = 1:npts
    w = pts(h);
    
    n = floor(N/w);
    Nfloor = n*pts(h);
    D = hil_data;
    y = cumsum(D - mean(D));
    y = y(1:Nfloor);
    bin = 0:w:(Nfloor-1);
    vec = 1:w;
    
    expon = arrayfun(@(j) polyfit(vec',y(bin(j) + vec),order),1:n,'uni',0);
    y_hat = cell2mat(cellfun(@(y) polyval(y,vec),expon,'uni',0));
    F(h) = mean((y - y_hat').^2).^0.5;
    
end

minw = find(log10(pts) >= log10(1000), 1, 'first');
maxw = find(log10(pts) <= log10(10000), 1, 'last');

A = polyfit(log10(pts(minw:maxw)),log10(F(minw:maxw))',1);

end
