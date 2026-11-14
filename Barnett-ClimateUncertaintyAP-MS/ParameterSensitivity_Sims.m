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

% Set to 1 to solve first parameter case 
% Set to 2 to solve second parameter case 
% Set to 3 to solve second parameter case 
% Set to 4 to solve second parameter case 
% Set to 5 to solve second parameter case 
parameter_case = 1;

% Set to 1 to solve first parameter case 
% Set to 2 to solve second parameter case 
parameter_val = 2;

if parameter_case == 1
if parameter_val == 1
filename3 = [directory, '\CCAP_HJB_T_Uncertainty_Omega0pt25'];
elseif parameter_val == 2
filename3 = [directory, '\CCAP_HJB_T_Uncertainty_Omega0pt85']; % only got 0.085
end

elseif parameter_case == 2
if parameter_val == 1
filename3 = [directory, '\CCAP_HJB_T_Uncertainty_SigmaT0pt04'];
elseif parameter_val == 2
filename3 = [directory,'\CCAP_HJB_T_Uncertainty_SigmaT0pt06']; % only got 0.075
end

elseif parameter_case == 3
if parameter_val == 1
filename3 = [directory, '\CCAP_HJB_T_Uncertainty_Tau1pt5'];
elseif parameter_val == 2
filename3 = [directory, '\CCAP_HJB_T_Uncertainty_Tau2pt5'];
end

elseif parameter_case == 4
if parameter_val == 1
filename3 = [directory, '\CCAP_HJB_T_Uncertainty_G2P0pt0'];
elseif parameter_val == 2
filename3 = [directory, '\CCAP_HJB_T_Uncertainty_G2P0pt0295'];
end

elseif parameter_case == 5
if parameter_val == 1
filename3 = [directory, '\CCAP_HJB_T_Uncertainty_Lambda1pt5'];
elseif parameter_val == 2
filename3 = [directory, '\CCAP_HJB_T_Uncertainty_Lambda2pt0'];
end

end


load(filename3);

filename4 = [filename3,'_Sims'];

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % Initial Values
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

T_0 = 1.0;

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

hist(1,:) = hist(1,:);

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
MPR_A_iters=interpn(t_mat,MPR_A(:,:).*(ones(size(t_mat))),Tp_iters,'spline');

MPROG_iters=interpn(t_mat,MPR_OG(:,:),Tp_iters,'spline');
MPU_iters=interpn(t_mat,MPU(:,:),Tp_iters,'spline');
MPU_T_iters=interpn(t_mat,MPU_T(:,:),Tp_iters,'spline');

% MPR_A
MPR_Gamma_iters = interpn(t_mat,MPR_Gamma(:,:),Tp_iters,'spline');
MPU_A_iters = interpn(t_mat,MPU_A(:,:),Tp_iters,'spline');
MPU_Gamma_iters = interpn(t_mat,MPU_Gamma(:,:),Tp_iters,'spline');
relative_entropy_iters = interpn(t_mat,relative_entropy(:,:),Tp_iters,'spline');

r_t_iters=interpn(t_mat,r_t(:,:),Tp_iters,'spline');

tax_iters=interpn(t_mat,tax(:,:),Tp_iters,'spline');

probb2_iters=interpn(t_mat,probb2(:,:),Tp_iters,'spline');

toc;

save(filename4);

