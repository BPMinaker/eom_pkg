classdef wing < connect
    properties
        span=0;
        chord=0;
        airspeed=0;
        density=1.23;
        cxu=0;
        cxw=0;
        cxq=0;
        cyv=0;
        cyp=0;
        cyr=0;
        czu=0;
        czw=0;
        czq=0;
        clv=0;
        clp=0;
        clr=0;
        cmu=0;
        cmw=0;
        cmq=0;
        cnv=0;
        cnp=0;
        cnr=0;

% apparent mass, inertia
        a_mass=[0;0;0];
        a_mass_products=[0;0;0];
        a_momentsofinertia=[0;0;0];
        a_productsofinertia=[0;0;0]; % xy, yz, zx

    end
    methods  %% Constructor using structure input
        function obj=wing(varargin)
            obj@connect(varargin{:});
        end
    end    
end

