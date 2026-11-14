% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % Baseline Simulation Code
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

% Set to 1 to simulate model with climate model uncertainty
% Set to 0 to simulate model without climate model uncertainty
uncertainty_sim = 1;

if uncertainty_sim == 0
filename3 = [directory, '\CCAP_HJB_2D_No_T_Uncertainty'];
elseif uncertainty_sim == 1
filename3 = [directory, '\CCAP_HJB_2D_T_Uncertainty'];
end

load(filename3);

filename4 = [filename3,'_Sims'];

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % Initial Values
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

lambda = 0.00173;
T_0 = 1.0;
T2_0 = 0.0025;

T = 80*4; 
pers = T; 
dt = T/pers;

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % Detection Error Probability Bound Set-Up
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

MPU_sq = ((1./varrho2).*sigma_a).^2+((1./varrho).*sigma_t.*(v0_dt-(gamma_1+gamma_2.*t_mat+bar_gamma_2_plus.*(t_mat-tau).*(t_mat-tau>0)))).^2;
cherr2 = (1./8).*(MPU_sq);
probb2 = 0.5.*exp(-200.*cherr2);
% probb2 = 0.5.*exp(-400.*cherr2);


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % Drift and volatility functions
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

tax = 1 - (O.^(1./alpha_O-eps))./((nu.*alpha_O.*(A_O.^(1./alpha_O))./(1-alpha-nu)).*(fo_labor)./(E.^eps));

O_star = real(O);
G_star = real(G);

% randn('state',100)           % set the state of randn
% rand('state',105);          % set the state of randn
Ofunc = griddedInterpolant(t_mat,t2_mat,O_star,'spline');
Gfunc = griddedInterpolant(t_mat,t2_mat,G_star,'spline');

O_func = @(x) Ofunc(x(:,1:2));
G_func = @(x) Gfunc(x(:,1:2));

%%%Create function handle for the drifts
muT = @(x) x(:,2);
muT2 = @(x) lam.*(-x(:,2)+lambda.*O_func(x(:,1:2)));
drifts = @(x) [muT(x),muT2(x)];

%%%Create function handles for the vols
sigmaT = @(x) sigma_t;
sigmaT2 = @(x) sigma_t2;

vols = @(x) [sigmaT(x),sigmaT2(x)];

%%%set bounds
upperBounds = [t_max,t2_max];
lowerBounds = [t_min,t2_min];

nDims = 2;
% its = 10000;
its = 1;
% its = 500;
% stop

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
hist(1,:) = [T_0,T2_0];

O_hist(1,:) = O_func(hist(1,:)); 
G_hist(1,:) = G_func(hist(1,:)); 

for j = 2:pers

% shock = normrnd(0,sqrt(dt), 1, nDims);
shock = zeros(1, nDims);
hist(j,1) = max(min(hist(j-1,1) + muT(hist(j-1,:)) * dt + sigmaT(hist(j-1,:)).* shock(:,1), upperBounds(:,1)), lowerBounds(:,1));
hist(j,2) = max(min(hist(j-1,2) + muT2(hist(j-1,:)) * dt + sigmaT2(hist(j-1,:)).* shock(:,2), upperBounds(:,2)), lowerBounds(:,2));

O_hist(j) =  O_func(hist(j-1,:));
G_hist(j) =  G_func(hist(j-1,:));

end

hists(:,:,iters) = hist;
O_hists(:,iters) = O_hist;
G_hists(:,iters) = G_hist;
   
end
toc


Tp_iters = squeeze(hists(:,1,:))';
T2p_iters = squeeze(hists(:,2,:))';
Op_iters = squeeze(O_hists)';
Gp_iters = squeeze(G_hists)';

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % Asset Pricing Calculations
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

MPR_iters=interpn(t_mat,t2_mat,MPR(:,:),Tp_iters,T2p_iters,'spline');
MPR_T_iters=interpn(t_mat,t2_mat,MPR_T(:,:),Tp_iters,T2p_iters,'spline');
MPR_Gamma_iters = interpn(t_mat,t2_mat,MPR_Gamma(:,:),Tp_iters,T2p_iters,'spline');
MPR_A_iters = interpn(t_mat,t2_mat,MPR_A(:,:),Tp_iters,T2p_iters,'spline');

r_t_iters=interpn(t_mat,t2_mat,r_t(:,:),Tp_iters,T2p_iters,'spline');

tax_iters=interpn(t_mat,t2_mat,tax(:,:),Tp_iters,T2p_iters,'spline');

