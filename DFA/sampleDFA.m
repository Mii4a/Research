plot_fun = @(xp,A,ord) polyval(A,log(xp));

addpath(genpath('../data'))
d = importdata('bepputest_heigan.m01');
x = d.data(500*10+1:500*120, 1:8);
y = x';
[i, j] = size(y);

for ii = 1:i+1
    subplot(i+1, 1, ii);
    
    if ii == i+1
        plot(1:length(y), y);
    else
        plot(1:length(y), y(ii, :));
    end
    hold off;
end

pts = 50:10:100;
x = d.data(500*10+1:500*120, 1);
[a,F] = DFA_fun(x,pts);
a(1)

figure
scatter(log(pts),log(F))
hold on
X = 1:2000:length(x);
plot(log(X),plot_fun(X,a),'--')
