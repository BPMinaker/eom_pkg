classdef marker < connect
    properties
        plot=[1;2;3;4;5;6];
        pltylabel='value []';
        label='';
    end
    methods  %% Constructor using structure input
        function obj=marker(in)
            obj@connect(in);
        end
    end    
end

