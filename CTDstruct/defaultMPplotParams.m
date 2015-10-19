function PP=defaultMPplotParams(MP,whichtype)
%function PP=defaultMPplotParams(whichtype)
%Deliver a PP for passing in to the function GenericMPplot1.
%
%I've predefined some typical variables and labels, and the user can 
%select from these and adjust some parameters using the PP structure.
%
% 1    'MP.Tide'
% 2    'MP.u'
% 3    'MP.v'
% 4    'real(log10(MP.strainEULs))'
% 5    'real(log10(MP.invri))'
% 6    'log10(MP.eps2)'
% 7    'real(log10(MP.n2))'
% 8    'log10(MP.k)'
% 9    'MP.uzs'
% 10   'MP.vzs'
% 11   'log10(MP.shearsm.^2)'
% 12    'MP.Current'
% 13    mean epsilon
% 14    t
% 15    th
% 16    s
% 17    sgth
% 18    dox
% 19    etaEUL

PP.tmin=min(MP.yday);
PP.tmax=max(MP.yday);
PP.zmin=min(MP.z);
PP.zmax=max(MP.z);
PP.figname='multpan1';
if whichtype==1
    PP.plind=[12 3 4 10 11 5 6 13]; %tide, V, strain, v shear, shear^2, inv Ri, eps, mean eps
elseif whichtype==2
    PP.plind=[12 3 4 10 11 5 6]; %tide, V, strain, v shear, shear^2, inv Ri, eps
elseif whichtype==3
    PP.plind=[14 16 2 3]; %t,s,u,v
elseif whichtype==4
    PP.plind=[14 16 17 2 3]; %t,s,sgth,u,v
elseif whichtype==5
    PP.plind=[14 16 18 2 3]; %t,s,dox,u,v
elseif whichtype==6
    PP.plind=[1 14 16 18 2 3]; %tide, t,s,dox,u,v
elseif whichtype==7
    PP.plind=[1 14 16 18 3 6 13]; %tide, t,s,dox,v, eps, mean eps
elseif whichtype==8
    PP.plind=[2 3 7 6 13]; %u, v,N2,eps, mean eps
elseif whichtype==9
    PP.plind=[2 3 19 6 13]; %u, v,eta,eps, mean eps
end

%PP.plind=[3 4 9 11 5 6];

PP.scut=5;
PP.fignum=1;

tempmin=min(min(MP.t));
tempmax=max(max(MP.t));
salmin=min(min(MP.s));
salmax=max(max(MP.s));
densmin=min(min(MP.sgth));
densmax=max(max(MP.sgth));
if isfield(MP,'dox')
    omin=min(min(MP.dox));
    omax=max(max(MP.dox));
else
    omin=0;
    omax=10;
end

if isfield(MP,'d_Iso')
PP.wh=30:30:length(MP.zvals);
overlay1='hold on;h=plot(MP.yday,MP.d_Iso(PP.wh,:),''k-'');lc(h,0.6*[1 1 1]);hold off';
else
    overlay1='';
end

% if whichtype==3 | whichtype==4
%     overlay1='';
% end
% 

PP.strs={'MP.Tide';'MP.u';'MP.v'; ... %1,2,3
    'real(log10(MP.strainEULs))';'real(log10(MP.invri))';'log10(MP.eps2)';  ... %4,5,6
    'real(log10(MP.n2))';'log10(MP.k)'; 'MP.uzs'; ... %7,8,9
    'MP.vzs';'log10(MP.shearsm.^2)';'MP.Current'; ...%10,11,12
    'log10(nanmean(MP.eps2))'; 'MP.t'; ;'MP.th'; ... %13, 14, 15
    'MP.s'; 'MP.sgth'; 'MP.dox';'MP.etaEUL'};
%strs={'MP.tide';'MP.u';'MP.v';'real(log10(MP.strainEULs))';'real(log10(MP.invri))';'log10(MP.eps2)';   'real(log10(MP.n2))';'log10(MP.k)'; 'MP.uzs';  'MP.vzs';'log10(MP.shearsm.^2)';  'riinvl';'ri'};
PP.labs={'SL';'U';     'V'; ...
    'log10(\gamma)'; 'Ri';'log_{10} \epsilon';...
    'N^2';  'K_\rho';'U_z';... %789
    'V_z';'S^2';'U_{tide}';... %10-11-12
    'log_{10} <\epsilon>'; 'T'; '\theta';...
    'S'; '\sigma_\theta'; 'DOX'; '\eta'};
