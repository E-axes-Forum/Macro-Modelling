% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % Baseline Comparison Figures Code
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
close all
clear all
clc

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % Set-up Figures and Filename
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
set(0,'defaulttextinterpreter','tex')
set(0, 'defaultAxesTickLabelInterpreter','tex'); 
set(0, 'defaultLegendInterpreter','tex');



directory = pwd;
filename = [directory, '\CCAP_HJB_Baseline'];

filenameUno = [directory, '\CCAP_HJB_Baseline_No_T_Uncertainty'];
load([filenameUno,'_Sims.mat']);
filenameDos = [directory, '\CCAP_HJB_Baseline_T_Uncertainty'];
B=load([filenameDos,'_Sims.mat']);

filenameA = [filename,'_Sims_Comp'];



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % Initialize and Format
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
initial_time = 2020;
time_vec = linspace(initial_time+0,initial_time+T/4,T);


color1 = [0    0.4470    0.7410];
color2 = [0.8500    0.3250    0.0980];
color3 = [0.9290    0.6940    0.1250];
color4 = [0.4940    0.1840    0.5560];
color5 = [0.4660    0.6740    0.1880];
color6 = [0.3010    0.7450    0.9330];
color7 = [0.6350    0.0780    0.1840];



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % Figures
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

figure
plot(time_vec,Tp_iters,'Color',color2,'LineWidth',3,'LineStyle','-', 'DisplayName', sprintf('$\\varrho_T = \\infty$',varrho));
hold on
plot(time_vec,B.Tp_iters,'Color',color2,'LineWidth',3,'LineStyle','-.', 'DisplayName', sprintf('$\\varrho_T = %0.2f$',B.varrho));
% title('Temperature')
ylabel('T_t')
xlabel('Year')
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
hl = legend('show');
set(hl, 'Interpreter', 'latex', 'Location', 'northwest');
axis([initial_time,2100,0,2.5])
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
print('ccap_temp','-dpng')

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

figure
plot(time_vec,Op_iters,'-k','LineWidth',3, 'DisplayName', sprintf('$B_t, \\varrho_T = \\infty$',varrho));
hold on
plot(time_vec,B.Op_iters,'-.k','LineWidth',3, 'DisplayName', sprintf('$B_t, \\varrho_T = %0.2f$',B.varrho));
plot(time_vec,Gp_iters,'Color',color5,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('$G_t, \\varrho_T = \\infty$',varrho));
plot(time_vec,B.Gp_iters,'Color',color5,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('$G_t, \\varrho_T = %0.2f$',B.varrho));
% title('Input Production')
ylabel('B_t, G_t')
xlabel('Year')
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
hl = legend('show');
set(hl, 'Interpreter', 'latex', 'Location', 'northeast');
axis([initial_time,2100,0,2.5])
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
print('ccap_input','-dpng')

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 


total_energy = Op_iters+Gp_iters;
B.total_energy = B.Op_iters+B.Gp_iters;

figure
plot(time_vec,Op_iters./total_energy,'-k','LineWidth',3, 'DisplayName', sprintf('Dirty, $\\varrho_T = \\infty$',varrho));
hold on
plot(time_vec,B.Op_iters./B.total_energy,'-.k','LineWidth',3, 'DisplayName', sprintf('Dirty, $\\varrho_T = %0.2f$',B.varrho));
plot(time_vec,Gp_iters./total_energy,'Color',color5,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Clean, $\\varrho_T = \\infty$',varrho));
hold on
plot(time_vec,B.Gp_iters./B.total_energy,'Color',color5,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Clean, $\\varrho_T = %0.2f$',B.varrho));
% title('Input Fraction')
ylabel('Percent')
xlabel('Year')
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
hl = legend('show');
set(hl, 'Interpreter', 'latex', 'Location', 'northeast');
axis([initial_time,2100,0,1.2])
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
print('ccap_input_fraction','-dpng')

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 


figure
plot(time_vec,tax_iters,'-k','LineWidth',3, 'DisplayName', sprintf('$\\varrho_T = \\infty$',varrho));
hold on
plot(time_vec,B.tax_iters,'-.k','LineWidth',3, 'DisplayName', sprintf('$\\varrho_T = %0.2f$',B.varrho));
% title('Carbon Tax')
% ylabel('\tau_t')
ylabel('Percent')
xlabel('Year')
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
hl = legend('show');
set(hl, 'Interpreter', 'latex', 'Location', 'northwest');
axis([initial_time,2100,0,0.55])
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
print('ccap_tax','-dpng')

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

figure
plot(time_vec,probb2_iters,'-k','LineWidth',3, 'DisplayName', sprintf('$\\varrho_T = \\infty$',varrho));
hold on
plot(time_vec,B.probb2_iters,'-.k','LineWidth',3, 'DisplayName', sprintf('$\\varrho_T = %0.2f$',B.varrho));
% title('Error Detection Probability')
ylabel('\epsilon_t')
xlabel('Year')
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
hl = legend('show');
set(hl, 'Interpreter', 'latex', 'Location', 'northeast');
axis([initial_time,2100,0,0.5])
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
print('ccap_probb','-dpng')
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

figure
plot(time_vec,MPR_iters,'Color',color1,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Total, $\\varrho_T = \\infty$',varrho));
hold on
plot(time_vec,B.MPR_iters,'Color',color1,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Total, $\\varrho_T = %0.2f$',B.varrho));
plot(time_vec,MPR_T_iters+MPR_Gamma_iters,'Color',color2,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Climate, $\\varrho_T = \\infty$',varrho));
plot(time_vec,B.MPR_T_iters+B.MPR_Gamma_iters,'Color',color2,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Climate, $\\varrho_T = %0.2f$',B.varrho));
% title('Risk and Uncertainty Prices')
ylabel('Prices')
xlabel('Year')
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
hl = legend('show');
set(hl, 'Interpreter', 'latex', 'Location', 'northeast');
axis([initial_time,2100,-0.1,0.4])
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
print('ccap_mpr','-dpng')

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

figure
plot(time_vec,zeros(size(Tp_iters)).*(MPR_T_iters+MPR_Gamma_iters),'Color',color2,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Climate, $\\varrho_T = \\infty$',B.varrho));
hold on
plot(time_vec,B.MPU_T_iters+B.MPU_Gamma_iters,'Color',color2,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Climate, $\\varrho_T = %0.2f$',B.varrho));
plot(time_vec,B.MPU_T_iters,'Color',color3,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Temperature, $\\varrho_T = %0.2f$',B.varrho));
plot(time_vec,B.MPU_Gamma_iters,'Color',color7,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Damages, $\\varrho_T = %0.2f$',B.varrho));
% title('Climate Uncertainty Prices')
ylabel('Prices')
xlabel('Year')
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
hl = legend('show');
set(hl, 'Interpreter', 'latex', 'Location', 'northeast');
axis([initial_time,2100,-0.03,0.02])
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
print('ccap_mpu','-dpng')

