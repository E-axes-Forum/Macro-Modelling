% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % EZ HJB Code
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

% scl = 1.0 solves model with full climate externality internalization
% scl = 0.2;
scl = 1.0;


directory = pwd;
filename = [directory, '\HJB_CCAP_EZ'];

if smartguess == 1
SmartGuess=load(filename,'v0','t_mat','t','B_t','O','G','xsolve');
end

filename2 = [directory, '\CCAP_HJB_EZ'];

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Productivity calibration %%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
kappa_O = 1;
kappa_G = 1;

eps = 0.75;

nu = 0.04;
O_init = 2.5;
oil_frac = 0.9;
G_init = O_init./(oil_frac)*(1-oil_frac);

alpha_O = 0.95;
alpha_G = alpha_O;
alpha = 1-alpha_O;

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Productivity calibration %%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

Omega = @(x) (x(1)./x(2)).^(1./alpha_O);
c1 = @(x) (1-alpha-nu).*(1./alpha_O).*(1./x(1)).^(1./alpha_O)./(nu)...
    .*(1+(Omega(x)).^(alpha_O.*eps./(alpha_O.*eps-1)));
c2 = @(x) (1./x(1)).^(1./alpha_O);
c3 = @(x) (Omega(x)).^(1./(alpha_O.*eps-1)).*(1./x(2)).^(1./alpha_O);
O_calibrate = @(x) (1./(c1(x)+c2(x)+c3(x))).^(alpha_O);
G_calibrate = @(x) (Omega(x)).^(alpha_O./(alpha_O.*eps-1)).*O_calibrate(x);


x0 = [100,33];
xsolve = fsolve(@(x) [O_init - O_calibrate(x),G_init - G_calibrate(x)],x0);
xsolve;
[O_init - O_calibrate(xsolve),G_init - G_calibrate(xsolve)];
A_O = xsolve(1);
A_G = xsolve(2);

L_O = (O_calibrate(xsolve)./A_O).^(1./alpha_O);
L_G = (G_calibrate(xsolve)./A_G).^(1./alpha_O);

L_C = 1 - L_O - L_G;
Y_init = 20;
A_C = (L_C.^(-(1-alpha-nu))).*(Y_init.*(kappa_O.*O_calibrate(xsolve).^eps+kappa_G.*G_calibrate(xsolve).^eps).^(-nu./eps));

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %  
% % SDR and Growth Parameters %%%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

rho = 0.00375;
mu_a = 0.005;
sigma_a = 0.01;

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % Climate and Uncertainty Parameters %%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

gammad = 21;


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % Climate and Uncertainty Parameters %%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

lambda = scl.*0.00173;
lambda_noscl = 0.00173;
sigma_t = 0.05;


gamma_1 = 0.00017675;
gamma_2 = 2.0 .* 0.0022 ;
gamma_2_plus = 2.0 .* 0.0197;
weight = 0.5;
% weight = 0.0;
bar_gamma_2_plus = gamma_2_plus * weight;
tau = 2;

relax2 = 0.75;
relax = 0.95;

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Convergence parameters
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
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
v0 = (1./(1-gammad)).*exp(-(1-gammad).*gamma_1.*t_mat);
% v0 = zeros(size(t_mat));
end

v1_initial = v0.*ones(size(t_mat)); %% initial guess
out = v0;