probb2_iters=interpn(t_mat,t2_mat,probb2(:,:),Tp_iters,T2p_iters,'spline');


toc;

% stop
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

figure
plot(time_vec,Tp_iters,'Color',color2,'LineWidth',3,'LineStyle','-', 'DisplayName', sprintf('$\\varrho_T = %0.2f$',varrho));
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
print('ccap_temp_2d','-dpng')

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

figure
plot(time_vec,T2p_iters,'Color',color2,'LineWidth',3,'LineStyle','-', 'DisplayName', sprintf('$\\varrho_T = %0.2f$',varrho));
% title('Temperature')
ylabel('T_t')
xlabel('Year')
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
hl = legend('show');
set(hl, 'Interpreter', 'latex', 'Location', 'northwest');
axis([initial_time,2100,0,0.02])
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
print('ccap_temp2_2d','-dpng')


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 


fig = figure; 
left_color = [0 0 0];
right_color = [0 0 0];
set(fig,'defaultAxesColorOrder',[left_color; right_color]);
yyaxis left
hold on
plot(time_vec,Tp_iters,'Color',color2,'LineWidth',3,'LineStyle','-', 'DisplayName', sprintf('$T_{1,t}, \\varrho_T = %0.2f$',varrho));
% title('Temperature')
ylabel('T_{1,t}')
xlabel('Year')
axis([initial_time,2100,0,2.5])
yyaxis right
plot(time_vec,T2p_iters,'Color',color2,'LineWidth',3,'LineStyle','-.', 'DisplayName', sprintf('$T_{2,t}, \\varrho_T = %0.2f$',varrho));
axis([initial_time,2100,0,0.01])
ylabel('T_{2,t}')
% legend('T_{1,t}','T_',...
%     'Counterfactual, $\lambda = 0$ (Planner)',...
%     'Location','northwest
hl = legend('show');
set(hl, 'Interpreter', 'latex', 'Location', 'northeast');
set(findall(gcf,'type','axes'),'fontsize',16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold')
print('ccap_temp_all_2d','-dpng')

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 


figure
plot(time_vec,Op_iters,'-k','LineWidth',3, 'DisplayName', sprintf('$B_t, \\varrho_T = %0.2f$',varrho));
hold on
plot(time_vec,Gp_iters,'Color',color5,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('$G_t, \\varrho_T = %0.2f$',varrho));
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
print('ccap_input_2d','-dpng')

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 


total_energy = Op_iters+Gp_iters;


figure
plot(time_vec,Op_iters./total_energy,'-k','LineWidth',3, 'DisplayName', sprintf('Dirty, $\\varrho_T = %0.2f$',varrho));
hold on
plot(time_vec,Gp_iters./total_energy,'Color',color5,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Clean, $\\varrho_T = %0.2f$',varrho));
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
print('ccap_input_fraction_2d','-dpng')

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

figure
plot(time_vec,tax_iters,'-k','LineWidth',3, 'DisplayName', sprintf('$\\varrho_T = %0.2f$',varrho));
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
print('ccap_tax_2d','-dpng')

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

figure
plot(time_vec,probb2_iters,'-k','LineWidth',3, 'DisplayName', sprintf('$\\varrho_T = %0.2f$',varrho));
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
print('ccap_probb_2d','-dpng')

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

figure
plot(time_vec,MPR_iters,'Color',color1,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Total, $\\varrho_T = %0.2f$',varrho));
hold on
plot(time_vec,MPR_T_iters+MPR_Gamma_iters,'Color',color2,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Climate, $\\varrho_T = %0.2f$',varrho));
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
print('ccap_mpr_2d','-dpng')

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

figure
% plot(time_vec,zeros(size(Tp_iters)).*(MPR_T_iters+MPR_Gamma_iters),'Color',color2,'LineStyle','-','LineWidth',3, 'DisplayName', sprintf('Climate, $\\varrho_T = \\infty$',B.varrho));
hold on
plot(time_vec,MPR_T_iters+MPR_Gamma_iters,'Color',color2,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Climate, $\\varrho_T = %0.2f$',varrho));
plot(time_vec,MPR_T_iters,'Color',color3,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Temperature, $\\varrho_T = %0.2f$',varrho));
plot(time_vec,MPR_Gamma_iters,'Color',color7,'LineStyle','-.','LineWidth',3, 'DisplayName', sprintf('Damages, $\\varrho_T = %0.2f$',varrho));
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
print('ccap_mpr_climate_2d','-dpng')