PP.units={'m';'ms^{-1}';'ms^{-1}';...
    'log10(\gamma)';'log_{10}Ri^{-1}';'log_{10} \epsilon / W kg^{-1}';...
    'log_{10} N^2 / s^{-2}';'log_{10} K / m^2s^{-1}';'s^{-1}';...
    's^{-1}';'log_{10} S^2 / s^{-2}';'ms^{-1}';...
    'log_{10} <\epsilon> / W kg^{-1}'; '^oC';'^oC';...
    'psu'; 'kg m^{-3}'; 'mg / l'; 'm'};
PP.lims={[-4 4];[-.3 .3];[-.3 .3];...
    [-1 1];[-1 log10(4)];[-8 -6];...
    [-6 -3];[-6 -2];[-.01 .01];...
    [-.01 .01];[-6 -3];[-0.5 0.5];...
    [-9 -6]; [tempmin tempmax];[tempmin tempmax];
    [salmin salmax]; [densmin densmax] ;[omin omax];[-100 100]};

PP.zlims={[PP.zmin PP.zmax];[PP.zmin PP.zmax];[PP.zmin PP.zmax];...
    [PP.zmin PP.zmax];[PP.zmin PP.zmax];[PP.zmin PP.zmax];...
    [PP.zmin PP.zmax];[PP.zmin PP.zmax];[PP.zmin PP.zmax];...
    [PP.zmin PP.zmax];[PP.zmin PP.zmax];[PP.zmin PP.zmax];
    [PP.zmin PP.zmax];[PP.zmin PP.zmax];[PP.zmin PP.zmax];
    [PP.zmin PP.zmax];[PP.zmin PP.zmax];[PP.zmin PP.zmax];
    [PP.zmin PP.zmax];[PP.zmin PP.zmax];[PP.zmin PP.zmax]};

PP.tlims={[PP.tmin PP.tmax];[PP.tmin PP.tmax];[PP.tmin PP.tmax];...
    [PP.tmin PP.tmax];[PP.tmin PP.tmax];[PP.tmin PP.tmax];...
    [PP.tmin PP.tmax];[PP.tmin PP.tmax];[PP.tmin PP.tmax];...
    [PP.tmin PP.tmax];[PP.tmin PP.tmax];[PP.tmin PP.tmax];...
    [PP.tmin PP.tmax];[PP.tmin PP.tmax];[PP.tmin PP.tmax];...
    [PP.tmin PP.tmax];[PP.tmin PP.tmax];[PP.tmin PP.tmax]};

PP.tvecs={'MP.yday';'MP.yday';'MP.yday';... %123
    'MP.yday';'MP.yday';'MP.yday';...   %456
    'MP.yday';'MP.yday';'MP.yday';...   %789
    'MP.yday';'MP.yday';'MP.yday';...   %101112
    'MP.yday';'MP.yday';'MP.yday';...   %131415
    'MP.yday';'MP.yday';'MP.yday';...    %161718
    'MP.yday';'MP.yday';'MP.yday';};    %192021

PP.zvecs={'MP.z';'MP.z';'MP.z';...
    'MP.z';'MP.z';'MP.z';...
    'MP.z';'MP.z';'MP.z';...
    'MP.z';'MP.z';'MP.z';...
    'MP.z';'MP.z';'MP.z';...
    'MP.z';'MP.z';'MP.z';...
    'MP.z';'MP.z';'MP.z'};

PP.sks={1 1 1 ...
    1 1 1 ...
    1 1 1 ...
    1 1 1 ...
    1 1 1 ...
    1 1 1 1};

PP.killcb={1 0 0 ...
    0 0 0 ...
    0 0 0 ...
    0 0 1 ...
    0 0 0 ...
    0 0 0 ...
    0};

PP.timeseriesplot={1 0 0 ...
    0 0 0 ...
    0 0 0 ...
    0 0 1 ...
    1 0 0 ...
    0 0 0 ...
    0};
PP.smooth={0 0 0 ...
    0 0 0 ...
    0 0 0 ...
    0 0 0 ...
    0 0 0 ...
    0 0 0 ...
    0 0 0 ...
    0 0 0};

PP.plotcommands={'';overlay1;overlay1;...
    overlay1;overlay1;overlay1;...
    overlay1;overlay1;overlay1;...
    overlay1;overlay1;overlay1;...
    overlay1;overlay1;overlay1;...
    overlay1;overlay1;overlay1;...
    overlay1;overlay1;overlay1;...
    overlay1;overlay1;overlay1};
