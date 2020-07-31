classdef sensor < connect
    properties
        gain=1;
        order=1;  %% [1 - position, 2- velocity, 3- acceleration ]
        frame=1;  %% [ 0 - local, 1 - global]
        actuator='ground';
		actuator_number=0;
    end
    methods  %% Constructor using structure input
        function obj=sensor(varargin)
            obj@connect(varargin{:});
        end
    end    
end

