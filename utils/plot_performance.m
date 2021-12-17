function [] = plot_performance()
% PLOT_PERFORMANCE Evaluate timing performance of all solutions and
% plot and save results

[times, function_names] = time_solutions();
bar_figure = figure('Position',[0 0 800 600],'Visible','off');
barObj = bar(categorical(function_names),times,'Horizontal','on','FaceColor','flat');
barAx = barObj.Parent;
grid(barAx,'on')
set(barAx,'XScale','log')
xlim(barAx,[7.5*10^(floor(log10(min(times,[],'all')))-1) 2.5*10^(floor(log10(max(times,[],'all')))+1)]);
xlabel(barAx,'Time [s]')
ylabel(barAx,'Function')
title(barAx,'Timing perfomance of Matlab solutions for AoC 2021','FontSize',16)
legend(barAx,{'Format input','Solve problem'},'Location','southeast')

barObj(1).FaceColor = '#FC766A';
barObj(2).FaceColor = '#5B84B1';

annotation = sprintf('Generated on %s - https://github.com/Kornflex28/Matlab-AoC-2021',datestr(now));
text(barAx,'String',annotation,...
    'Units','normalized','Position',[0.005 .982],...
    'FontSize',7,'FontAngle','italic')

% inferno_cm = inferno();
% color_values = linspace(0.5*min(times,[],'all'),1.5*max(times,[],'all'),size(inferno_cm,1));
% for kbar=1:length(times)
%     [~,closest_ind] = min((abs(color_values-barObj.YData(kbar))));
%     barObj.CData(kbar,:) = inferno_cm(size(inferno_cm,1)-closest_ind+1,:);
% end

dbs = dbstack('-completenames');
path_parts = strsplit(dbs(1).file, filesep);
home_path = strjoin(path_parts(1:end-2), filesep);
save_path = sprintf('%s/figures/performance.png',home_path);
if verLessThan('matlab','9.8')
    saveas(bar_figure,save_path);
else
    exportgraphics(bar_figure,save_path,'Resolution',300);
end
end

