% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % Partial Internalization Comparison Figures Code
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

% Set to 1 to plot outcomes with equal economic and climate model uncertainty
% Set to 2 to plot outcomes with unequal economic and climate model uncertainty
uncertainty_comp = 2;

if uncertainty_comp == 1
filename = [directory, '\CCAP_HJB_Partial1'];

filenameUno = [directory, '\CCAP_HJB_Baseline_T_Uncertainty'];
load([filenameUno,'_Sims.mat']);
filenameDos = [directory, '\CCAP_HJB_Partial_T_Uncertainty'];
B=load([filenameDos,'_Sims.mat']);

filenameA = [filename,'_Sims_Comp'];
elseif uncertainty_comp == 2
filename = [directory, '\CCAP_HJB_Partial2'];

filenameUno = [directory, '\CCAP_HJB_Baseline_T_Uncertainty'];
load([filenameUno,'_Sims.mat']);
filenameDos = [directory, '\CCAP_HJB_Partial_T_Uncertainty2'];
B=load([filenameDos,'_Sims.mat']);

filenameA = [filename,'_Sims_Comp'];
end

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
if uncertainty_comp == 1
plot(time_vec,Tp_iters,'Color',color2,'LineWidth',3,'LineStyle','-', 'DisplayName', sprintf('$\\varrho_T = %0.2f$, $\\chi =  %0.2f$',varrho,scl));
hold on
plot(time_vec,B.Tp_iters,'Color',color2,'LineWidth',3,'LineStyle',':', 'DisplayName', sprintf('$\\varrho_T = %0.2f$, $\\chi =  %0.2f$',B.varrho,B.scl));
elseif uncertainty_comp == 2
plot(time_vec,Tp_iters,'Color',color2,'LineWidth',3,'LineStyle','-', 'DisplayName', sprintf('$\\varrho_T = %0.3f$, $\\chi =  %0.2f$',varrho,scl));
hold on
plot(time_vec,B.Tp_iters,'Color',color2,'LineWidth',3,'LineStyle',':', 'DisplayName', sprintf('$\\varrho_T = %0.3f$, $\\chi =  %0.2f$',B.varrho,B.scl));
end
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
if uncertainty_comp == 1
print('ccap_temp_partial1','-dpng')
elseif uncertainty_comp == 2
print('ccap_temp_partial2','-dpng')
end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

