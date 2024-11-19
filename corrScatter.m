function corrScatter(x, y, ...
                     xLabel, yLabel, ...
                     xLim, yLim, ...
                     corrR, corrP, ...
                     savePath, ...
                     xTicks, ...
                     yTicks)

arguments
    x
    y
    xLabel
    yLabel
    xLim,
    yLim,
    corrR,
    corrP,
    savePath,
    xTicks = xLim(1):xLim(2);
    yTicks = yLim(1):yLim(2);
end

scatter(x, y, 40, 'black', 'LineWidth', 2);
D = lsline;
D.LineWidth = 2;
set(D, 'color', 'black')

if corrP > 0.05 && corrP <= 0.1
    pStr = '+';
elseif corrP >= 0.01 && corrP < 0.05
    pStr = '*';
elseif corrP < 0.01
    pStr = '**';
else
    pStr = '';
end
rStr = compose('%.2f', string(round(corrR, 2)));
annoStr = append('r = ', rStr, pStr);
dim = [.14 .62 .3 .3];
annotation('textbox', dim, 'String', annoStr, 'FitBoxToText', 'on', 'EdgeColor', 'none');
% textX = xTicks(end);
% textY = yTicks(end);

xlabel(xLabel)
ylabel(yLabel)
% text(textX, textY, annoStr);
xlim(xLim)
ylim(yLim)
xticks(xTicks)
yticks(yTicks)
xtickformat('%.1f')
ytickformat('%.1f')
fontsize(gcf, 24, "pixels");
saveas(gcf, char(savePath))
clf