%%% for first iter
    v0 = v0.*ones(size(v0));
    v0 = reshape(out,size(v0));
    
    v0_dt = zeros(size(v0));
    v0_dt(2:end-1,:) = (1./(2.*ht)).*(v0(3:end)-v0(1:end-2));
    v0_dt(end,:) = (1./ht).*(v0(end)-v0(end-1));
    v0_dt(1,:) = (1./ht).*(v0(2)-v0(1));

        
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
    v0_dt(2:end-1,:) = (1./(2.*ht)).*(v0(3:end)-v0(1:end-2));
    v0_dt(end,:) = (1./ht).*(v0(end)-v0(end-1));
    v0_dt(1,:) = (1./ht).*(v0(2)-v0(1));

        
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
    B_t = lambda.*O_star;
    C_tt = 0.5.*sigma_t.^2.*ones(size(t_mat));
  
    D = rho.*log(A_C.*((1-(O_star./A_O).^(1./alpha_O)-(G_star./A_G).^(1./alpha_G)).^(1-alpha-nu)).*(((O_star.^eps).*kappa_O+(G_star.^eps).*kappa_G).^(nu./eps))) ...
        -(gamma_1+gamma_2.*t_mat+bar_gamma_2_plus.*(t_mat-tau).*(t_mat-tau>0)).*lambda.*O_star-0.5.*(gamma_2+bar_gamma_2_plus.*(t_mat-tau>0)).*(sigma_t.^2) ...
        +0.5.*(1-gammad).*((v0_dt).^2).*(sigma_t.^2)...
        +0.5.*(1-gammad).*((gamma_1+gamma_2.*t_mat+bar_gamma_2_plus.*(t_mat-tau).*(t_mat-tau>0)).^2).*(sigma_t.^2) ...
        - (1-gammad).*(v0_dt.*(gamma_1+gamma_2.*t_mat+bar_gamma_2_plus.*(t_mat-tau).*(t_mat-tau>0))).*(sigma_t.^2) ...
        +mu_a-gammad.*0.5.*sigma_a.^2;   
    
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
Y_dT(2:end-1,:) = (1./(2.*ht)).*(Y(3:end,:)-Y(1:end-2,:));
Y_dT(end,:) = (1./ht).*(Y(end,:)-Y(end-1,:));
Y_dT(1,:) = (1./ht).*(Y(2,:)-Y(1,:));

Y_dTT = zeros(size(Y));
Y_dTT(2:end-1,:) = (1./(ht.^2)).*(Y(3:end,:)+Y(1:end-2,:)-2.*Y(2:end-1,:));
Y_dTT(end,:) = (1./(ht.^2)).*(Y(end,:)+Y(end-2,:)-2.*Y(end-1,:));
Y_dTT(1,:) = (1./(ht.^2)).*(Y(3,:)+Y(1,:)-2.*Y(2,:));
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
v_null = (1./(1-gammad)).*(exp(v0).^(1-gammad));
v_dT = (1-gammad).*v_null.*v0_dt;
v_dTT = (1-gammad).*v_null.*(v0_dtt+(1-gammad).*(v0_dt.^2));

J = v_null;
J_T = v_dT;
J_TT = v_dTT;

% MPR                 
h_J = -rho.*log((1-gammad).*J) + rho.*(1-gammad).*log(Y) - rho;
h_C = rho.*((1-gammad).*J).*(Y.^(-1));

omega_T = -(Y_dT)./Y + (J_T./J);
omega_TT = 2.*(Y_dT./Y).^2 - (Y_dTT./Y) - 2.*(Y_dT./Y).*(J_T./J) + (J_TT./J);

r_t = -h_J + gammad.*(mu_a - 0.5.*(1+gammad).*sigma_a.^2) ...
      -omega_T.*(lambda.*O)-0.5.*omega_TT.*(sigma_t.^2)...
      -gammad.*(gamma_1+gamma_2.*t_mat+bar_gamma_2_plus.*(t_mat-tau).*(t_mat-tau>0)).*lambda.*O...
      -gammad.*0.5.*(gamma_2+bar_gamma_2_plus.*(t_mat-tau>0)).*(sigma_t.^2)...
      -(gammad.^2).*((gamma_1+gamma_2.*t_mat+bar_gamma_2_plus.*(t_mat-tau).*(t_mat-tau>0)).^2).*(sigma_t.^2);             
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %        

MPR = gammad.*sigma_a - omega_T.*sigma_t - gammad.*(gamma_1+gamma_2.*t_mat+bar_gamma_2_plus.*(t_mat-tau).*(t_mat-tau>0)).*sigma_t;
MPR_A = gammad.*sigma_a.*ones(size(t_mat));
MPR_T = - omega_T.*sigma_t;
MPR_Gamma = - gammad.*(gamma_1+gamma_2.*t_mat+bar_gamma_2_plus.*(t_mat-tau).*(t_mat-tau>0)).*sigma_t;

save(filename2);