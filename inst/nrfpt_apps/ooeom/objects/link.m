classdef link < connect
    properties 
    end
    methods  %% Constructor using structure input
        function obj=link(varargin)
            %disp('link constructor');
            obj@connect(varargin{:});
        end
    end
end
