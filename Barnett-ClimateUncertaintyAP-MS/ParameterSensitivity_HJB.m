% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % Parameter Sensitivity HJB Code
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

close all
clear all
clc

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % Set-up Solver and Filename
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% addpath('[add pathname here]')
mex solveCGNatural_1e10.cpp;

% Set to 1 to use saved solution as ``smart guess'' for initial value function
% Set to 0 to use pre-specified function as guess for initial value function
smartguess = 0;

% Set to 1 to solve first parameter case 
% Set to 2 to solve second parameter case 
% Set to 3 to solve second parameter case 
% Set to 4 to solve second parameter case 
% Set to 5 to solve second parameter case 
parameter_case = 1;

% Set to 1 to solve first parameter case 
% Set to 2 to solve second parameter case 
parameter_val = 1;

% scl = 1.0 solves model with full climate externality internalization
scl = 1.0;

directory = pwd;
filename = [directory, '\CCAP_HJB_Baseline_T_Uncertainty'];
load(filename);

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % Parameter Sensitivity Case
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
if parameter_case == 1
if parameter_val == 1
filename2 = [directory, '\CCAP_HJB_T_Uncertainty_Omega0pt25'];
eps = 0.25;
elseif parameter_val == 2
filename2 = [directory, '\CCAP_HJB_T_Uncertainty_Omega0pt85']; % only got 0.085
eps = 0.85;
end

elseif parameter_case == 2
if parameter_val == 1
filename2 = [directory, '\CCAP_HJB_T_Uncertainty_SigmaT0pt04'];
sigma_t = 0.035;
elseif parameter_val == 2
filename2 = [directory,'\CCAP_HJB_T_Uncertainty_SigmaT0pt06']; % only got 0.075
sigma_t = 0.06;
end

elseif parameter_case == 3
if parameter_val == 1
filename2 = [directory, '\CCAP_HJB_T_Uncertainty_Tau1pt5'];
tau = 1.5;
elseif parameter_val == 2
filename2 = [directory, '\CCAP_HJB_T_Uncertainty_Tau2pt5'];
tau = 2.5;
end

elseif parameter_case == 4
if parameter_val == 1
gamma_2_plus = 0.0 .* 0.0197;
filename2 = [directory, '\CCAP_HJB_T_Uncertainty_G2P0pt0'];
elseif parameter_val == 2
gamma_2_plus = 1.5 .* 0.0197;
filename2 = [directory, '\CCAP_HJB_T_Uncertainty_G2P0pt0295'];
end

weight = 1.0;
bar_gamma_2_plus = gamma_2_plus * weight;

elseif parameter_case == 5
if parameter_val == 1
filename2 = [directory, '\CCAP_HJB_T_Uncertainty_Lambda1pt5'];
lambda_val = 0.0015;
elseif parameter_val == 2
filename2 = [directory, '\CCAP_HJB_T_Uncertainty_Lambda2pt0'];
lambda_val = 0.002;
end
lambda = scl.*lambda_val;
lambda_noscl = lambda_val;
end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Convergence parameters
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
relax2 = 0.75;
relax = 0.95;

tol = 1e-15;
dt = 0.5;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % State Space Set-Up
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
t_min = 0;
t_max = 5;

nt = 250;
t = linspace(t_min,t_max,nt)';
ht = t(2) - t(1);
t_mat = t;

step_val2 = round(length(t)./5);

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % Initial Guess
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
if smartguess == 1
v0 = interpn(SmartGuess.t_mat,SmartGuess.v0,t_mat);
else
v0 = -gamma_1.*t_mat;
% v0 = zeros(size(t_mat));
end

v1_initial = v0.*ones(size(t_mat)); %% initial guess
out = v0;

%%% for first iter
    v0 = v0.*ones(size(v0));
    v0 = reshape(out,size(v0));
    
    v0_dt = zeros(size(v0));
    v0_dt(2:end-1) = (1./(2.*ht)).*(v0(3:end)-v0(1:end-2));
    v0_dt(end) = (1./ht).*(v0(end)-v0(end-1));
    v0_dt(1) = (1./ht).*(v0(2)-v0(1));
      
    v0_dtt = zeros(size(v0));
    v0_dtt(2:end-1) = (1./(ht.^2)).*(v0(3:end)+v0(1:end-2)-2.*v0(2:end-1));
    v0_dtt(end) = (1./(ht.^2)).*(v0(end)+v0(end-2)-2.*v0(end-1));
    v0_dtt(1) = (1./(ht.^2)).*(v0(3)+v0(1)-2.*v0(2));

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % FOC
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
    O = O_init./(1+t_mat);
    G = G_init;
    L_O = (O./A_O).^(1./alpha_O);
    L_G = (G./A_G).^(1./alpha_G);
    L_C = (1- L_O - L_G).*ones(size(t_mat));