figure
if uncertainty_comp == 1
plot(time_vec,Op_iters,'-k','LineWidth',3, 'DisplayName', sprintf('Dirty, $\\varrho_T = %0.2f$, $\\chi =  %0.2f$',varrho,scl));
hold on
plot(time_vec,B.Op_iters,':k','LineWidth',3, 'DisplayName', sprintf('Dirty, $\\varrho_T = %0.2f$, $\\chi =  %0.2f$',B.varrho,B.scl));
plot(time_vec,Gp_iters,'Color',color5,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Clean, $\\varrho_T = %0.2f$, $\\chi =  %0.2f$',varrho,scl));
plot(time_vec,B.Gp_iters,'Color',color5,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Clean, $\\varrho_T = %0.2f$, $\\chi =  %0.2f$',B.varrho,B.scl));
elseif uncertainty_comp == 2
plot(time_vec,Op_iters,'-k','LineWidth',3, 'DisplayName', sprintf('Dirty, $\\varrho_T = %0.3f$, $\\chi =  %0.2f$',varrho,scl));
hold on
plot(time_vec,B.Op_iters,':k','LineWidth',3, 'DisplayName', sprintf('Dirty, $\\varrho_T = %0.3f$, $\\chi =  %0.2f$',B.varrho,B.scl));
plot(time_vec,Gp_iters,'Color',color5,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Clean, $\\varrho_T = %0.3f$, $\\chi =  %0.2f$',varrho,scl));
plot(time_vec,B.Gp_iters,'Color',color5,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Clean, $\\varrho_T = %0.3f$, $\\chi =  %0.2f$',B.varrho,B.scl));
end
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
if uncertainty_comp == 1
print('ccap_input_partial1','-dpng')
elseif uncertainty_comp == 2
print('ccap_input_partial2','-dpng')
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 


total_energy = Op_iters+Gp_iters;
B.total_energy = B.Op_iters+B.Gp_iters;

figure
if uncertainty_comp == 1
plot(time_vec,Op_iters./total_energy,'-k','LineWidth',3, 'DisplayName', sprintf('Dirty, $\\varrho_T = %0.2f$, $\\chi =  %0.2f$',varrho,scl));
hold on
plot(time_vec,B.Op_iters./B.total_energy,':k','LineWidth',3, 'DisplayName', sprintf('Dirty, $\\varrho_T = %0.2f$, $\\chi =  %0.2f$',B.varrho,B.scl));
plot(time_vec,Gp_iters./total_energy,'Color',color5,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Clean, $\\varrho_T = %0.2f$, $\\chi =  %0.2f$',varrho,scl));
plot(time_vec,B.Gp_iters./B.total_energy,'Color',color5,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Clean, $\\varrho_T = %0.2f$, $\\chi =  %0.2f$',B.varrho,B.scl));
elseif uncertainty_comp == 2
plot(time_vec,Op_iters./total_energy,'-k','LineWidth',3, 'DisplayName', sprintf('Dirty, $\\varrho_T = %0.3f$, $\\chi =  %0.2f$',varrho,scl));
hold on
plot(time_vec,B.Op_iters./B.total_energy,':k','LineWidth',3, 'DisplayName', sprintf('Dirty, $\\varrho_T = %0.3f$, $\\chi =  %0.2f$',B.varrho,B.scl));
plot(time_vec,Gp_iters./total_energy,'Color',color5,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Clean, $\\varrho_T = %0.3f$, $\\chi =  %0.2f$',varrho,scl));
plot(time_vec,B.Gp_iters./B.total_energy,'Color',color5,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Clean, $\\varrho_T = %0.3f$, $\\chi =  %0.2f$',B.varrho,B.scl));
end
% title('Input Fraction')
ylabel('Percent')
xlabel('Year')
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
hl = legend('show');
set(hl, 'Interpreter', 'latex', 'Location', 'northeast');
axis([initial_time,2100,0,1.4])
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
if uncertainty_comp == 1
print('ccap_input_fraction_partial1','-dpng')
elseif uncertainty_comp == 2
print('ccap_input_fraction_partial2','-dpng')
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

figure
if uncertainty_comp == 1
plot(time_vec,tax_iters,'-k','LineWidth',3, 'DisplayName', sprintf('$\\varrho_T = %0.2f$, $\\chi =  %0.2f$',varrho,scl));
hold on
plot(time_vec,B.tax_iters,':k','LineWidth',3, 'DisplayName', sprintf('$\\varrho_T = %0.2f$, $\\chi =  %0.2f$',B.varrho,B.scl));
elseif uncertainty_comp == 2    
plot(time_vec,tax_iters,'-k','LineWidth',3, 'DisplayName', sprintf('$\\varrho_T = %0.3f$, $\\chi =  %0.2f$',varrho,scl));
hold on
plot(time_vec,B.tax_iters,':k','LineWidth',3, 'DisplayName', sprintf('$\\varrho_T = %0.3f$, $\\chi =  %0.2f$',B.varrho,B.scl));
end
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
if uncertainty_comp == 1
print('ccap_tax_partial1','-dpng')
elseif uncertainty_comp == 2
print('ccap_tax_partial2','-dpng')
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

figure
if uncertainty_comp == 1
plot(time_vec,probb2_iters,'-k','LineWidth',3, 'DisplayName', sprintf('$\\varrho_T = %0.2f$, $\\chi =  %0.2f$',varrho,scl));
hold on
plot(time_vec,B.probb2_iters,':k','LineWidth',3, 'DisplayName', sprintf('$\\varrho_T = %0.2f$, $\\chi =  %0.2f$',B.varrho,B.scl));
elseif uncertainty_comp == 2    
plot(time_vec,probb2_iters,'-k','LineWidth',3, 'DisplayName', sprintf('$\\varrho_T = %0.3f$, $\\chi =  %0.2f$',varrho,scl));
hold on
plot(time_vec,B.probb2_iters,':k','LineWidth',3, 'DisplayName', sprintf('$\\varrho_T = %0.3f$, $\\chi =  %0.2f$',B.varrho,B.scl));
end
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
if uncertainty_comp == 1
print('ccap_probb_partial1','-dpng')
elseif uncertainty_comp == 2
print('ccap_probb_partial2','-dpng')
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

figure
if uncertainty_comp == 1
plot(time_vec,MPR_iters,'Color',color1,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Total, $\\varrho_T = %0.2f$, $\\chi =  %0.2f$',varrho,scl));
hold on
plot(time_vec,B.MPR_iters,'Color',color1,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Total, $\\varrho_T = %0.2f$, $\\chi =  %0.2f$',B.varrho,B.scl));
plot(time_vec,MPR_T_iters+MPR_Gamma_iters,'Color',color2,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Climate, $\\varrho_T = %0.2f$, $\\chi =  %0.2f$',varrho,scl));
plot(time_vec,B.MPR_T_iters+B.MPR_Gamma_iters,'Color',color2,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Climate, $\\varrho_T = %0.2f$, $\\chi =  %0.2f$',B.varrho,B.scl));
elseif uncertainty_comp == 2    
plot(time_vec,MPR_iters,'Color',color1,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Total, $\\varrho_T = %0.3f$, $\\chi =  %0.2f$',varrho,scl));
hold on
plot(time_vec,B.MPR_iters,'Color',color1,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Total, $\\varrho_T = %0.3f$, $\\chi =  %0.2f$',B.varrho,B.scl));
plot(time_vec,MPR_T_iters+MPR_Gamma_iters,'Color',color2,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Climate, $\\varrho_T = %0.3f$, $\\chi =  %0.2f$',varrho,scl));
plot(time_vec,B.MPR_T_iters+B.MPR_Gamma_iters,'Color',color2,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Climate, $\\varrho_T = %0.3f$, $\\chi =  %0.2f$',B.varrho,B.scl));
end
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
if uncertainty_comp == 1
print('ccap_mpr_partial1','-dpng')
elseif uncertainty_comp == 2
print('ccap_mpr_partial2','-dpng')
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
if uncertainty_comp == 1

elseif uncertainty_comp == 2    

end
figure
if uncertainty_comp == 1
plot(time_vec,MPU_T_iters+MPU_Gamma_iters,'Color',color2,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Climate, $\\varrho_T = %0.2f$, $\\chi =  %0.2f$',varrho,scl));
hold on
plot(time_vec,MPU_T_iters,'Color',color3,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Temperature, $\\varrho_T = %0.2f$, $\\chi =  %0.2f$',varrho,scl));
plot(time_vec,MPU_Gamma_iters,'Color',color7,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Damages, $\\varrho_T = %0.2f$, $\\chi =  %0.2f$',varrho,scl));
plot(time_vec,B.MPU_T_iters+B.MPU_Gamma_iters,'Color',color2,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Climate, $\\varrho_T = %0.2f$, $\\chi =  %0.2f$',B.varrho,B.scl));
plot(time_vec,B.MPU_T_iters,'Color',color3,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Temperature, $\\varrho_T = %0.2f$, $\\chi =  %0.2f$',B.varrho,B.scl));
plot(time_vec,B.MPU_Gamma_iters,'Color',color7,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Damages, $\\varrho_T = %0.2f$, $\\chi =  %0.2f$',B.varrho,B.scl));
elseif uncertainty_comp == 2    
plot(time_vec,MPU_T_iters+MPU_Gamma_iters,'Color',color2,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Climate, $\\varrho_T = %0.3f$, $\\chi =  %0.2f$',varrho,scl));
hold on
plot(time_vec,MPU_T_iters,'Color',color3,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Temperature, $\\varrho_T = %0.3f$, $\\chi =  %0.2f$',varrho,scl));
plot(time_vec,MPU_Gamma_iters,'Color',color7,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Damages, $\\varrho_T = %0.3f$, $\\chi =  %0.2f$',varrho,scl));
plot(time_vec,B.MPU_T_iters+B.MPU_Gamma_iters,'Color',color2,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Climate, $\\varrho_T = %0.3f$, $\\chi =  %0.2f$',B.varrho,B.scl));
plot(time_vec,B.MPU_T_iters,'Color',color3,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Temperature, $\\varrho_T = %0.3f$, $\\chi =  %0.2f$',B.varrho,B.scl));
plot(time_vec,B.MPU_Gamma_iters,'Color',color7,'LineStyle',':','LineWidth',3, 'DisplayName', sprintf('Damages, $\\varrho_T = %0.3f$, $\\chi =  %0.2f$',B.varrho,B.scl));
end
% title('Climate Uncertainty Prices')
ylabel('Prices')
xlabel('Year')
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
hl = legend('show');
set(hl, 'Interpreter', 'latex', 'Location', 'northeast');
if uncertainty_comp == 1
axis([initial_time,2100,-0.05,0.05])
elseif uncertainty_comp == 2
axis([initial_time,2100,-0.1,0.1])
end
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
if uncertainty_comp == 1
print('ccap_mpu_partial','-dpng')
elseif uncertainty_comp == 2
print('ccap_mpu_partial2','-dpng')
end

