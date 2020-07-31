classdef item
	properties
		name;
		group;
	end

	methods
		function obj=item(name,varargin)
			%disp('item constructor');
			validateattributes(name,{'char'},{'nonempty'},'item')
			obj.name=name;
			if(nargin>1)
				validateattributes(varargin{1},{'char'},{'nonempty'},'item')
				obj.group=varargin{1};
			else
				obj.group=class(obj);
			end
		end
		function display(obj)
			disp([class(obj) ': ' obj.name]);
		end
    end
end
