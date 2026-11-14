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
filename = [directory, '\CCAP_HJB_T_Uncertainty_Omega'];

% % Only macro impacts, but not asset pricing...
filenameUno = [directory, '\CCAP_HJB_T_Uncertainty_Omega0pt25'];
load([filenameUno,'_Sims.mat']);
filenameDos = [directory, '\CCAP_HJB_Baseline_T_Uncertainty'];
B=load([filenameDos,'_Sims.mat']);
filenameTres = [directory, '\CCAP_HJB_T_Uncertainty_Omega0pt85'];
C=load([filenameTres,'_Sims.mat']);

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

figure
plot(time_vec,Tp_iters,'Color',color2,'LineWidth',3,'LineStyle','-', 'DisplayName', sprintf('$\\omega = %0.2f$',eps));
hold on
% plot(time_vec,B.Tp_iters,'Color',color2,'LineWidth',3,'LineStyle','-.', 'DisplayName', sprintf('$\\omega = %0.2f$',B.eps));
% title('Temperature')
plot(time_vec,C.Tp_iters,'Color',color2,'LineWidth',3,'LineStyle',':', 'DisplayName', sprintf('$\\omega = %0.2f$',C.eps));
ylabel('T_t')
xlabel('Year')
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
hl = legend('show');
set(hl, 'Interpreter', 'latex', 'Location', 'northwest');
axis([initial_time,2100,0,2.5])
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
print('ccap_temp_omega','-dpng')


figure
plot(time_vec,Op_iters,'-k','LineWidth',3, 'DisplayName', sprintf('$B_t, \\omega = %0.2f$',eps));
hold on
% plot(time_vec,B.Op_iters,'-.k','LineWidth',3, 'DisplayName', sprintf('$B_t, \\omega = %0.2f$',B.eps));
plot(time_vec,C.Op_iters,':k','LineWidth',3, 'DisplayName', sprintf('$B_t, \\omega = %0.2f$',C.eps));
plot(time_vec,Gp_iters,'Color',color5,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('$G_t, \\omega = %0.2f$',eps));
% hold on
% plot(time_vec,B.Gp_iters,'Color',color5,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('$G_t, \\omega = %0.2f$',B.eps));
plot(time_vec,C.Gp_iters,'Color',color5,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('$G_t, \\omega = %0.2f$',C.eps));
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
print('ccap_input_omega','-dpng')

total_energy = Op_iters+Gp_iters;
B.total_energy = B.Op_iters+B.Gp_iters;
C.total_energy = C.Op_iters+C.Gp_iters;


