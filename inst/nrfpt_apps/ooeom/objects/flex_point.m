classdef flex_point < connect
    properties
        stiffness=[0;0];
        damping=[0;0];
        rolling_axis=[0;0;0];
    end
    methods
        function obj=flex_point(varargin)
            %disp('flex point constructor');
            obj@connect(varargin{:});
        end
    end    
end
