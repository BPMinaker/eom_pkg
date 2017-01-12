classdef nh_point < connect
    properties
        rolling_axis=[0;0;0;];
    end
    methods  %% Constructor using structure input
        function obj=nh_point(varargin)
            obj@connect(varargin{:});
        end
    end    
end