figure
plot(time_vec,Op_iters./total_energy,'-k','LineWidth',3, 'DisplayName', sprintf('Dirty, $\\omega = %0.2f$',eps));
hold on
% plot(time_vec,B.Op_iters./B.total_energy,'-.k','LineWidth',3, 'DisplayName', sprintf('Dirty, $\\omega = %0.2f$',B.eps));
plot(time_vec,C.Op_iters./C.total_energy,':k','LineWidth',3, 'DisplayName', sprintf('Dirty, $\\omega = %0.2f$',C.eps));
plot(time_vec,Gp_iters./total_energy,'Color',color5,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Clean, $\\omega = %0.2f$',eps));
% hold on
% plot(time_vec,B.Gp_iters./B.total_energy,'Color',color5,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Clean, $\\omega = %0.2f$',B.eps));
plot(time_vec,C.Gp_iters./C.total_energy,'Color',color5,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Clean, $\\omega = %0.2f$',C.eps));
% title('Input Fraction')
ylabel('Percent')
xlabel('Year')
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
hl = legend('show');
set(hl, 'Interpreter', 'latex', 'Location', 'northeast');
axis([initial_time,2100,0,1.2])
yticks([0 0.2 0.4 0.6 0.8 1.0])
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
print('ccap_input_fraction_omega','-dpng')


figure
plot(time_vec,tax_iters,'-k','LineWidth',3, 'DisplayName', sprintf('$\\omega = %0.2f$',eps));
hold on
% plot(time_vec,B.tax_iters,'-.k','LineWidth',3, 'DisplayName', sprintf('$\\omega = %0.2f$',B.eps));
plot(time_vec,C.tax_iters,':k','LineWidth',3, 'DisplayName', sprintf('$\\omega = %0.2f$',C.eps));
% title('Carbon Tax')
% ylabel('\tau_t')
ylabel('Percent')
xlabel('Year')
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
hl = legend('show');
set(hl, 'Interpreter', 'latex', 'Location', 'northwest');
axis([initial_time,2100,0,0.65])
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
print('ccap_tax_omega','-dpng')

figure
plot(time_vec,probb2_iters,'-k','LineWidth',3, 'DisplayName', sprintf('$\\omega = %0.2f$',eps));
hold on
% plot(time_vec,B.probb2_iters,'-.k','LineWidth',3, 'DisplayName', sprintf('$\\omega = %0.2f$',B.eps));
plot(time_vec,C.probb2_iters,':k','LineWidth',3, 'DisplayName', sprintf('$\\omega = %0.2f$',C.eps));
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
print('ccap_probb_omega','-dpng')

figure
plot(time_vec,MPR_iters,'Color',color1,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Total, $\\omega = %0.2f$',eps));
hold on
% plot(time_vec,B.MPR_iters,'Color',color1,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Total, $\\omega = %0.2f$',B.eps));
plot(time_vec,C.MPR_iters,'Color',color1,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Total, $\\omega = %0.2f$',C.eps));
plot(time_vec,MPR_T_iters+MPR_Gamma_iters,'Color',color2,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Climate, $\\omega = %0.2f$',eps));
% plot(time_vec,B.MPR_T_iters+B.MPR_Gamma_iters,'Color',color2,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Climate, $\\omega = %0.2f$',B.eps));
plot(time_vec,C.MPR_T_iters+C.MPR_Gamma_iters,'Color',color2,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Climate, $\\omega = %0.2f$',C.eps));
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
print('ccap_mpr_omega','-dpng')


figure
plot(time_vec,MPU_T_iters+MPU_Gamma_iters,'Color',color2,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Climate, $\\omega = %0.2f$',eps));
hold on
% plot(time_vec,B.MPU_T_iters+B.MPU_Gamma_iters,'Color',color2,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Climate, $\\omega = %0.2f$',B.eps));
plot(time_vec,C.MPU_T_iters+C.MPU_Gamma_iters,'Color',color2,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Climate, $\\omega = %0.2f$',C.eps));
plot(time_vec,MPU_T_iters,'Color',color3,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Temperature, $\\omega = %0.2f$',eps));
% plot(time_vec,B.MPU_T_iters,'Color',color3,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Temperature, $\\omega = %0.2f$',B.eps));
plot(time_vec,C.MPU_T_iters,'Color',color3,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Temperature, $\\omega = %0.2f$',C.eps));
plot(time_vec,MPU_Gamma_iters,'Color',color7,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Damages, $\\omega = %0.2f$',eps));
% plot(time_vec,B.MPU_Gamma_iters,'Color',color7,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Damages, $\\omega = %0.2f$',B.eps));
plot(time_vec,C.MPU_Gamma_iters,'Color',color7,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Damages, $\\omega = %0.2f$',C.eps));
% title('Climate Uncertainty Prices')
ylabel('Prices')
xlabel('Year')
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
hl = legend('show');
set(hl, 'Interpreter', 'latex', 'Location', 'northeast');
axis([initial_time,2100,-0.05,0.05])
yticks([-0.05 -0.025 0 0.025 0.05])
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
print('ccap_mpu_omega','-dpng')

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Sigma_T comparison
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
set(0,'defaulttextinterpreter','tex')
set(0, 'defaultAxesTickLabelInterpreter','tex'); 
set(0, 'defaultLegendInterpreter','tex');


filename = 'CCAP_HJB_T_Uncertainty_SigmaT';

directory = pwd;

% Massive impacts, but compare 
filenameUno = 'CCAP_HJB_T_Uncertainty_SigmaT0pt04';
load([filenameUno,'_Sims.mat']);
filenameDos = 'CCAP_HJB_Baseline_T_Uncertainty';
B=load([filenameDos,'_Sims.mat']);
filenameTres = 'CCAP_HJB_T_Uncertainty_SigmaT0pt06';
C=load([filenameTres,'_Sims.mat']);


filenameA = [filename,'_Sims_Comp'];
% load( filename3);
% stop

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
initial_time = 2020;
time_vec = linspace(initial_time+0,initial_time+T/4,T);


color1 = [0    0.4470    0.7410];
color2 = [0.8500    0.3250    0.0980];
color3 = [0.9290    0.6940    0.1250];
color4 = [0.4940    0.1840    0.5560];
color5 = [0.4660    0.6740    0.1880];
color6 = [0.3010    0.7450    0.9330];
color7 = [0.6350    0.0780    0.1840];




figure
plot(time_vec,Tp_iters,'Color',color2,'LineWidth',3,'LineStyle','-', 'DisplayName', sprintf('$\\sigma_T = %0.3f$',sigma_t));
hold on
% plot(time_vec,B.Tp_iters,'Color',color2,'LineWidth',3,'LineStyle','-.', 'DisplayName', sprintf('$\\sigma_T = %0.2f$',B.sigma_t));
% title('Temperature')
plot(time_vec,C.Tp_iters,'Color',color2,'LineWidth',3,'LineStyle',':', 'DisplayName', sprintf('$\\sigma_T = %0.3f$',C.sigma_t));
ylabel('T_t')
xlabel('Year')
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
hl = legend('show');
set(hl, 'Interpreter', 'latex', 'Location', 'northwest');
axis([initial_time,2100,0,2.5])
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
print('ccap_temp_sigmat','-dpng')


figure
plot(time_vec,Op_iters,'-k','LineWidth',3, 'DisplayName', sprintf('$B_t, \\sigma_T = %0.3f$',sigma_t));
hold on
% plot(time_vec,B.Op_iters,'-.k','LineWidth',3, 'DisplayName', sprintf('$B_t, \\sigma_T = %0.2f$',B.sigma_t));
plot(time_vec,C.Op_iters,':k','LineWidth',3, 'DisplayName', sprintf('$B_t, \\sigma_T = %0.3f$',C.sigma_t));
plot(time_vec,Gp_iters,'Color',color5,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('$G_t, \\sigma_T = %0.3f$',sigma_t));
% plot(time_vec,B.Gp_iters,'Color',color5,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('$G_t, \\sigma_T = %0.2f$',B.sigma_t));
plot(time_vec,C.Gp_iters,'Color',color5,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('$G_t, \\sigma_T = %0.3f$',C.sigma_t));
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
print('ccap_input_sigmat','-dpng')

total_energy = Op_iters+Gp_iters;
B.total_energy = B.Op_iters+B.Gp_iters;
C.total_energy = C.Op_iters+C.Gp_iters;


figure
plot(time_vec,Op_iters./total_energy,'-k','LineWidth',3, 'DisplayName', sprintf('Dirty, $\\sigma_T = %0.3f$',sigma_t));
hold on
% plot(time_vec,B.Op_iters./B.total_energy,'-.k','LineWidth',3, 'DisplayName', sprintf('Dirty, $\\sigma_T = %0.2f$',B.sigma_t));
plot(time_vec,C.Op_iters./C.total_energy,':k','LineWidth',3, 'DisplayName', sprintf('Dirty, $\\sigma_T = %0.3f$',C.sigma_t));
plot(time_vec,Gp_iters./total_energy,'Color',color5,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Clean, $\\sigma_T = %0.3f$',sigma_t));
% hold on
% plot(time_vec,B.Gp_iters./B.total_energy,'Color',color5,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Clean, $\\sigma_T = %0.2f$',B.sigma_t));
plot(time_vec,C.Gp_iters./C.total_energy,'Color',color5,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Clean, $\\sigma_T = %0.3f$',C.sigma_t));
% title('Input Fraction')
ylabel('Percent')
xlabel('Year')
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
hl = legend('show');
set(hl, 'Interpreter', 'latex', 'Location', 'northeast');
axis([initial_time,2100,0,1.3])
yticks([0 0.2 0.4 0.6 0.8 1.0])
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
print('ccap_input_fraction_sigmat','-dpng')


figure
plot(time_vec,tax_iters,'-k','LineWidth',3, 'DisplayName', sprintf('$\\sigma_T = %0.3f$',sigma_t));
hold on
% plot(time_vec,B.tax_iters,'-.k','LineWidth',3, 'DisplayName', sprintf('$\\sigma_T = %0.2f$',B.sigma_t));
plot(time_vec,C.tax_iters,':k','LineWidth',3, 'DisplayName', sprintf('$\\sigma_T = %0.3f$',C.sigma_t));
% title('Carbon Tax')
ylabel('Percent')
xlabel('Year')
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
hl = legend('show');
set(hl, 'Interpreter', 'latex', 'Location', 'northwest');
axis([initial_time,2100,0,1.0])
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
print('ccap_tax_sigmat','-dpng')

figure
plot(time_vec,probb2_iters,'-k','LineWidth',3, 'DisplayName', sprintf('$\\sigma_T = %0.3f$',sigma_t));
hold on
% plot(time_vec,B.probb2_iters,'-.k','LineWidth',3, 'DisplayName', sprintf('$\\sigma_T = %0.2f$',B.sigma_t));
plot(time_vec,C.probb2_iters,':k','LineWidth',3, 'DisplayName', sprintf('$\\sigma_T = %0.3f$',C.sigma_t));
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
print('ccap_probb_sigmat','-dpng')

figure
plot(time_vec,MPR_iters,'Color',color1,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Total, $\\sigma_T = %0.3f$',sigma_t));
hold on
% plot(time_vec,B.MPR_iters,'Color',color1,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Total, $\\sigma_T = %0.2f$',B.sigma_t));
plot(time_vec,C.MPR_iters,'Color',color1,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Total, $\\sigma_T = %0.3f$',C.sigma_t));
plot(time_vec,MPR_T_iters+MPR_Gamma_iters,'Color',color2,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Climate, $\\sigma_T = %0.3f$',sigma_t));
% plot(time_vec,B.MPR_T_iters+B.MPR_Gamma_iters,'Color',color2,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Climate, $\\sigma_T = %0.2f$',B.sigma_t));
plot(time_vec,C.MPR_T_iters+C.MPR_Gamma_iters,'Color',color2,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Climate, $\\sigma_T = %0.f$',C.sigma_t));
% title('Risk and Uncertainty Prices')
ylabel('Prices')
xlabel('Year')
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
hl = legend('show');
set(hl, 'Interpreter', 'latex', 'Location', 'northeast');
axis([initial_time,2100,-0.2,0.4])
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
print('ccap_mpr_sigmat','-dpng')


figure
plot(time_vec,MPU_T_iters+MPU_Gamma_iters,'Color',color2,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Climate, $\\sigma_T = %0.3f$',sigma_t));
hold on
% plot(time_vec,B.MPU_T_iters+B.MPU_Gamma_iters,'Color',color2,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Climate, $\\sigma_T = %0.2f$',B.sigma_t));
plot(time_vec,C.MPU_T_iters+C.MPU_Gamma_iters,'Color',color2,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Climate, $\\sigma_T = %0.3f$',C.sigma_t));
plot(time_vec,MPU_T_iters,'Color',color3,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Temperature, $\\sigma_T = %0.3f$',sigma_t));
% plot(time_vec,B.MPU_T_iters,'Color',color3,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Temperature, $\\sigma_T = %0.2f$',B.sigma_t));
plot(time_vec,C.MPU_T_iters,'Color',color3,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Temperature, $\\sigma_T = %0.3f$',C.sigma_t));
plot(time_vec,MPU_Gamma_iters,'Color',color7,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Damages, $\\sigma_T = %0.3f$',sigma_t));
% plot(time_vec,B.MPU_Gamma_iters,'Color',color7,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Damages, $\\sigma_T = %0.2f$',B.sigma_t));
plot(time_vec,C.MPU_Gamma_iters,'Color',color7,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Damages, $\\sigma_T = %0.3f$',C.sigma_t));
% title('Climate Uncertainty Prices')
ylabel('Prices')
xlabel('Year')
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
hl = legend('show');
set(hl, 'Interpreter', 'latex', 'Location', 'northeast');
% axis([initial_time,2100,-0.15,0.15])
axis([initial_time,2100,-0.05,0.05])
% yticks([-0.15 -0.1 -0.05 0 0.05 0.1 0.15])
yticks([-0.05 -0.025 0 0.025 0.05])
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
print('ccap_mpu_sigmat','-dpng')
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Tau comparison
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
set(0,'defaulttextinterpreter','tex')
set(0, 'defaultAxesTickLabelInterpreter','tex'); 
set(0, 'defaultLegendInterpreter','tex');


filename = 'HJB_CCAP_1D_AltLogU_scl1pt0_AltParams';

directory = pwd;

 
% Mostly macro impacts here
filenameUno = 'CCAP_HJB_T_Uncertainty_Tau1pt5';
load([filenameUno,'_Sims.mat']);
filenameDos = 'CCAP_HJB_Baseline_T_Uncertainty';
B=load([filenameDos,'_Sims.mat']);
filenameTres = 'CCAP_HJB_T_Uncertainty_Tau2pt5';
C=load([filenameTres,'_Sims.mat']);


filenameA = [filename,'_Sims_Comp'];
% load( filename3);
% stop

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
initial_time = 2020;
time_vec = linspace(initial_time+0,initial_time+T/4,T);


color1 = [0    0.4470    0.7410];
color2 = [0.8500    0.3250    0.0980];
color3 = [0.9290    0.6940    0.1250];
color4 = [0.4940    0.1840    0.5560];
color5 = [0.4660    0.6740    0.1880];
color6 = [0.3010    0.7450    0.9330];
color7 = [0.6350    0.0780    0.1840];




figure
plot(time_vec,Tp_iters,'Color',color2,'LineWidth',3,'LineStyle','-', 'DisplayName', sprintf('$\\tau = %0.2f$',tau));
hold on
% plot(time_vec,B.Tp_iters,'Color',color2,'LineWidth',3,'LineStyle','-.', 'DisplayName', sprintf('$\\tau = %0.2f$',B.tau));
% title('Temperature')
plot(time_vec,C.Tp_iters,'Color',color2,'LineWidth',3,'LineStyle',':', 'DisplayName', sprintf('$\\tau = %0.2f$',C.tau));
ylabel('T_t')
xlabel('Year')
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
hl = legend('show');
set(hl, 'Interpreter', 'latex', 'Location', 'northwest');
axis([initial_time,2100,0,2.5])
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
print('ccap_temp_tau','-dpng')


figure
plot(time_vec,Op_iters,'-k','LineWidth',3, 'DisplayName', sprintf('$B_t, \\tau = %0.2f$',tau));
hold on
% plot(time_vec,B.Op_iters,'-.k','LineWidth',3, 'DisplayName', sprintf('$B_t, \\tau = %0.2f$',B.tau));
plot(time_vec,C.Op_iters,':k','LineWidth',3, 'DisplayName', sprintf('$B_t, \\tau = %0.2f$',C.tau));
plot(time_vec,Gp_iters,'Color',color5,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('$G_t, \\tau = %0.2f$',tau));
% plot(time_vec,B.Gp_iters,'Color',color5,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('$G_t, \\tau = %0.2f$',B.tau));
plot(time_vec,C.Gp_iters,'Color',color5,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('$G_t, \\tau = %0.2f$',C.tau));
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
print('ccap_input_tau','-dpng')

total_energy = Op_iters+Gp_iters;
B.total_energy = B.Op_iters+B.Gp_iters;
C.total_energy = C.Op_iters+C.Gp_iters;


figure
plot(time_vec,Op_iters./total_energy,'-k','LineWidth',3, 'DisplayName', sprintf('Dirty, $\\tau = %0.2f$',tau));
hold on
% plot(time_vec,B.Op_iters./B.total_energy,'-.k','LineWidth',3, 'DisplayName', sprintf('Dirty, $\\tau = %0.2f$',B.tau));
plot(time_vec,C.Op_iters./C.total_energy,':k','LineWidth',3, 'DisplayName', sprintf('Dirty, $\\tau = %0.2f$',C.tau));
plot(time_vec,Gp_iters./total_energy,'Color',color5,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Clean, $\\tau = %0.2f$',tau));
% hold on
% plot(time_vec,B.Gp_iters./B.total_energy,'Color',color5,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Clean, $\\tau = %0.2f$',B.tau));
plot(time_vec,C.Gp_iters./C.total_energy,'Color',color5,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Clean, $\\tau = %0.2f$',C.tau));
% title('Input Fraction')
ylabel('Percent')
xlabel('Year')
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
hl = legend('show');
set(hl, 'Interpreter', 'latex', 'Location', 'northeast');
axis([initial_time,2100,0,1.2])
yticks([0 0.2 0.4 0.6 0.8 1.0])
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
print('ccap_input_fraction_tau','-dpng')


figure
plot(time_vec,tax_iters,'-k','LineWidth',3, 'DisplayName', sprintf('$\\tau = %0.2f$',tau));
hold on
% plot(time_vec,B.tax_iters,'-.k','LineWidth',3, 'DisplayName', sprintf('$\\tau = %0.2f$',B.tau));
plot(time_vec,C.tax_iters,':k','LineWidth',3, 'DisplayName', sprintf('$\\tau = %0.2f$',C.tau));
% title('Carbon Tax')
ylabel('Percent')
xlabel('Year')
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
hl = legend('show');
set(hl, 'Interpreter', 'latex', 'Location', 'northwest');
axis([initial_time,2100,0,1.0])
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
print('ccap_tax_tau','-dpng')

figure
plot(time_vec,probb2_iters,'-k','LineWidth',3, 'DisplayName', sprintf('$\\tau = %0.2f$',tau));
hold on
% plot(time_vec,B.probb2_iters,'-.k','LineWidth',3, 'DisplayName', sprintf('$\\tau = %0.2f$',B.tau));
plot(time_vec,C.probb2_iters,':k','LineWidth',3, 'DisplayName', sprintf('$\\tau = %0.2f$',C.tau));
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
print('ccap_probb_tau','-dpng')

figure
plot(time_vec,MPR_iters,'Color',color1,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Total, $\\tau = %0.2f$',tau));
hold on
% plot(time_vec,B.MPR_iters,'Color',color1,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Total, $\\tau = %0.2f$',B.tau));
plot(time_vec,C.MPR_iters,'Color',color1,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Total, $\\tau = %0.2f$',C.tau));
plot(time_vec,MPR_T_iters+MPR_Gamma_iters,'Color',color2,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Climate, $\\tau = %0.2f$',tau));
% plot(time_vec,B.MPR_T_iters+B.MPR_Gamma_iters,'Color',color2,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Climate, $\\tau = %0.2f$',B.tau));
plot(time_vec,C.MPR_T_iters+C.MPR_Gamma_iters,'Color',color2,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Climate, $\\tau = %0.2f$',C.tau));
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
print('ccap_mpr_tau','-dpng')


figure
plot(time_vec,MPU_T_iters+MPU_Gamma_iters,'Color',color2,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Climate, $\\tau = %0.2f$',tau));
hold on
% plot(time_vec,B.MPU_T_iters+B.MPU_Gamma_iters,'Color',color2,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Climate, $\\tau = %0.2f$',B.tau));
plot(time_vec,C.MPU_T_iters+C.MPU_Gamma_iters,'Color',color2,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Climate, $\\tau = %0.2f$',C.tau));
plot(time_vec,MPU_T_iters,'Color',color3,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Temperature, $\\tau = %0.2f$',tau));
% plot(time_vec,B.MPU_T_iters,'Color',color3,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Temperature, $\\tau = %0.2f$',B.tau));
plot(time_vec,C.MPU_T_iters,'Color',color3,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Temperature, $\\tau = %0.2f$',C.tau));
plot(time_vec,MPU_Gamma_iters,'Color',color7,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Damages, $\\tau = %0.2f$',tau));
% plot(time_vec,B.MPU_Gamma_iters,'Color',color7,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Damages, $\\tau = %0.2f$',B.tau));
plot(time_vec,C.MPU_Gamma_iters,'Color',color7,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Damages, $\\tau = %0.2f$',C.tau));
% title('Climate Uncertainty Prices')
ylabel('Prices')
xlabel('Year')
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
hl = legend('show');
set(hl, 'Interpreter', 'latex', 'Location', 'northeast');
axis([initial_time,2100,-0.05,0.05])
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
print('ccap_mpu_tau','-dpng')

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% G2P comparison
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
set(0,'defaulttextinterpreter','tex')
set(0, 'defaultAxesTickLabelInterpreter','tex'); 
set(0, 'defaultLegendInterpreter','tex');


filename = 'CCAP_HJB_T_Uncertainty_G2P';

directory = pwd;

% Pretty significant impacts overall here
filenameUno = 'CCAP_HJB_T_Uncertainty_G2P0pt0';
load([filenameUno,'_Sims.mat']);
filenameDos = 'CCAP_HJB_Baseline_T_Uncertainty';
B=load([filenameDos,'_Sims.mat']);
filenameTres = 'CCAP_HJB_T_Uncertainty_G2P0pt0295';
C=load([filenameTres,'_Sims.mat']);



filenameA = [filename,'_Sims_Comp'];


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
initial_time = 2020;
time_vec = linspace(initial_time+0,initial_time+T/4,T);


color1 = [0    0.4470    0.7410];
color2 = [0.8500    0.3250    0.0980];
color3 = [0.9290    0.6940    0.1250];
color4 = [0.4940    0.1840    0.5560];
color5 = [0.4660    0.6740    0.1880];
color6 = [0.3010    0.7450    0.9330];
color7 = [0.6350    0.0780    0.1840];




figure
plot(time_vec,Tp_iters,'Color',color2,'LineWidth',3,'LineStyle','-', 'DisplayName', sprintf('$\\gamma_2^+ = %0.4f$',bar_gamma_2_plus));
hold on
% plot(time_vec,B.Tp_iters,'Color',color2,'LineWidth',3,'LineStyle','-.', 'DisplayName', sprintf('$\\gamma_2^+ = %0.2f$',B.bar_gamma_2_plus));
% title('Temperature')
plot(time_vec,C.Tp_iters,'Color',color2,'LineWidth',3,'LineStyle',':', 'DisplayName', sprintf('$\\gamma_2^+ = %0.4f$',C.bar_gamma_2_plus));
ylabel('T_t')
xlabel('Year')
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
hl = legend('show');
set(hl, 'Interpreter', 'latex', 'Location', 'northwest');
axis([initial_time,2100,0,2.5])
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
print('ccap_temp_g2p','-dpng')


figure
plot(time_vec,Op_iters,'-k','LineWidth',3, 'DisplayName', sprintf('$B_t, \\gamma_2^+ = %0.4f$',bar_gamma_2_plus));
hold on
% plot(time_vec,B.Op_iters,'-.k','LineWidth',3, 'DisplayName', sprintf('$B_t, \\gamma_2^+ = %0.2f$',B.bar_gamma_2_plus));
plot(time_vec,C.Op_iters,':k','LineWidth',3, 'DisplayName', sprintf('$B_t, \\gamma_2^+ = %0.4f$',C.bar_gamma_2_plus));
plot(time_vec,Gp_iters,'Color',color5,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('$G_t, \\gamma_2^+ = %0.4f$',bar_gamma_2_plus));
% plot(time_vec,B.Gp_iters,'Color',color5,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('$G_t, \\gamma_2^+ = %0.2f$',B.bar_gamma_2_plus));
plot(time_vec,C.Gp_iters,'Color',color5,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('$G_t, \\gamma_2^+ = %0.4f$',C.bar_gamma_2_plus));
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
print('ccap_input_g2p','-dpng')

total_energy = Op_iters+Gp_iters;
B.total_energy = B.Op_iters+B.Gp_iters;
C.total_energy = C.Op_iters+C.Gp_iters;


figure
plot(time_vec,Op_iters./total_energy,'-k','LineWidth',3, 'DisplayName', sprintf('Dirty, $\\gamma_2^+ = %0.4f$',bar_gamma_2_plus));
hold on
% plot(time_vec,B.Op_iters./B.total_energy,'-.k','LineWidth',3, 'DisplayName', sprintf('Dirty, $\\gamma_2^+ = %0.2f$',B.bar_gamma_2_plus));
plot(time_vec,C.Op_iters./C.total_energy,':k','LineWidth',3, 'DisplayName', sprintf('Dirty, $\\gamma_2^+ = %0.4f$',C.bar_gamma_2_plus));
plot(time_vec,Gp_iters./total_energy,'Color',color5,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Clean, $\\gamma_2^+ = %0.4f$',bar_gamma_2_plus));
% hold on
% plot(time_vec,B.Gp_iters./B.total_energy,'Color',color5,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Clean, $\\gamma_2^+ = %0.2f$',B.bar_gamma_2_plus));
plot(time_vec,C.Gp_iters./C.total_energy,'Color',color5,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Clean, $\\gamma_2^+ = %0.4f$',C.bar_gamma_2_plus));
% title('Input Fraction')
ylabel('Percent')
xlabel('Year')
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
hl = legend('show');
set(hl, 'Interpreter', 'latex', 'Location', 'northeast');
axis([initial_time,2100,0,1.5])
yticks([0 0.2 0.4 0.6 0.8 1.0])
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
print('ccap_input_fraction_g2p','-dpng')


figure
plot(time_vec,tax_iters,'-k','LineWidth',3, 'DisplayName', sprintf('$\\gamma_2^+ = %0.4f$',bar_gamma_2_plus));
hold on
% plot(time_vec,B.tax_iters,'-.k','LineWidth',3, 'DisplayName', sprintf('$\\gamma_2^+ = %0.2f$',B.bar_gamma_2_plus));
plot(time_vec,C.tax_iters,':k','LineWidth',3, 'DisplayName', sprintf('$\\gamma_2^+ = %0.4f$',C.bar_gamma_2_plus));
% title('Carbon Tax')
ylabel('Percent')
xlabel('Year')
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
hl = legend('show');
set(hl, 'Interpreter', 'latex', 'Location', 'southeast');
axis([initial_time,2100,0,1.0])
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
print('ccap_tax_g2p','-dpng')

figure
plot(time_vec,probb2_iters,'-k','LineWidth',3, 'DisplayName', sprintf('$\\gamma_2^+ = %0.4f$',bar_gamma_2_plus));
hold on
% plot(time_vec,B.probb2_iters,'-.k','LineWidth',3, 'DisplayName', sprintf('$\\gamma_2^+ = %0.2f$',B.bar_gamma_2_plus));
plot(time_vec,C.probb2_iters,':k','LineWidth',3, 'DisplayName', sprintf('$\\gamma_2^+ = %0.4f$',C.bar_gamma_2_plus));
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
print('ccap_probb_g2p','-dpng')

figure
plot(time_vec,MPR_iters,'Color',color1,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Total, $\\gamma_2^+ = %0.4f$',bar_gamma_2_plus));
hold on
% plot(time_vec,B.MPR_iters,'Color',color1,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Total, $\\gamma_2^+ = %0.2f$',B.bar_gamma_2_plus));
plot(time_vec,C.MPR_iters,'Color',color1,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Total, $\\gamma_2^+ = %0.4f$',C.bar_gamma_2_plus));
plot(time_vec,MPR_T_iters+MPR_Gamma_iters,'Color',color2,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Climate, $\\gamma_2^+ = %0.4f$',bar_gamma_2_plus));
% plot(time_vec,B.MPR_T_iters+B.MPR_Gamma_iters,'Color',color2,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Climate, $\\gamma_2^+ = %0.2f$',B.bar_gamma_2_plus));
plot(time_vec,C.MPR_T_iters+C.MPR_Gamma_iters,'Color',color2,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Climate, $\\gamma_2^+ = %0.4f$',C.bar_gamma_2_plus));
% title('Risk and Uncertainty Prices')
ylabel('Prices')
xlabel('Year')
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
hl = legend('show');
set(hl, 'Interpreter', 'latex', 'Location', 'northeast');
axis([initial_time,2100,-0.2,0.4])
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
print('ccap_mpr_g2p','-dpng')


figure
plot(time_vec,MPU_T_iters+MPU_Gamma_iters,'Color',color2,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Climate, $\\gamma_2^+ = %0.4f$',bar_gamma_2_plus));
hold on
% plot(time_vec,B.MPU_T_iters+B.MPU_Gamma_iters,'Color',color2,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Climate, $\\gamma_2^+ = %0.2f$',B.bar_gamma_2_plus));
plot(time_vec,C.MPU_T_iters+C.MPU_Gamma_iters,'Color',color2,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Climate, $\\gamma_2^+ = %0.4f$',C.bar_gamma_2_plus));
plot(time_vec,MPU_T_iters,'Color',color3,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Temperature, $\\gamma_2^+ = %0.4f$',bar_gamma_2_plus));
% plot(time_vec,B.MPU_T_iters,'Color',color3,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Temperature, $\\gamma_2^+ = %0.2f$',B.bar_gamma_2_plus));
plot(time_vec,C.MPU_T_iters,'Color',color3,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Temperature, $\\gamma_2^+ = %0.4f$',C.bar_gamma_2_plus));
plot(time_vec,MPU_Gamma_iters,'Color',color7,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Damages, $\\gamma_2^+ = %0.4f$',bar_gamma_2_plus));
% plot(time_vec,B.MPU_Gamma_iters,'Color',color7,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Damages, $\\gamma_2^+ = %0.2f$',B.bar_gamma_2_plus));
plot(time_vec,C.MPU_Gamma_iters,'Color',color7,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Damages, $\\gamma_2^+ = %0.4f$',C.bar_gamma_2_plus));
% title('Climate Uncertainty Prices')
ylabel('Prices')
xlabel('Year')
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
hl = legend('show');
set(hl, 'Interpreter', 'latex', 'Location', 'northeast');
% axis([initial_time,2100,-0.15,0.15])
axis([initial_time,2100,-0.05,0.05])
% yticks([-0.15 -0.1 -0.05 0 0.05 0.1 0.15])
yticks([-0.05 -0.025 0 0.025 0.05])
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
print('ccap_mpu_g2p','-dpng')





% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% G2P comparison
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
set(0,'defaulttextinterpreter','tex')
set(0, 'defaultAxesTickLabelInterpreter','tex'); 
set(0, 'defaultLegendInterpreter','tex');


filename = 'CCAP_HJB_T_Uncertainty_Lambda';

directory = pwd;

% Pretty significant impacts overall here
filenameUno = 'CCAP_HJB_T_Uncertainty_Lambda1pt5';
load([filenameUno,'_Sims.mat']);
filenameDos = 'CCAP_HJB_Baseline_T_Uncertainty';
B=load([filenameDos,'_Sims.mat']);
filenameTres = 'CCAP_HJB_T_Uncertainty_Lambda2pt0';
C=load([filenameTres,'_Sims.mat']);



filenameA = [filename,'_Sims_Comp'];


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
initial_time = 2020;
time_vec = linspace(initial_time+0,initial_time+T/4,T);


color1 = [0    0.4470    0.7410];
color2 = [0.8500    0.3250    0.0980];
color3 = [0.9290    0.6940    0.1250];
color4 = [0.4940    0.1840    0.5560];
color5 = [0.4660    0.6740    0.1880];
color6 = [0.3010    0.7450    0.9330];
color7 = [0.6350    0.0780    0.1840];




figure
plot(time_vec,Tp_iters,'Color',color2,'LineWidth',3,'LineStyle','-', 'DisplayName', sprintf('$\\lambda = %0.4f$',lambda));
hold on
% plot(time_vec,B.Tp_iters,'Color',color2,'LineWidth',3,'LineStyle','-.', 'DisplayName', sprintf('$\\lambda = %0.2f$',B.lambda));
% title('Temperature')
plot(time_vec,C.Tp_iters,'Color',color2,'LineWidth',3,'LineStyle',':', 'DisplayName', sprintf('$\\lambda = %0.4f$',C.lambda));
ylabel('T_t')
xlabel('Year')
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
hl = legend('show');
set(hl, 'Interpreter', 'latex', 'Location', 'northwest');
axis([initial_time,2100,0,2.5])
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
print('ccap_temp_lambda','-dpng')


figure
plot(time_vec,Op_iters,'-k','LineWidth',3, 'DisplayName', sprintf('$B_t, \\lambda = %0.4f$',lambda));
hold on
% plot(time_vec,B.Op_iters,'-.k','LineWidth',3, 'DisplayName', sprintf('$B_t, \\lambda = %0.2f$',B.lambda));
plot(time_vec,C.Op_iters,':k','LineWidth',3, 'DisplayName', sprintf('$B_t, \\lambda = %0.4f$',C.lambda));
plot(time_vec,Gp_iters,'Color',color5,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('$G_t, \\lambda = %0.4f$',lambda));
% plot(time_vec,B.Gp_iters,'Color',color5,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('$G_t, \\lambda = %0.2f$',B.lambda));
plot(time_vec,C.Gp_iters,'Color',color5,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('$G_t, \\lambda = %0.4f$',C.lambda));
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
print('ccap_input_lambda','-dpng')

total_energy = Op_iters+Gp_iters;
B.total_energy = B.Op_iters+B.Gp_iters;
C.total_energy = C.Op_iters+C.Gp_iters;


figure
plot(time_vec,Op_iters./total_energy,'-k','LineWidth',3, 'DisplayName', sprintf('Dirty, $\\lambda = %0.4f$',lambda));
hold on
% plot(time_vec,B.Op_iters./B.total_energy,'-.k','LineWidth',3, 'DisplayName', sprintf('Dirty, $\\lambda = %0.2f$',B.lambda));
plot(time_vec,C.Op_iters./C.total_energy,':k','LineWidth',3, 'DisplayName', sprintf('Dirty, $\\lambda = %0.4f$',C.lambda));
plot(time_vec,Gp_iters./total_energy,'Color',color5,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Clean, $\\lambda = %0.4f$',lambda));
% hold on
% plot(time_vec,B.Gp_iters./B.total_energy,'Color',color5,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Clean, $\\lambda = %0.2f$',B.lambda));
plot(time_vec,C.Gp_iters./C.total_energy,'Color',color5,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Clean, $\\lambda = %0.4f$',C.lambda));
% title('Input Fraction')
ylabel('Percent')
xlabel('Year')
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
hl = legend('show');
set(hl, 'Interpreter', 'latex', 'Location', 'northeast');
axis([initial_time,2100,0,1.2])
yticks([0 0.2 0.4 0.6 0.8 1.0])
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
print('ccap_input_fraction_lambda','-dpng')


figure
plot(time_vec,tax_iters,'-k','LineWidth',3, 'DisplayName', sprintf('$\\lambda = %0.4f$',lambda));
hold on
% plot(time_vec,B.tax_iters,'-.k','LineWidth',3, 'DisplayName', sprintf('$\\lambda = %0.2f$',B.lambda));
plot(time_vec,C.tax_iters,':k','LineWidth',3, 'DisplayName', sprintf('$\\lambda = %0.4f$',C.lambda));
% title('Carbon Tax')
ylabel('Percent')
xlabel('Year')
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
hl = legend('show');
set(hl, 'Interpreter', 'latex', 'Location', 'northeast');
axis([initial_time,2100,0,1.0])
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
print('ccap_tax_lambda','-dpng')

figure
plot(time_vec,probb2_iters,'-k','LineWidth',3, 'DisplayName', sprintf('$\\lambda = %0.4f$',lambda));
hold on
% plot(time_vec,B.probb2_iters,'-.k','LineWidth',3, 'DisplayName', sprintf('$\\lambda = %0.2f$',B.lambda));
plot(time_vec,C.probb2_iters,':k','LineWidth',3, 'DisplayName', sprintf('$\\lambda = %0.4f$',C.lambda));
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
print('ccap_probb_lambda','-dpng')

figure
plot(time_vec,MPR_iters,'Color',color1,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Total, $\\lambda = %0.4f$',lambda));
hold on
% plot(time_vec,B.MPR_iters,'Color',color1,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Total, $\\lambda = %0.2f$',B.lambda));
plot(time_vec,C.MPR_iters,'Color',color1,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Total, $\\lambda = %0.4f$',C.lambda));
plot(time_vec,MPR_T_iters+MPR_Gamma_iters,'Color',color2,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Climate, $\\lambda = %0.4f$',lambda));
% plot(time_vec,B.MPR_T_iters+B.MPR_Gamma_iters,'Color',color2,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Climate, $\\lambda = %0.2f$',B.lambda));
plot(time_vec,C.MPR_T_iters+C.MPR_Gamma_iters,'Color',color2,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Climate, $\\lambda = %0.4f$',C.lambda));
% title('Risk and Uncertainty Prices')
ylabel('Prices')
xlabel('Year')
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
hl = legend('show');
set(hl, 'Interpreter', 'latex', 'Location', 'northeast');
axis([initial_time,2100,-0.2,0.4])
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
print('ccap_mpr_lambda','-dpng')


figure
plot(time_vec,MPU_T_iters+MPU_Gamma_iters,'Color',color2,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Climate, $\\lambda = %0.4f$',lambda));
hold on
% plot(time_vec,B.MPU_T_iters+B.MPU_Gamma_iters,'Color',color2,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Climate, $\\lambda = %0.2f$',B.lambda));
plot(time_vec,C.MPU_T_iters+C.MPU_Gamma_iters,'Color',color2,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Climate, $\\lambda = %0.4f$',C.lambda));
plot(time_vec,MPU_T_iters,'Color',color3,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Temperature, $\\lambda = %0.4f$',lambda));
% plot(time_vec,B.MPU_T_iters,'Color',color3,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Temperature, $\\lambda = %0.2f$',B.lambda));
plot(time_vec,C.MPU_T_iters,'Color',color3,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Temperature, $\\lambda = %0.4f$',C.lambda));
plot(time_vec,MPU_Gamma_iters,'Color',color7,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Damages, $\\lambda = %0.4f$',lambda));
% plot(time_vec,B.MPU_Gamma_iters,'Color',color7,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Damages, $\\lambda = %0.2f$',B.lambda));
plot(time_vec,C.MPU_Gamma_iters,'Color',color7,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Damages, $\\lambda = %0.4f$',C.lambda));
% title('Climate Uncertainty Prices')
ylabel('Prices')
xlabel('Year')
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
hl = legend('show');
set(hl, 'Interpreter', 'latex', 'Location', 'northeast');
axis([initial_time,2100,-0.05,0.05])
yticks([-0.05 -0.025 0 0.025 0.05])
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
print('ccap_mpu_lambda','-dpng')


