classdef rigid_point < connect
    properties
        rolling_axis=[0;0;0];
    end
    methods  %% Constructor using structure input
        function obj=rigid_point(varargin)
            obj@connect(varargin{:});
        end
    end    
end

