classdef tire < connect
    properties
        roadspeed=0;
        cy=0;
        kz=0;
    end
    methods  %% Constructor using structure input
        function obj=tire(in)
            obj@connect(in);
        end
    end    
end

