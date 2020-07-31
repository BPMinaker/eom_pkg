classdef actuator < connect
	properties
		gain=1;
		travel=[];
	end
	methods  %% Constructor using structure input
		function obj=actuator(varargin)
			obj@connect(varargin{:});
		end
	end
end