if smartguess == 1
O_star = real(interpn(SmartGuess.t_mat,SmartGuess.O,t_mat));
G_star = real(interpn(SmartGuess.t_mat,SmartGuess.G,t_mat));
else
O_star = O;
G_star = G;
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % PDE Solver
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
   out_comp = zeros(size(t_mat));
   iter = 0;
    
   vold = 100 .* ones(size(v0));

   mu_T = zeros(size(t_mat));
   mu_T_old = 100.*ones(size(t_mat));

   outer_loop_iters = 0;
   tol_drift = 1e-8;
    
   B_t = zeros(size(t_mat));  
   
   timeDerivative = [];
   
while (max(max(abs(mu_T - mu_T_old)))) > tol_drift
             
while (max(max(max(abs(out_comp - vold) / dt)))) > tol
    tic
    vold = v0 .* ones(size(v0));

    v0_dt = zeros(size(v0));
    v0_dt(2:end-1) = (1./(2.*ht)).*(v0(3:end)-v0(1:end-2));
    v0_dt(end) = (1./ht).*(v0(end)-v0(end-1));
    v0_dt(1) = (1./ht).*(v0(2)-v0(1));

        
    v0_dtt = zeros(size(v0));
    v0_dtt(2:end-1) = (1./(ht.^2)).*(v0(3:end)+v0(1:end-2)-2.*v0(2:end-1));
    v0_dtt(end) = (1./(ht.^2)).*(v0(end)+v0(end-2)-2.*v0(end-1));
    v0_dtt(1) = (1./(ht.^2)).*(v0(3)+v0(1)-2.*v0(2));

    %%%%%%% FOC_all combinations
    O = O_star;
    G = G_star;
    
    L_C = 1- L_O - L_G;

    
    util_val= (rho);

    E = (kappa_O.*O.^eps+kappa_G.*G.^eps).^(1./eps);
    Xi = lambda.*(v0_dt-(gamma_1+gamma_2.*t_mat+bar_gamma_2_plus.*(t_mat-tau).*(t_mat-tau>0))).*(util_val.^(-1)).*(kappa_O.*alpha_O.*(A_O.^(1./alpha_O)).*L_C.*(O.^(1-eps))./(1-alpha-nu));
    G_star = (nu.*kappa_G.*alpha_G.*(A_G.^(1./alpha_G))./(1-alpha-nu).*(L_C./(E.^eps))).^(1./(1./alpha_G-eps));
    O_star = (nu.*kappa_O.*alpha_O.*(A_O.^(1./alpha_O))./(1-alpha-nu).*(L_C./(E.^eps))+Xi).^(1./(1./alpha_O-eps));
    
    O_star = relax.*O + (1-relax).*O_star;
    G_star = relax.*G + (1-relax).*G_star;
     

    %%%%%%%% PDE inputs %%%%%%%%%%%
    
    A = -rho.*ones(size(t_mat));
    B_t = lambda.*O_star+mu_T;    
    C_tt = 0.5.*sigma_t.^2.*ones(size(t_mat));
   
    D = rho.*log(A_C.*((1-(O_star./A_O).^(1./alpha_O)-(G_star./A_G).^(1./alpha_G)).^(1-alpha-nu)).*(((O_star.^eps).*kappa_O+(G_star.^eps).*kappa_G).^(nu./eps))) ...
        -(gamma_1+gamma_2.*t_mat+bar_gamma_2_plus.*(t_mat-tau).*(t_mat-tau>0)).*lambda.*O -0.5.*(gamma_2+bar_gamma_2_plus.*(t_mat-tau>0)).*(sigma_t.^2) ...
        -(1./(2.*varrho)).*((v0_dt-(gamma_1+gamma_2.*t_mat+bar_gamma_2_plus.*(t_mat-tau).*(t_mat-tau>0))).^2).*(sigma_t.^2)...
        -(1./(2.*varrho2)).*(sigma_a.^2)+(mu_a-0.5.*(sigma_a.^2));
    
     %%% create stateSpace and model
    stateSpace = [t_mat(:)]; %% vectorizing state space; this would correspond as the domain argument in the mex file
    model      = {};
    model.A    = A(:); 
    model.B    = [B_t(:)];
    model.C    = [C_tt(:)];
    model.D    = D(:);
    model.v0   = v0(:);
    model.dt   = dt;
    %%% solve linear through mex fnction
    out = solveCGNatural_1e10(stateSpace, model);
    out_comp = reshape(out,size(v0)).*ones(size(t_mat));
    
    iter = iter+1;
    disp(['Diff: ', num2str(max(max(max(abs(out_comp - vold) / dt)))),' Number of Iters: ',num2str(iter)])
    timeDerivative = [timeDerivative max(max(max(abs(out_comp - vold) / dt)))];
         
    v0 = v0.*ones(size(v0));
    v0 = reshape(out,size(v0));


    pde_error = A.*v0+B_t.*v0_dt+C_tt.*v0_dtt+D;
    disp(['PDE Error: ', num2str(max(max(max(abs(pde_error)))))])
    
    if iter > 50000
        dt = 0.001;
    end
    
    if (max(max(abs(out_comp - vold) / dt))) < tol
        fprintf('PDE Converges');
    end
    
    toc
