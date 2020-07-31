classdef beam < connect
    properties
        stiffness=0;
    end
    methods  %% Constructor using structure input
        function obj=beam(varargin)
            obj@connect(varargin{:});
        end
    end    
end
