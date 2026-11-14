% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % EZ Simulation Code
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
close all
clear all
clc

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % Set-up Simulations and Filename
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
set(0,'defaulttextinterpreter','tex')
set(0, 'defaultAxesTickLabelInterpreter','tex'); 
set(0, 'defaultLegendInterpreter','tex');

directory = pwd;

filename3 = [directory, '\CCAP_HJB_EZ'];

load(filename3);

filename4 = [filename3,'_Sims'];

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % Initial Values
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

lambda = 0.00173;
T_0 = 1.0;

T = 80*4; 
pers = T; 
dt = T/pers;

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % Detection Error Probability Bound Set-Up
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

tax = 1 - (O.^(1./alpha_O-eps))./((nu.*alpha_O.*(A_O.^(1./alpha_O))./(1-alpha-nu)).*(fo_labor)./(E.^eps));

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % Drift and volatility functions
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
Ofunc = griddedInterpolant(t_mat,O_star,'spline');
Gfunc = griddedInterpolant(t_mat,G_star,'spline');

O_func = @(x) Ofunc(x(:,1));
G_func = @(x) Gfunc(x(:,1));

%%%Create function handle for the drifts
muT = @(x) lambda.*O_func(x(:,1));
drifts = @(x) [muT(x)];

%%%Create function handles for the vols
sigmaT = @(x) sigma_t;

vols = @(x) [sigmaT(x)];

%%%set bounds
upperBounds = [t_max];
lowerBounds = [t_min];

nDims = 1;
% its = 10000;
its = 1;

%%%set up cell to store simulation data
hists = zeros(pers,nDims,its);
O_hists = zeros(pers,its);
G_hists = zeros(pers,its);

tic

% parfor iters = 1:its
for iters = 1:1
    
%%%Preallocate for history
hist = zeros(pers,nDims);
O_hist = zeros(pers,1);
G_hist = zeros(pers,1);

%%%Fill in first point
hist(1,:) = [T_0];

O_hist(1,:) = O_func(hist(1,1)); 
G_hist(1,:) = G_func(hist(1,1)); 

for j = 2:pers

% shock = normrnd(0,sqrt(dt), 1, nDims);
shock = zeros(1, nDims);
hist(j,1) = max(min(hist(j-1,1) + muT(hist(j-1,:)) * dt + sigmaT(hist(j-1,:)).* shock(:,1), upperBounds(:,1)), lowerBounds(:,1));

O_hist(j) =  O_func(hist(j-1,1));
G_hist(j) =  G_func(hist(j-1,1));

end

hists(:,:,iters) = hist;
O_hists(:,iters) = O_hist;
G_hists(:,iters) = G_hist;
   
end
toc


Tp_iters = squeeze(hists(:,1,:))';
Op_iters = squeeze(O_hists)';
Gp_iters = squeeze(G_hists)';

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % Asset Pricing Calculations
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

MPR_iters=interpn(t_mat,MPR(:,:),Tp_iters,'spline');
MPR_T_iters=interpn(t_mat,MPR_T(:,:),Tp_iters,'spline');
MPR_Gamma_iters = interpn(t_mat,MPR_Gamma(:,:),Tp_iters,'spline');
MPR_A_iters = interpn(t_mat,MPR_A(:,:),Tp_iters,'spline');
r_t_iters=interpn(t_mat,r_t(:,:),Tp_iters,'spline');
tax_iters=interpn(t_mat,tax(:,:),Tp_iters,'spline');


toc;

save(filename4);

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
plot(time_vec,Tp_iters,'Color',color2,'LineWidth',3,'LineStyle','-', 'DisplayName', sprintf('$\\xi = %0.2f$',gammad));
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
print('ccap_temp_ez2','-dpng')

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

figure
plot(time_vec,Op_iters,'-k','LineWidth',3, 'DisplayName', sprintf('$B_t, \\xi = %0.2f$',gammad));
hold on
plot(time_vec,Gp_iters,'Color',color5,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('$G_t, \\xi = %0.2f$',gammad));
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
print('ccap_input_ez2','-dpng')

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

total_energy = Op_iters+Gp_iters;

figure
plot(time_vec,Op_iters./total_energy,'-k','LineWidth',3, 'DisplayName', sprintf('Dirty, $\\xi = %0.2f$',gammad));
hold on
plot(time_vec,Gp_iters./total_energy,'Color',color5,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Clean, $\\xi = %0.2f$',gammad));
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
print('ccap_input_fraction_ez2','-dpng')

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
figure
plot(time_vec,tax_iters,'-k','LineWidth',3, 'DisplayName', sprintf('$\\xi = %0.2f$',gammad));
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
print('ccap_tax_ez2','-dpng')
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 


figure
plot(time_vec,MPR_iters,'Color',color1,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Total, $\\xi = %0.2f$',gammad));
hold on
plot(time_vec,MPR_T_iters+MPR_Gamma_iters,'Color',color2,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Climate, $\\xi = %0.2f$',gammad));
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
print('ccap_mpr_ez2','-dpng')

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

figure
% plot(time_vec,zeros(size(Tp_iters)).*(MPR_T_iters+MPR_Gamma_iters),'Color',color2,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Climate, $\\varrho = \\infty$',B.varrho));
hold on
plot(time_vec,MPR_T_iters+MPR_Gamma_iters,'Color',color2,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Climate, $\\xi = %0.2f$',gammad));
plot(time_vec,MPR_T_iters,'Color',color3,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Temperature, $\\xi = %0.2f$',gammad));
plot(time_vec,MPR_Gamma_iters,'Color',color7,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Damages, $\\xi = %0.2f$',gammad));
% title('Climate Risk Prices')
ylabel('Prices')
xlabel('Year')
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
hl = legend('show');
set(hl, 'Interpreter', 'latex', 'Location', 'northeast');
axis([initial_time,2100,-0.03,0.02])
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
print('ccap_mpr_climate_ez2','-dpng')