end

mu_T_old = mu_T;
mu_T = (1-scl).*lambda_noscl.*O_star;
(max(max(abs(mu_T - mu_T_old))))


    vold = 100;
    out_comp = 1;

outer_loop_iters = outer_loop_iters+1  

iter = 0;


end


save(filename2);

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Asset pricing calculations
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Labor
L_O = (O./A_O).^(1./alpha_O);
L_G = (G./A_G).^(1./alpha_G);
L_C = 1- L_O - L_G;

fo_labor = L_C;
green_labor = L_G;
oil_labor = L_O;


% Output
% Final output labor and energy amalgam
E_C = (kappa_O.*O.^eps+kappa_G.*G.^eps).^(1./eps);
L = L_C;
E = E_C;
Y = A_C.*((L_C).^(1-alpha-nu)).*(E_C.^(nu));

Y_dT = zeros(size(Y));
Y_dT(2:end-1) = (1./(2.*ht)).*(Y(3:end)-Y(1:end-2));
Y_dT(end) = (1./ht).*(Y(end)-Y(end-1));
Y_dT(1) = (1./ht).*(Y(2)-Y(1));

Y_dTT = zeros(size(Y));
Y_dTT(2:end-1) = (1./(ht.^2)).*(Y(3:end)+Y(1:end-2)-2.*Y(2:end-1));
Y_dTT(end) = (1./(ht.^2)).*(Y(end)+Y(end-2)-2.*Y(end-1));
Y_dTT(1) = (1./(ht.^2)).*(Y(3)+Y(1)-2.*Y(2));

% O = real(O);
% G = real(G);

O_dT = zeros(size(O));
O_dT(2:end-1) = (1./(2.*ht)).*(O(3:end)-O(1:end-2));
O_dT(end) = (1./ht).*(O(end)-O(end-1));
O_dT(1) = (1./ht).*(O(2)-O(1));

O_dTT = zeros(size(O));
O_dTT(2:end-1) = (1./(ht.^2)).*(O(3:end)+O(1:end-2)-2.*O(2:end-1));
O_dTT(end) = (1./(ht.^2)).*(O(end)+O(end-2)-2.*O(end-1));
O_dTT(1) = (1./(ht.^2)).*(O(3)+O(1)-2.*O(2));

G_dT = zeros(size(G));
G_dT(2:end-1) = (1./(2.*ht)).*(G(3:end)-G(1:end-2));
G_dT(end) = (1./ht).*(G(end)-G(end-1));
G_dT(1) = (1./ht).*(G(2)-G(1));

G_dTT = zeros(size(G));
G_dTT(2:end-1) = (1./(ht.^2)).*(G(3:end)+G(1:end-2)-2.*G(2:end-1));
G_dTT(end) = (1./(ht.^2)).*(G(end)+G(end-2)-2.*G(end-1));
G_dTT(1) = (1./(ht.^2)).*(G(3)+G(1)-2.*G(2));

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
v_null = v0;
v_dT = v0_dt;
v_dTT = v0_dtt;

J = v_null;
J_T = v_dT;
J_TT = v_dTT;

% MPR                 
h_J =  -rho;

omega_T = (-(Y_dT)./Y);
omega_TT = 2.*(Y_dT./Y).^2 -(Y_dTT./Y);

