classdef triangle_5 < connect
    properties
        thickness=1;
        modulus=0;
        psn_ratio=0.5;
    end
    methods
        function obj=triangle_5(varargin)
            obj@connect(varargin{:});
        end
    end    
end

