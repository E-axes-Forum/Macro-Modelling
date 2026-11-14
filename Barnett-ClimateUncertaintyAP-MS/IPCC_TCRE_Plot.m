% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Clear and Initialize Matlab Session
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
close all
clear all
clc

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

set(0,'defaulttextinterpreter','Latex')
set(0, 'defaultAxesTickLabelInterpreter','Latex'); 
set(0, 'defaultLegendInterpreter','Latex');

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

directory = pwd;

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

color1 = [0    0.4470    0.7410];
color2 = [0.8500    0.3250    0.0980];
color3 = [0.9290    0.6940    0.1250];
color4 = [0.4940    0.1840    0.5560];
color5 = [0.4660    0.6740    0.1880];
color6 = [0.3010    0.7450    0.9330];
color7 = [0.6350    0.0780    0.1840];

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Inputs for TCRE Plot Based on IPCC Report Data
val1 = 0.8;
val2 = 2.5;

x_vals = 0:0.01:2;

ipcc_low = val1*x_vals;
ipcc_high = val2*x_vals;

tcre_alt1 = 0.2*3.67*x_vals; %(Collins et al., 2013)
tcre_alt2 = 0.7*3.67*x_vals; %(Collins et al., 2013)
tcre_alt3 = 0.23*3.67*x_vals; %(Gillett et al., 2013)
tcre_alt4 = 0.66*3.67*x_vals; %(Gillett et al., 2013)
tcre_alt5 = 0.35*3.67*x_vals; % (Matthews et al., 2009; Gillett et al., 2013; Tachiiri et al., 2015; Millar and Friedlingstein, 2018)
tcre_alt6 = 0.41*3.67*x_vals; %  (Matthews et al., 2009; Gillett et al., 2013; Tachiiri et al., 2015; Millar and Friedlingstein, 2018)

scale1 = 1.0;
scale2 = 1.1;

x2 = [x_vals, fliplr(x_vals)];
inBetween = [tcre_alt1, fliplr(tcre_alt2)];


fig = figure; 
h = fill(x2, inBetween, 'r');
set(h,'facealpha',.25)
hold on;

plot(x_vals,tcre_alt1,'k','LineWidth',3,'LineStyle','-')
plot(x_vals,tcre_alt2,'k','LineWidth',3,'LineStyle','-')

ylabel('Temperature change $(^{\circ}C)$')
xlabel('Cumulative carbon emissions (TtC)')
axis([0,2,0,6])
xticks([0 0.5 1.0 1.5 2.0])

legend('IPCC TCRE Range',...
    'Location','northwest')

set(findall(gcf,'type','axes'),'Fontsize',20,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',20,'fontWeight','bold')
set(findall(gcf,'type','legend'),'interpreter','Latex','FontSize',20,'fontWeight','bold')

x0=10;
y0=10;
width=550.*scale1;
height=420.*scale2;
set(gcf,'units','points','position',[x0,y0,width,height])

set(gca,'box','off')
print('../RFSClimate_Submit/IPCCAR5_TCRE','-dpng')
