classdef spring < connect
    properties 
        stiffness=0;
        damping=0;
        preload=[];
        inertia=0;
    end
    methods
        function obj=spring(varargin)
            obj@connect(varargin{:});
        end
    end
end