r_t = -h_J +(mu_a - (1./varrho2).*(sigma_a.^2)) ...
    - omega_T.*(lambda.*O -(1./varrho).*(v0_dt-(gamma_1+gamma_2.*t_mat+bar_gamma_2_plus.*(t_mat-tau).*(t_mat-tau>0))).*(sigma_t.^2)) ...
    -0.5.*omega_TT.*(sigma_t.^2)...
    +(gamma_1+gamma_2.*t_mat+bar_gamma_2_plus.*(t_mat-tau).*(t_mat-tau>0)).*lambda.*O...
    -0.5.*(gamma_2+bar_gamma_2_plus.*(t_mat-tau>0)).*(sigma_t.^2)...
    +(1./varrho).*(gamma_1+gamma_2.*t_mat+bar_gamma_2_plus.*(t_mat-tau).*(t_mat-tau>0)).*(v0_dt-(gamma_1+gamma_2.*t_mat+bar_gamma_2_plus.*(t_mat-tau).*(t_mat-tau>0))).*(sigma_t.^2)...
    -((gamma_1+gamma_2.*t_mat+bar_gamma_2_plus.*(t_mat-tau).*(t_mat-tau>0)).^2).*(sigma_t.^2);  

r_t_dmg = (gamma_1+gamma_2.*t_mat+bar_gamma_2_plus.*(t_mat-tau).*(t_mat-tau>0)).*lambda.*O...
    -0.5.*(gamma_2+bar_gamma_2_plus.*(t_mat-tau>0)).*(sigma_t.^2)...
    +(1./varrho).*(gamma_1+gamma_2.*t_mat+bar_gamma_2_plus.*(t_mat-tau).*(t_mat-tau>0)).*(v0_dt-(gamma_1+gamma_2.*t_mat+bar_gamma_2_plus.*(t_mat-tau).*(t_mat-tau>0))).*(sigma_t.^2)...
    -((gamma_1+gamma_2.*t_mat+bar_gamma_2_plus.*(t_mat-tau).*(t_mat-tau>0)).^2).*(sigma_t.^2);

r_t_a = (-h_J +(mu_a - (1./varrho2).*(sigma_a.^2))).*ones(size(t_mat));

r_t_t = - omega_T.*(lambda.*O -(1./varrho).*(v0_dt-(gamma_1+gamma_2.*t_mat+bar_gamma_2_plus.*(t_mat-tau).*(t_mat-tau>0))).*(sigma_t.^2)) ...
    -0.5.*omega_TT.*(sigma_t.^2); 

r_t_t_1 = - omega_T.*(lambda.*O -(1./varrho).*(v0_dt-(gamma_1+gamma_2.*t_mat+bar_gamma_2_plus.*(t_mat-tau).*(t_mat-tau>0))).*(sigma_t.^2)); 

r_t_t_2 =-0.5.*omega_TT.*(sigma_t.^2); 

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %        

MPR = sigma_a.*(1 + (1./varrho2)) - omega_T.*sigma_t - (gamma_1+gamma_2.*t_mat+bar_gamma_2_plus.*(t_mat-tau).*(t_mat-tau>0)).*sigma_t...
    + (1./varrho).*sigma_t.*(v0_dt-(gamma_1+gamma_2.*t_mat+bar_gamma_2_plus.*(t_mat-tau).*(t_mat-tau>0)));
MPR_A = sigma_a.*(1 + (1./varrho2)).*ones(size(t_mat));
MPR_T = sigma_t.*(- omega_T + (1./varrho).*v0_dt);
MPR_Gamma = -(gamma_1+gamma_2.*t_mat+bar_gamma_2_plus.*(t_mat-tau).*(t_mat-tau>0)).*sigma_t.*(1 + (1./varrho));
MPR_OG =  sigma_a - omega_T.*sigma_t - (gamma_1+gamma_2.*t_mat+bar_gamma_2_plus.*(t_mat-tau).*(t_mat-tau>0)).*sigma_t;
MPU = (1./varrho2).*sigma_a+(1./varrho).*sigma_t.*(v0_dt-(gamma_1+gamma_2.*t_mat+bar_gamma_2_plus.*(t_mat-tau).*(t_mat-tau>0)));
MPU_A = (1./varrho2).*sigma_a.*ones(size(t_mat));
MPU_T = (1./varrho).*sigma_t.*(v0_dt);
MPU_Gamma = (1./varrho).*sigma_t.*(-(gamma_1+gamma_2.*t_mat+bar_gamma_2_plus.*(t_mat-tau).*(t_mat-tau>0)));
% relative_entropy = 0.5.*MPU.*MPU;
relative_entropy = 0.5.*(MPU_A.^2+MPU_T.^2+MPU_Gamma.^2);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 


save(filename2);


